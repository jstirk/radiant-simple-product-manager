class ProductsScenario < Scenario::Base
  uses :pages

  def load
  	# Create our categories
  	products={ 'Bread' => { 'White' => 3.20, 
  	                         'Wholemeal' => 3.10, 
  	                         'Multigrain' => 3.00 },
  	            'Pastries' => { 'Croissant' => 4000.00,
  	            								'Jam Tart' => 3.50 } }

		# Create the categories	
		products.keys.each do |c|
			c=Category.new(:title => c, :description => 'foo')
  		c.save
  	end
  	
  	# Create our products
  	products.each do |catname, list|
  		list.each do |name, price|
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
