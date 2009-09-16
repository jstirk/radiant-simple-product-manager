class ProductsController < ActionController::Base
	radiant_layout 'Product'

	def show
		@product=Product.find(params[:id])
		@title = @product.title
	end
end
