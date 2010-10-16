class Listing < ActiveRecord::Base
  belongs_to :feed
  belongs_to :link
  has_many :reddit_listings
end
