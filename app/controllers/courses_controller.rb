class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])
  end

  def index
#pagination etc
    if params[:topic_id]
      @topic = Topic.find(params[:topic_id])
      @courses = Course.where(subject: @topic.subjects)
    elsif params[:provider_id]
      @provider = Provider.find(params[:provider_id])
      @courses  = @provider.courses
    elsif params[:venue_id]
      @venue = Venue.find(params[:venue_id])
      @courses = @venue.courses
    elsif params[:q]
      @courses = Course.where('title LIKE ?', "%#{params[:q]}%")
    else
      @courses = Course.all.limit(50)
    end
  end
end
