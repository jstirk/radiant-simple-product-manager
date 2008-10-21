class Admin::CategoryController < Admin::AbstractModelController
	model_class Category
	
	def index
  	redirect_to :controller => 'admin/product', :action => 'index'
  end
end
