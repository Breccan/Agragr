class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.string :url
      t.integer :current_votes
      t.integer :source_id
      t.string :title
      t.text :description
      t.integer :link_id

      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
