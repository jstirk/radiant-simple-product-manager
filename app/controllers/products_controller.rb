class ProductsController < ActionController::Base
	radiant_layout 'Product'

	def show
		@product=Product.find(params[:id])
		@title = @product.title
		
		# TODO: Allow these layouts to be set in the database
	end
end
