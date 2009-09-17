class CategoriesController < ActionController::Base
	radiant_layout 'Category'

	def show
		@category=Category.find(params[:id])
		@title = @category.title

		@radiant_layout=Radiant::Config['simple_product_manager.category_layout']
	end
end
