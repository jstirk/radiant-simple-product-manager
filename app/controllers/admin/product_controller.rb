class Admin::ProductController < Admin::ResourceController
	model_class Product
	
	def new
    if request.post?
      p = Product.new(params[:product])
      if p.save()        
        flash[:notice] = "Success in creating the product"
        redirect_to :controller => 'admin/product', :action => 'index'
      else
        flash[:notice] = "Error creating the product"
      end
    end
  end
  
  def remove
    if request.post?
      p = Product.find(params[:id])
      p.destroy()
      flash[:notice] = "Product removed."
      redirect_to :controller => 'admin/product', :action => 'index'
    end
  end
  
  def edit
    if request.post?
      p = Product.find(params[:id])
      if p.update_attributes(params[:product])
        flash[:notice] = "Product updated"
      else
        flash[:notice] = "Error updating product"
      end
      redirect_to :controller => 'admin/product', :action => 'index'
    end
  end
end
