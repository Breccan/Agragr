class AddTypesToFeedsAndListings < ActiveRecord::Migration
  def self.up
    add_column :feeds, :feed_type, :string
    add_column :listings, :feed_type, :string
  end

  def self.down
    remove_column :listings, :feed_type
    remove_column :feeds, :feed_type
  end
end
