class ProvidersController < ApplicationController
  caches_page :index
  before_action :get_topics

  def index
    @providers = Provider.all.where(visible: true).order(:name)
  end

  def get_topics
    @topics = Topic.all.limit(6).order(position: :asc)
  end
end