class NewsController < ApplicationController
  before_action :get_topics

  def index
    @news = News.all.where(visible: true).page(params[:page])
  end

  def show
    @news_item = News.find_by_id params[:id]
  end


  def get_topics
    @topics = Topic.all.limit(6).order(position: :asc)
  end

end
