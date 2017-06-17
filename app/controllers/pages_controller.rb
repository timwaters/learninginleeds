class PagesController < ApplicationController

  def about
    @page = Page.where(name: 'about').first
  end

end
