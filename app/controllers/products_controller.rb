class ProductsController < ActionController::Base
	radiant_layout 'Product'

	def show
		@product=Product.find(params[:id])
		@title = @product.title
		
		@radiant_layout=Radiant::Config['simple_product_manager.product_layout']
	end
end
