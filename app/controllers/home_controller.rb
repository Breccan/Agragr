class HomeController < ApplicationController
   layout 'application'
   before_filter :set_filters
   before_filter :set_topics

  def index
    @topics = Topic.all
    @filters = Link::Filters
    if request.xhr?
      params[:since] ||= 2.days.ago.to_i
      @links = Link.build_filter_scope(session).order("links.created_at DESC").where(["links.created_at > ?", Time.at(params[:since].to_i+1)]).limit(35).all
      render :partial => "links"
    else
      @links = Link.build_filter_scope(session).paginate :page => params[:page], :order => 'links.created_at DESC'
    end
  end

  def add_topic
    topic = Topic.where(["name = ?", params[:topic_name]]).first
    session[:topics] << topic.id
    if params[:since].blank?
      render :nothing => true
      return
    else
      @links = Link.build_filter_scope(session).order("links.created_at DESC").where(["links.created_at > ? AND links.topic_id = ?", Time.at(params[:since].to_i+1), topic.id]).all
      render :partial => "home/links"
      return
    end
  end

  def remove_topic
    topic = Topic.where(["name = ?", params[:topic_name]]).first
    session[:topics].delete(topic.id)
    render :nothing => true
  end

  def add_filter
    session[:filters] << params[:filter_name].to_sym
    render :nothing => true
  end

  def remove_filter
    session[:filters].delete(params[:filter_name])
    render :nothing => true
  end

  private
  def set_filters
    if session[:filters].blank? && session[:values_set].blank?
      session[:filters] = [:nsfw]
    end
    @active_filters = get_filters(session[:filters])
  end
  
  def get_filters(filters)
    filters = filters.collect { |f| [f, Link::Filters[f]] }
    Hash[*filters.flatten]
  end

  def set_topics
    if session[:topics].blank?
      session[:topics] = Topic.all.collect { |t| t.id }
      session[:values_set] = "true"
    end
  end

end
