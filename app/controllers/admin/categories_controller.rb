class Admin::CategoriesController < Admin::ResourceController
	model_class Category
	helper :spm
	
	def index
	 	redirect_to :controller => 'admin/products', :action => 'index'
	end
end
