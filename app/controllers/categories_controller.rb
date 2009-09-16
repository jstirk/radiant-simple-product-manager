class CategoriesController < ActionController::Base
	radiant_layout 'Category'

	def show
		@category=Category.find(params[:id])
		@title = @category.title
	end
end
