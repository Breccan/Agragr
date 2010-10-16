class HomeController < ApplicationController
   layout 'application'
  def index
    @links = Link.paginate :page => params[:page], :order => 'created_at DESC'
  end
  
end
