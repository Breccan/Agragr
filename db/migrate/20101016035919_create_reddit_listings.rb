class CreateRedditListings < ActiveRecord::Migration
  def self.up
    create_table :reddit_listings do |t|
      t.boolean :self
      t.boolean :nsfw
      t.integer :listing_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reddit_listings
  end
end
