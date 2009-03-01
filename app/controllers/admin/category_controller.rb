class Admin::CategoryController < Admin::ResourceController
	model_class Category
	
	def index
  	redirect_to :controller => 'admin/product', :action => 'index'
  end
  
  def new
    if request.post?
      c = Category.new(params[:category])
      if c.save()        
        flash[:notice] = "Success in creating the category"
        redirect_to :controller => 'admin/product', :action => 'index'
      else
        flash[:notice] = "Error creating the category"
      end
    end
  end
  
  def remove
    if request.post?
      c = Category.find(params[:id])
      c.destroy()
      flash[:notice] = "Category removed."
      redirect_to :controller => 'admin/product', :action => 'index'
    end
  end
  
  def edit
    if request.post?
      c = Category.find(params[:id])
      if c.update_attributes(params[:category])
        flash[:notice] = "Category updated"
      else
        flash[:notice] = "Error updating category"
      end
      redirect_to :controller => 'admin/product', :action => 'index'
    end
  end
  
end
