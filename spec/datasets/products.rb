class ProductsDataset < Dataset::Base
	uses :pages

	def load
		# Create our categories
		products={ 'Bread' => { :tags => [ 'Wholesale' ],
		               :products => { 'White' => 3.20,
		                              'Wholemeal' => 3.10,
		                              'Multigrain' => 3.00 } },
		           'Pastries' => { :tags => [ 'Retail', 'Gluten Free' ],
		               :products => { 'Croissant' => 4000.00,
		                              'Jam Tart' => 3.50 } },
		           'Salads' => { :tags => [ 'Gluten Free', 'Salads' ],
		               :products => { 'Green Salad' => 7.00,
		                              'Caesar Salad' => 9.00 } } }

		# Create the categories
		products.each do |key, data|
			c=Category.new(:title => key, :description => 'foo')
			c.tag_names=data[:tags]
			c.save
		end

		# Create some second level categories
		Category.create(:title => 'Wholemeal Breads', :parent => Category.find_by_title('Bread'), :tag_names => 'High-Fiber')
		Category.create(:title => 'Sourdough Breads', :parent => Category.find_by_title('Bread'))
		Category.create(:title => 'Spelt Breads', :parent => Category.find_by_title('Bread'), :tag_names => 'Gluten Free, High-Fiber')

		# Create some third level categories
		Category.create(:title => 'Fiber Enriched Breads', :parent => Category.find_by_title('Wholemeal Breads'))
		
		# Create our products
		products.each do |catname, data|
			data[:products].each do |name, price|
				p=Product.new(:title => name, 
				              :description => 'foo', 
				              :category_id => Category.find_by_title(catname).id,
				              :photo => name + '.png',
				              :price => price)
				p.save
			end
		end
	end
end
