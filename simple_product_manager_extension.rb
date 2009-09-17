require 'json_fields'

class SimpleProductManagerExtension < Radiant::Extension
	version "0.4"
	description "Manages Products and Product Categories for use across the site."
	url "http://github.com/jstirk/radiant-simple-product-manager/tree/master"
	
	define_routes do |map|
		map.namespace 'admin' do |admin|
			admin.resources :products, :member => { :remove => :get }
			admin.resources :categories, :member => { :remove => :get }
		end
		map.connect 'products/:id', :controller => 'categories', :action => 'show', :id => /\d+-[A-Za-z\-]+/
		map.connect 'products/:category_id/:id', :controller => 'products', :action => 'show'
	end
	
	def activate
		admin.tabs.add "Products", "/admin/products", :after => "Layouts", :visibility => [:all]
		Page.send :include, SimpleProductManagerTag

		# Enable our JSON-backed fields
		ActiveRecord::Base.send :include, JsonFields

		# If our RadiantConfig settings are blank, set them up now
		Radiant::Config['simple_product_manager.product_fields'] ||= ''
		Radiant::Config['simple_product_manager.category_fields'] ||= ''
		Radiant::Config['simple_product_manager.product_layout'] ||= 'Product'
		Radiant::Config['simple_product_manager.category_layout'] ||= 'Category'
	end
	
	def deactivate
		admin.tabs.remove "Products"
	end
	
end
