class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.integer :parent_id
      t.integer :topic_id
      t.string :harvest_strategy

      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
