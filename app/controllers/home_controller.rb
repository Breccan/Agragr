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
    topic = Topic.where(["name = ?", params[:topic_name]])
    session[:topics] << topic.id
    if params[:since].blank?
      render :success
      return
    else
      @links = Link.build_filter_scope(session).order("links.created_at DESC").where(["links.created_at > ? AND links.topic_id = ?", Time.at(params[:since].to_i+1), topic.id]).all
      render :partial => "home/links"
      return
    end
  end

  def remove_topic
    topic = Topic.where(["name = ?", params[:topic_name]])
    session[:topics].delete(topic.id)
    puts "THAT'S A BINGO!"
    render :success
  end

  def add_filter
    session[:filters] << Link::Filters[params[:filter_name]]
    render :success
  end

  def remove_filter
    session[:filters].delete(Link::Filters[params[:filter_name]])
    render :success
  end

  private
  def set_filters
    if session[:filters].blank?
      session[:filters] = [Link::Filters[:nsfw]]
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
