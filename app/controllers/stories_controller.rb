class StoriesController < ApplicationController
  before_action :get_topics

  def index
    @stories = Story.all.page(params[:page])
  end

  def show
    @story = Story.find_by_id params[:id]
  end


  def get_topics
    @topics = Topic.all.limit(6).order(position: :asc)
  end

end
