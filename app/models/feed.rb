class Feed < ActiveRecord::Base
  belongs_to :topic
  has_many :listings
  RedditFeeds = ["Programming"]
  
end
