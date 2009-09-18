class Admin::ProductsController < Admin::ResourceController
	model_class Product
	helper :spm

	def upload_image
		@product=Product.find(params[:product_id])
		@image=@product.product_images.new(params[:product_image])
		@image.save!

		redirect_to :action => 'edit', :id => @product
	end

	def delete_image
		@image=ProductImage.find(params[:id])
		product_id=@image.product_id
		@image.destroy
		redirect_to :action => 'edit', :id => product_id
	end
end
