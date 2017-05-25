class HomeController < ApplicationController
  def index
    # flash[:alert] = "fasac"
    # flash[:notice] = "notice ! fasac"
    # get recommendations 
    # get topics
    @recommended = Course.all.limit(3)
    @topics =  Topic.all.select { | t | t.has_courses? }
  end

  def about
  end
end
