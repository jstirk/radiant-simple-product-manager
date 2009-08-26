class AddCategoriesTags < ActiveRecord::Migration
	def self.up
		add_column :categories, :tags, :string
	end

	def self.down
		remove_column :categories, :tags
	end
end
