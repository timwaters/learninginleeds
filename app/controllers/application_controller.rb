class ApplicationController < ActionController::Base
  self.page_cache_directory = "#{Rails.root}/public/cached_pages"
  protect_from_forgery with: :exception

  def self.expire_about
    expire_page('about.html')
  end

  def self.expire_home
    expire_page('index.html')
  end
end
