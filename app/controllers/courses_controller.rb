class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])
  end

  def index
    @recommended = Course.all.limit(3)
#TODO pagination etc
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
      @courses = Course.search(params[:q], {near: params[:near], sort: params[:sort], page: params[:page]})
    else
      @courses = Course.all.limit(50)
    end
    
  end
end
