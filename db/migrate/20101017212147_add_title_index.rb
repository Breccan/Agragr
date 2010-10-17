class AddTitleIndex < ActiveRecord::Migration
  def self.up
    add_index :links, :title
  end

  def self.down
    remove_index :links, :column => :title
  end
end
