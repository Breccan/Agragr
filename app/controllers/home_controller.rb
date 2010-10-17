class HomeController < ApplicationController
   layout 'application'
   before_filter :set_filters
   before_filter :set_topics

  def index
    @topics = Topic.all
    @filters = Link::Filters
    if request.xhr?
      params[:since] ||= 2.days.ago
      @links = Link.build_filter_scope(session).order("created_at DESC").where(["created_at > ?", params[:since].to_i]).limit(35).all
      render :partial => "links"
    else
      @links = Link.build_filter_scope(session).paginate :page => params[:page], :order => 'created_at DESC'
    end
  end

  def add_topic
    topic = Topic.where(["name = ?", params[:topic_name]])
    session[:topics] << topic.id
    if params[:since].blank?
      render :success
    else
      @links = Link.build_filter_scope(session).order("created_at DESC").where(["created_at > ? AND topic_id = ?", params[:since], topic.id]).all
      render :partial => "links"
    end
  end

  def remove_topic
    topic = Topic.where(["name = ?", params[:topic_name]])
    session[:topics].delete(topic.id)
    render :success
  end

  def add_filter
    session[:filters]. << Link::Filters[params[:filter_name]]
    render :success
  end

  def remove_filter
    session[:filters].delete(Link::Filters[params[:filter_name]])
    render :success
  end

  private
  def set_filters
    if session[:filters].blank?
      session[:filters] = [Link::Filters["NSFW"]]
    end
    @active_filters = get_filters(session[:filters])
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
