class AddProductImagesTags < ActiveRecord::Migration
	def self.up
		add_column :product_images, :tags, :string
	end

	def self.down
		remove_column :product_images, :tags
	end
end
