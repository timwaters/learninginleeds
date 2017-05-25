class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])
  end

  def index
  #for venue
  #for provider
  #for topic
    if params[:topic]
      @topic = Topic.find(params[:topic])
      @courses = Course.where(subject: @topic.subjects)
    else
      @courses = Course.all.limit(50)
    end
  end
end
