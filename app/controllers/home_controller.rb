class HomeController < ApplicationController
  caches_page :index
  caches_page :privacy
  caches_page :accessibility
  before_action :get_topics

  def index
    @welcome = Page.find_by(name: "welcome")
    @news = News.all.where(visible: true).order(updated_at: :desc).limit(16)
    @stories = []
    #comment out stories temp
    #@stories = Story.all.where(visible: true).order(updated_at: :desc).limit(16)
    render layout: "front"
  end

  def get_topics
    @topics = Topic.all.limit(6).order(position: :asc)
  end


end
