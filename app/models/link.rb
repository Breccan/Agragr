class Link < ActiveRecord::Base

  belongs_to :topic
  has_many :listings

  Filters = {"NSFW" => 1, "Self" => 2, "Image" => 3, "Youtube" => 4, "does anyone else..." => 5,
             '"My dog", "My cat"' => 6}

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
    combined_scope = order('links.created_at DESC')
    combined_scope = load_filter_scopes(prefs[:filters], combined_scope)
    combined_scope.limit_topics(prefs[:topics])
  end

  def self.load_filter_scopes(filters, combined_scope)
    filters.each do |filter|
      case filter
      when 1
        combined_scope = combined_scope.exlude_nsfw
      when 2
        combined_scope = combined_scope.exlude_self
      end
    end
   combined_scope 
  end


  def domain
    match = self.url.match(/http[s]?:\/\/([^\/]*)/)
    return nil if !match
    subs = match[1].split('.')
    subs.shift() if subs[0] == 'www'
    subs.join('.')
  end

end
