class PagesController < ApplicationController
  caches_page :about
  before_action :get_topics
  
  def about
    @page = Page.find_by(name: 'about')
  end

  def get_topics
    @topics = Topic.all.limit(6).order(position: :asc)
  end

end
