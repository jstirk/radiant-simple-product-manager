# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SimpleProductManagerExtension < Radiant::Extension
  version "0.1"
  description "Manages Products and Product Categories for use across the site."
  url "http://github.com/jstirk/radiant-simple-product-manager/tree/master"
  
  define_routes do |map|
		map.namespace 'admin' do |admin|
			admin.resources :products, :member => { :remove => :get }
			admin.resources :categories, :member => { :remove => :get }
		end
  end
  
  def activate
    admin.tabs.add "Products", "/admin/products", :after => "Layouts", :visibility => [:all]
    Page.send :include, SimpleProductManagerTag
  end
  
  def deactivate
    admin.tabs.remove "Products"
  end
  
end
