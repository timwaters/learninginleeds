class PagesController < ApplicationController
  self.page_cache_directory = -> { Rails.root.join("public", "lil") }
  caches_page :about
  
  def about
    @page = Page.find_by(name: 'about')
  end

end
