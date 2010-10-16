class CreateRedditListings < ActiveRecord::Migration
  def self.up
    create_table :reddit_listings do |t|
      t.boolean  :self
      t.boolean  :nsfw
      t.integer  :listing_id
      t.string   :subreddit
      t.string   :selftext
      t.string   :author
      t.string   :permalink
      t.integer  :num_comments
      t.integer  :ups
      t.integer  :downs
      t.timestamps
    end
  end

  def self.down
    drop_table :reddit_listings
  end
end
