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

  scope :exclude_nsfw, lambda {
    joins(:listings).joins("LEFT OUTER JOIN reddit_listings ON listings.id = reddit_listings.listing_id").where(["reddit_listings.nsfw = ? OR reddit_listings.nsfw IS NULL", false])
  }
  scope :exclude_self, lambda {
    joins(:listings).joins("LEFT OUTER JOIN reddit_listings ON listings.id = reddit_listings.listing_id").where(["reddit_listings.self = ? OR reddit_listings.self IS NULL", false])
  }
  scope :exclude_images, lambda {
    where(["links.url NOT #{LIKE} ? AND links.url NOT #{LIKE} ?", '%jpg', '%png' ])
  }
  scope :exclude_fuck, lambda {
    where(["links.title NOT #{LIKE} ?", '%fuck%' ])
  }
  scope :exclude_video, lambda {
    where(["links.url NOT #{LIKE} ?", '%youtube%' ])
  }
  scope :exclude_pets, lambda {
    where(["links.title NOT #{LIKE} ? AND links.title NOT #{LIKE} ?", '%my cat%', '%my dog%' ])
  }
  scope :exclude_dating, lambda {
    where(["links.title NOT #{LIKE} ? AND links.title NOT #{LIKE} ?", '%girlfriend%', '%boyfriend%' ])
  }
  scope :exclude_dae, lambda {
    where(["links.title NOT #{LIKE} ? AND links.title NOT #{LIKE} ?", '%does anyone else%', '%dae%' ])
  }
  scope :exclude_memes, lambda {
    where(["links.title NOT #{LIKE} ?", '%keanu%' ])
  }
  scope :exclude_tweets, lambda {
    where(["links.url NOT #{LIKE} ?", '%twitter.com%' ])
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
    filters.each do |filter|
      k = "exclude_#{filter.to_s}"
      puts k
      combined_scope = combined_scope.send(k)
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
