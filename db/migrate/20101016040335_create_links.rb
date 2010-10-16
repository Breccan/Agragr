class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :url
      t.string :title
      t.integer :score
      t.text :description
      t.integer :topic_id

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
