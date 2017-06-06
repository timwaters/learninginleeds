class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])
  end

  def index
    @recommended = Course.all.limit(3)
    
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      @courses = Course.where(subject: @topic.subjects).page
    elsif params[:provider_id]
      @provider = Provider.find(params[:provider_id])
      @courses  = @provider.courses.page
    elsif params[:venue_id]
      @venue = Venue.find(params[:venue_id])
      @courses = @venue.courses.page
    elsif params[:q]
      @courses = Course.search(params[:q], {near: params[:near], sort: params[:sort], page: params[:page]})
    else
      @courses = Course.all.page
    end
    
  end
end
