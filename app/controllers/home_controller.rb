class HomeController < ApplicationController
  caches_page :index
  caches_page :privacy
  
  def index
    @welcome = Page.find_by(name: "welcome")
    @news = News.all.order(updated_at: :desc).limit(3)
    @topics =  Topic.all.limit(6).order(position: :asc)
  end


end
