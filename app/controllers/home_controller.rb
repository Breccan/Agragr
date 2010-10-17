class HomeController < ApplicationController
   layout 'application'
   before_filter :set_filters
   before_filter :set_topics

  def index
    @links = Link.build_filter_scope(session).paginate :page => params[:page], :order => 'created_at DESC'
    @topics = Topic.all
    @filters = Link::Filters
    #request.xhr
  end

  def add_topic

  end

  def remove_topic
  end

  def add_filter

  end

  def remove_filter
  end

  private
  def set_filters
    if session[:filters].blank?
      session[:filters] = [Link::Filters["NSFW"]]
    end
    @active_filters => get_filters(session[:filters])
  end
  
  def get_filters(filters)
    inverted_filters = Link::Filters.invert
    filters.collect { |f| inverted_filters[f] }
  end

  def set_topics
    if session[:topics].blank?
      session[:topics] = Topic.all.collect { |t| t.id }
    end
  end

end
