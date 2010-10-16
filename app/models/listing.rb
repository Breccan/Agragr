class Listing < ActiveRecord::Base
  belongs_to :feed
  has_many :reddit_listings
end
