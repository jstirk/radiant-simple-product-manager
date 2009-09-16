class CategoriesController < ActionController::Base
	radiant_layout 'Category'

	def show
		@category=Category.find(params[:id])
		@title = @category.title

		# TODO: Allow these layouts to be set in the database
	end
end
