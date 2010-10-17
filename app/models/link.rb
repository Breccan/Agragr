class Link < ActiveRecord::Base
  belongs_to :topic
  has_many :listings

  Filters = {"NSFW" => 1, "Self" => 2, "Image" => 3, "Youtube" => 4, "does anyone else..." => 5,
             '"My dog", "My cat"' => 6}

  def self.build_filter_scope(prefs)
    combined_scope = order('created_at DESC')
    #combined_scope = load_filter_scopes(prefs[:topics], combined_scope)
    #combined_scope = load_topic_scopes(prefs[:filters], combined_scope)
    combined_scope
    
  end

  def self.load_filter_scopes(filters, combined_scope)
    filters.each do |filter|
      case filter
      when 1
        combined_scope = combined_scd
      end
    end
    
  end

  def self.load_topic_scopes(topics, combined_scope)
  end

end
