class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :title, :limit => 255
      t.text :description
      t.decimal :price, :precision => 10, :scale => 2
      t.string :photo, :limit => 255
      t.boolean :is_visible, :default => true
      t.integer :category_id, :null => false

      t.timestamps
    end
    
    add_index :products, :category_id
    add_index :products, :title
    add_index :products, :price
  end

  def self.down
    drop_table :products
  end
end
