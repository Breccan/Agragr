class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.string :url
      t.integer :current_votes
      t.integer :feed_id
      t.text :title
      t.text :description
      t.integer :link_id
      t.string :comments_url

      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
