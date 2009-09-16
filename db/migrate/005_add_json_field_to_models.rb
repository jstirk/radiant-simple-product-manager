class AddJsonFieldToModels < ActiveRecord::Migration
	def self.up
		add_column :products, :json_field, :text
		add_column :categories, :json_field, :text
	end

	def self.down
		remove_column :products, :json_field
		remove_column :categories, :json_field
	end
end
