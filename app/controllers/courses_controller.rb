class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])

    route = params[:route] || "bus"
    #todo check for geocoding first and return if cannot find
    if params[:near] &&  params[:lon_lat]
      if route == "walk"
        @directions = Rails.cache.fetch(@course.id.to_s + params[:lon_lat] + route, :expires => 14.days) do
          @course.walk_route({:lon_lat => params[:lon_lat]}) if route == "walk"
        end
      elsif route == "bus"
        @directions = Rails.cache.fetch(@course.id.to_s + params[:lon_lat] + route, :expires => 14.days) do
          @course.transit_route({:lon_lat => params[:lon_lat]}) if route == "bus"
        end
      else
        @directions = nil
      end
    end

  end

  def index
    @recommended = Course.all.limit(3)
    @lon_lat = nil
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      @courses = Course.where(subject: @topic.subjects).page(params[:page])
    elsif params[:provider_id]
      @provider = Provider.find(params[:provider_id])
      @courses  = @provider.courses.page(params[:page])
    elsif params[:venue_id]
      @venue = Venue.find(params[:venue_id])
      @courses = @venue.courses.page(params[:page])
    elsif params[:q]
      @lon_lat = Course.get_lon_lat(params[:near])
      flash.now[:notice] = "Sorry could not find a location for '#{params[:near]}' please try again" if !params[:near].blank? && @lon_lat.nil?

      @courses = Course.search(params[:q], {lon_lat: @lon_lat, sort: params[:sort], page: params[:page]})
    else
      @courses = Course.all.limit(50)
    end
    
  end
end
