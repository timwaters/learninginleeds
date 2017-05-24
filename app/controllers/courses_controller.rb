class CoursesController < ApplicationController
  def show
  end

  def index
    if params[:topic]
      @topic = Topic.find(params[:topic].to_i)
      @courses = Course.where(subject: @topic.subjects)
    else
      @courses = Course.all.limit(50)
    end
  end
end
