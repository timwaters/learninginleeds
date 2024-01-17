class CoursesController < ApplicationController
  before_action :get_topics

  def show
    @course = Course.find_by(lcc_code: params[:lcc_code])
    if @course.nil?
      flash[:notice] = "Sorry. Could not find that course."
      redirect_to :action => :index and return
    end

    route = params[:route] || "bus"
    if params[:near] && params[:lon_lat].blank?
      params[:near] = I18n.transliterate params[:near] if params[:near]
      lon_lat =  Course.get_lon_lat(params[:near])
      
      if lon_lat.nil?
        params[:lon_lat] = nil
      else
        params[:lon_lat] = "#{lon_lat[:longitude]},#{lon_lat[:latitude]}"
      end
    end
    if params[:near] && params[:lon_lat]
      @directions = nil
      if route == "walk"

        @directions = Rails.cache.fetch(@course.id.to_s + params[:lon_lat] + route, :expires => 14.days) do
          begin 
            @course.walk_route({:lon_lat => params[:lon_lat]})
          rescue ApiError => e
            logger.error "Api Error #{e.message}"
            break
          rescue HTTParty::Error => e
            logger.error "HttpParty Error #{e.message}"
            break
          rescue StandardError => e
            logger.error "Standard Error  #{e.message}"
            logger.error(e.backtrace)
            break
          end
        end

      elsif route == "bus"
        if AppConfig["transit_routing"] == "bing"
          @directions = Rails.cache.fetch(@course.id.to_s + params[:lon_lat] + route + "bing", :expires => 14.days) do
            begin
              @course.transit_route_bing({:lon_lat => params[:lon_lat]}) 
            rescue ApiError => e
              logger.error "Api Error #{e.message}"
              break
            rescue HTTParty::Error => e
              logger.error "HttpParty Error #{e.message}"
              break
            rescue StandardError => e
              logger.error "Standard Error  #{e.message}"
              logger.error(e.backtrace)
              break
            end
          end 
        else
          @directions = Rails.cache.fetch(@course.id.to_s + params[:lon_lat] + route + "tapi", :expires => 14.days) do
            begin  
              @course.transit_route_tapi({:lon_lat => params[:lon_lat]}) 
            rescue ApiError => e
              logger.error "Api Error #{e.message}"
              break
            rescue HTTParty::Error => e
              logger.error "HttpParty Error #{e.message}"
              break
            rescue StandardError => e
              logger.error "Standard Error  #{e.message}"
              logger.error(e.backtrace)
              break
            end
          end 
        end
        
      else
        @directions = nil
      end
    end

  end

  def index
    @news = News.all.where(visible: true).order(updated_at: :desc).limit(16)
    @lon_lat = nil
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      @courses = Course.category_search(@topic.categories).page(params[:page])
    elsif params[:provider_id]
      @provider = Provider.find(params[:provider_id])
      @courses  = @provider.courses.page(params[:page])
    elsif params[:venue_id]
      @venue = Venue.find(params[:venue_id])
      @courses = @venue.courses.page(params[:page])
    elsif params[:q]
      params[:near] = I18n.transliterate params[:near] if params[:near]
      @lon_lat = Course.get_lon_lat(params[:near])
      flash.now[:notice] = "Sorry could not find a location for '#{params[:near]}' please try again" if !params[:near].blank? && @lon_lat.nil?
      
      sort = "relevance"
      if params[:sort].blank? && !@lon_lat.nil?
        sort = "distance"
      elsif !params[:sort].blank?
        sort = params[:sort]
      end
      params[:sort] = sort
      
      @courses = Course.search(params[:q], {lon_lat: @lon_lat, sort: sort, page: params[:page]})
    else
      @courses = Course.all.page(params[:page])
    end
    
  end

  def get_topics
    @topics = Topic.all.limit(6).order(position: :asc)
  end

end
