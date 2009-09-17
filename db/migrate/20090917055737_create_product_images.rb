class CreateProductImages < ActiveRecord::Migration
  def self.up
    create_table :product_images do |t|
      t.integer :product_id, :null => false
      t.string :description
      t.column "content_type", :string
      t.column "filename",     :string
      t.column "size",         :integer
      t.column "parent_id",    :integer
      t.column "thumbnail",    :string
      t.column "width",        :integer
      t.column "height",       :integer
      t.column "created_at",   :datetime
      t.column "created_by",   :integer
      t.column "updated_at",   :datetime
      t.column "updated_by",   :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :product_images
  end
end
