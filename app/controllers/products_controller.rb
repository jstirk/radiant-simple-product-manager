class ProductsController < ActionController::Base
	radiant_layout 'Product'

	def show
		@product=Product.find(params[:id], :include => :category)
		@title = @product.title
		
		@radiant_layout=@product.layout
	end
end
