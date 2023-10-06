class ApplicationController < ActionController::Base
  self.page_cache_directory = "#{Rails.root}/public/cached_pages"
  protect_from_forgery with: :exception
  # before_action :test_referer

  # def test_referer
  #   request.env['HTTP_REFERER'] = 'https://www.inclusivegrowthleeds.com/case-studies-0'
  # end
  def self.expire_about
    expire_page('about.html')
  end

  def self.expire_home
    expire_page('index.html')
  end
end
