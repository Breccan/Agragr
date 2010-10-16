class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :url
      t.string :title
      t.integer :score, :default => 0
      t.text :description
      t.integer :topic_id
      t.integer :ups
      t.integer :downs

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
