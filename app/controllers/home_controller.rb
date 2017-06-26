class HomeController < ApplicationController
  def index
    # flash[:alert] = "fasac"
    # flash[:notice] = "notice ! fasac"
    # get recommendations 
    # get topics
    @news = News.all.order(updated_at: :desc).limit(3)
    @topics =  Topic.all.limit(6).select { | t | t.has_courses? }
  end


end
