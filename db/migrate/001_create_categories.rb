class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title, :limit => 255, :null => false
      t.text :description
      t.boolean :is_visible, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
