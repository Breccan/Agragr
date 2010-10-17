class AddTypesToFeedsAndListings < ActiveRecord::Migration
  def self.up
    add_column :feeds, :type, :string
    add_column :listings, :type, :string
  end

  def self.down
    remove_column :listings, :type
    remove_column :feeds, :type
  end
end
