class Link < ActiveRecord::Base

  belongs_to :topic
  has_many :listings

  Filters = {
    :memes   => 'overused memes',
    :dae     => '"does anyone else"',
    :pets    => '"my dog", "my cat"',
    :dating  => '"my girlfriend"',
    :tweets  => 'headline only',
    :images  => 'image only',
    :video   => "video links",
    :self    => 'self posts',
    :fuck    => 'naughty words',
    :nsfw    => 'adult content',
  }

  scope :exlude_nsfw, lambda {
    joins(:listings => :reddit_listings).where(["reddit_listings.nsfw = ?", false])
  }
  scope :exlude_self, lambda {
    joins(:listings => :reddit_listings).where(["reddit_listings.self = ?", false])
  }
  scope :exclude_images, lambda {
    joins(:listings => :reddit_listings).where(["reddit_listings.url = ?", /.jpg/])
  }
  scope :limit_topics, lambda { |topic_ids|
    where("links.topic_id IN (#{topic_ids.join(', ')})")
  }

  def self.build_filter_scope(prefs)
    combined_scope = order('links.created_at DESC').includes(:topic).includes(:listings)
    combined_scope = load_filter_scopes(prefs[:filters], combined_scope)
    combined_scope.limit_topics(prefs[:topics])
  end

  def self.load_filter_scopes(filters, combined_scope)
    return combined_scope
    filters.each do |filter|
      k = 'exclude_#{filter}'
      combined_scope = combined_scope[k]
    end
   combined_scope 
  end

  def url_count(feed_type)
    self.listings.where(["feed_type = ?", feed_type]).count
  end
  def url_targets(feed_type)
    self.listings.where(["feed_type = ?", feed_type]).all.collect { |l| l.comments_url }
  end


  def domain
    match = self.url.match(/http[s]?:\/\/([^\/]*)/)
    return nil if !match
    subs = match[1].split('.')
    subs.shift() if subs[0] == 'www'
    subs.join('.')
  end

end
