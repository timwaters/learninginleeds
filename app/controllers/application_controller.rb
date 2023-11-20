class ApplicationController < ActionController::Base
  self.page_cache_directory = "#{Rails.root}/public/cached_pages"
  protect_from_forgery with: :exception
  before_action :store_referer

  def store_referer
    if request.referer && URI(request.referer).host && !AppConfig["app_hosts"].include?(URI(request.referer).host)
      session[:referer] = request.referer
    end
  end

  def self.expire_about
    expire_page('about.html')
  end

  def self.expire_home
    expire_page('index.html')
  end
end
