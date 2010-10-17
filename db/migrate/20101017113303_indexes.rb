class Indexes < ActiveRecord::Migration
  def self.up
    add_index :links, :url
    add_index :listings, :link_id
    add_index :topics, :name
    add_index :reddit_listings, :listing_id
    add_index :reddit_listings, :nsfw
    add_index :reddit_listings, :self
  end

  def self.down
    remove_index :reddit_listings, :column => :self
    remove_index :reddit_listings, :column => :nsfw
    remove_index :reddit_listings, :column => :listing_id
    remove_index :topics, :column => :name
    remove_index :listings, :column => :link_id
    remove_index :links, :column => :url
  end
end
