require File.dirname(__FILE__) + '/../spec_helper'

describe 'SimpleProductManager' do
	dataset :pages
	dataset :products
	
	%w(products categories).each do |type|
		describe "<r:#{type}>" do
			it "shouldn't affect page content" do
				pages(:home).should render("<r:#{type}>foo</r:#{type}>").as('foo')
			end
		end
	end
	
	describe '<r:product:find>' do
		it "should use 'where' option correctly" do
			pages(:home).should render('<r:product:find where="price > 10.00" order="title ASC"><r:product:title /></r:product:find>').as('Croissant')
		end
	end
	
	describe '<r:products:each>' do
		it "should itterate over every product by default" do
			# We have 7 products - one dot for each one
			pages(:home).should render('<r:products:each>.</r:products:each>').as('.......')
		end
		
		it "should order OK by title" do
			pages(:home).should render('<r:products:each order="title ASC"><r:product:title />,</r:products:each>').as('Caesar Salad,Croissant,Green Salad,Jam Tart,Multigrain,White,Wholemeal,')
		end
		
		it "should order OK by price" do
			pages(:home).should render('<r:products:each order="price DESC"><r:product:title />,</r:products:each>').as('Croissant,Caesar Salad,Green Salad,Jam Tart,White,Wholemeal,Multigrain,')
		end
		
		it "should restrict OK by price" do
			pages(:home).should render('<r:products:each where="price > 3.40" order="price DESC"><r:product:title />,</r:products:each>').as('Croissant,Caesar Salad,Green Salad,Jam Tart,')
		end

		it "should work within category:find" do
			pages(:home).should render('<r:category:find where="title=\'Pastries\'"><r:products:each order="title ASC"><r:product:title />,</r:products:each></r:category:find>').as('Croissant,Jam Tart,')
		end

		it "should work within subcategory:find" do
			c1=Category.create(:title => 'Test Category')
			c2=Category.create(:title => 'Another Category', :parent => c1)
			p=Product.create(:title => 'Bar', :category => c2)
			c2=Category.create(:title => 'Subcategory', :parent => c1)
			p=Product.create(:title => 'Foo', :category => c2)
			pages(:home).should render('<r:category:find where="title=\'Test Category\'"><r:subcategories:each where="title=\'Subcategory\'"><r:products:each order="title ASC"><r:product:title /></r:products:each></r:subcategories:each></r:category:find>').as('Foo')
		end
	end
	
	%w(id title description).each do |type|
		describe "<r:product:#{type}>" do
			it "should work inside of products:each" do
				pages(:home).should render("<r:products:each order=\"title\"><r:product:#{type} />,</r:products:each>").as(Product.find(:all, :order => 'title').collect { |p| p.send(type.to_sym) }.join(',') + ',')
			end
			
			it "should work inside of product" do
				pages(:home).should render("<r:product:find where=\"title='White'\"><r:product:#{type} /></r:product:find>").as(Product.find_by_title('White').send(type.to_sym).to_s)
			end
		end
	end
	
	describe '<r:product:price>' do
		it "should work inside of products:each" do
			pages(:home).should render("<r:products:each order=\"price ASC\"><r:product:price />,</r:products:each>").as('$3.00,$3.10,$3.20,$3.50,$7.00,$9.00,$4,000.00,')
		end
		
		it "should display in $0.00 format by default" do
			pages(:home).should render("<r:product:find where=\"title='Croissant'\"><r:product:price /></r:product:find>").as('$4,000.00')
		end
		
		it "should display in custom format if asked" do
			pages(:home).should render("<r:product:find where=\"title='Croissant'\"><r:product:price precision=\"1\" unit=\"%\" separator=\"-\" delimiter=\"|\"/></r:product:find>").as('%4|000-0')
		end
	end
	
	describe "<r:product:photo_url>" do
		it "should work inside of products:each" do
			pages(:home).should render("<r:products:each order=\"title\"><r:product:photo_url />,</r:products:each>").as(Product.find(:all, :order => 'title').collect { |p| p.title + '.png' }.join(',') + ',')
		end
		
		it "should work inside of product" do
			pages(:home).should render("<r:product:find where=\"title='White'\"><r:product:photo_url /></r:product:find>").as('White.png')
		end
	end

	describe "<r:product:field>" do
		it "should fetch existing data OK" do
			p=Product.create(:title => "Test", :category => Category.find(:first))
			p.json_field_set(:fieldname, "Foo")
			p.save!
			pages(:home).should render("<r:product:find where=\"title='Test'\"><r:product:field name=\"fieldname\" /></r:product:find>").as("Foo")
		end

		it "should return nothing on missing data" do
			p=Product.create(:title => "Test", :category => Category.find(:first))
			p.json_field_set(:fieldname, "Foo")
			p.save!
			pages(:home).should render("<r:product:find where=\"title='Test'\">-<r:product:field name=\"missing_field\" />-</r:product:find>").as("--")
		end
	end
	
	describe '<r:category:find>' do
		it "should use 'where' option correctly" do
			pages(:home).should render('<r:category:find where="title=\'Bread\'"><r:category:title /></r:category:find>').as('Bread')
		end
		it "should use 'tag' option correctly" do
			pages(:home).should render('<r:category:find tag="Retail"><r:category:title /></r:category:find>').as('Pastries')
		end
		it "should use 'tag' and 'where' options simultaniously correctly" do
			pages(:home).should render('<r:category:find tag="Gluten Free" where="title=\'Salads\'"><r:category:title /></r:category:find>').as('Salads')
		end
	end
	
	describe '<r:categories:each>' do
		it "should itterate over every top-level category by default" do
			# We have 3 top-level categories - one dot for each one
			pages(:home).should render('<r:categories:each>.</r:categories:each>').as('...')
		end
		
		it "should order OK by title" do
			pages(:home).should render('<r:categories:each order="title DESC"><r:category:title />,</r:categories:each>').as('Salads,Pastries,Bread,')
		end
				
		it "should restrict OK by title" do
			pages(:home).should render('<r:categories:each where="title=\'Bread\'"><r:category:title /></r:categories:each>').as('Bread')
		end

		it "should restrict OK by tags" do
			pages(:home).should render('<r:categories:each tag="Gluten Free"><r:category:title /><br /></r:categories:each>').as('Pastries<br />Salads<br />')
		end

		it "should restrict OK by tags with ordering" do
			pages(:home).should render('<r:categories:each tag="Gluten Free" order="title DESC"><r:category:title /><br /></r:categories:each>').as('Salads<br />Pastries<br />')
		end
	end
	
	%w(id title description).each do |type|
		describe "<r:category:#{type}>" do
			it "should work inside of categories:each" do
				pages(:home).should render("<r:categories:each order=\"id\"><r:category:#{type} />,</r:categories:each>").as(Category.find_all_top_level.collect { |p| p.send(type.to_sym) }.join(',') + ',')
			end
			
			it "should work inside of category" do
				pages(:home).should render("<r:category:find where=\"title='Bread'\"><r:category:#{type} /></r:category:find>").as(Category.find_by_title('Bread').send(type.to_sym).to_s)
			end
		end
	end

	describe "<r:category:field>" do
		it "should fetch existing data OK" do
			c=Category.find(:first)
			c.json_field_set(:fieldname, "Foo")
			c.save!
			pages(:home).should render("<r:category:find where=\"id='#{c.id}'\"><r:category:field name=\"fieldname\" /></r:category:find>").as("Foo")
		end

		it "should return nothing on missing data" do
			c=Category.create(:title => 'Test')
			pages(:home).should render("<r:category:find where=\"id='#{c.id}'\">-<r:category:field name=\"fieldname\" />-</r:category:find>").as("--")
		end
	end
	
	describe "<r:subcategories:each>" do
		it "should itterate over every subcategory for the current category" do
			# We have 3 2nd-level categories - one dot for each one
			pages(:home).should render('<r:category:find where="title=\'Bread\'"><r:subcategories:each>.</r:subcategories:each></r:category:find>').as('...')
		end
		
		it "should order OK by title" do
			pages(:home).should render('<r:category:find where="title=\'Bread\'"><r:subcategories:each order="title DESC"><r:subcategory:title />,</r:subcategories:each></r:category:find>').as('Wholemeal Breads,Spelt Breads,Sourdough Breads,')
		end
				
		it "should restrict OK by title" do
			pages(:home).should render('<r:category:find where="title=\'Bread\'"><r:subcategories:each where="title=\'Spelt Breads\'"><r:subcategory:title /></r:subcategories:each></r:category:find>').as('Spelt Breads')
		end

		it "should restrict OK by tags" do
			pages(:home).should render('<r:category:find where="title=\'Bread\'"><r:subcategories:each tag="Gluten Free"><r:subcategory:title /></r:subcategories:each></r:category:find>').as('Spelt Breads')
		end

		it "should restrict OK by tags with ordering" do
			pages(:home).should render('<r:category:find where="title=\'Bread\'"><r:subcategories:each order="title DESC" tag="High-Fiber"><r:subcategory:title />,</r:subcategories:each></r:category:find>').as('Wholemeal Breads,Spelt Breads,')
		end
	end

	%w(id title description).each do |type|
		describe "<r:subcategory:#{type}>" do
			it "should work inside of subcategories:each" do
				pages(:home).should render("<r:category:find where=\"title='Bread'\"><r:subcategories:each order=\"id\"><r:subcategory:#{type} />,</r:subcategories:each></r:category:find>").as(Category.find_by_title('Bread').subcategories.collect { |p| p.send(type.to_sym) }.join(',') + ',')
			end
			
			it "should work inside of category" do
				pages(:home).should render("<r:category:find where=\"title='Bread'\"><r:category:#{type} /></r:category:find>").as(Category.find_by_title('Bread').send(type.to_sym).to_s)
			end
		end
	end

	describe "<r:subcategory:field>" do
		it "should fetch existing data OK"
		it "should return nothing on missing data"
	end
	
end
