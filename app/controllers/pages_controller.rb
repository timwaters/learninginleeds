class PagesController < ApplicationController
  caches_page :about
  
  def about
    @page = Page.find_by(name: 'about')
  end

end
