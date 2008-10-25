require File.dirname(__FILE__) + '/../spec_helper'

describe SimpleProductManager do
	scenario :products
	

	w%(products categories).each do |type|
		describe "<r:#{type}>" do
			it "shouldn't affect page content"
				pages(:home).should render("<r:#{type}>foo</r:#{type}>").as('foo')
			end
		end
	end
	
	describe '<r:product>' do
		it "should use 'where' option correctly" do
			pages(:home).should render('<r:product where="price > 3.90"><r:product:title /></r:product>').as('Croissant')
		end
	end
	
	describe '<r:products:each>' do
		it "should itterate over every product by default" do
			# We have 5 products - one dot for each one
			pages(:home).should render('<r:products:each>.</r:products:each>').as('.....')
		end
		
		it "should order OK by title" do
			pages(:home).should render('<r:products:each order="title ASC"><r:product:title />,</r:products:each>').as('Croissant,Jam Tart,Multigrain,White,Wholemeal,')
		end
		
		it "should order OK by price" do
			pages(:home).should render('<r:products:each order="price DESC"><r:product:title />,</r:products:each>').as('Croissant,Jam Tart,White,Wholemeal,Multigrain,')
		end
		
		it "should restrict OK by price" do
			pages(:home).should render('<r:products:each where="price > 3.40" order="price DESC"><r:product:title />,</r:products:each>').as('Croissant,Jam Tart,')
		end
	end
	
	w%(id title description).each do |type|
		describe "<r:product:#{type}>" do
			it "should work inside of products:each" do
				pages(:home).should render("<r:products:each><r:product:#{type} />,</r:products:each>").as(Products.find(:all).collect { |p| p.send(type.to_sym) }.join(',') + ',')
			end
			
			it "should work inside of product" do
				pages(:home).should render("<r:product where=\"title='white'\"><r:product:#{type} /></r:product>").as(Products.find_by_title('White').send(type.to_sym))
			end
		end
	end
	
	describe '<r:product:price>' do
		it "should work inside of products:each" do
			pages(:home).should render("<r:products:each order=\"price ASC\"><r:product:price />,</r:products:each>").as('$3.00,$3.10,$3.20,$3.50,$4,000.00,')
		end
		
		it "should display in $0.00 format by default" do
			pages(:home).should render("<r:product where=\"title='white'\"><r:product:price /></r:product>").as('$4,000.00')
		end
		
		it "should display in custom format if asked" do
			pages(:home).should render("<r:product where=\"title='white'\"><r:product:price precision=\"1\" unit=\"%\" separator=\"-\" delimiter=\"|\"/></r:product>").as('%4|000-0')
		end
	end
	
	describe "<r:product:photo_url>" do
		it "should work inside of products:each" do
			pages(:home).should render("<r:products:each><r:product:photo_url />,</r:products:each>").as(Products.find(:all).collect { |p| p.title + '.png' }.join(',') + ',')
		end
		
		it "should work inside of product" do
			pages(:home).should render("<r:product where=\"title='white'\"><r:product:photo_url /></r:product").as('White.png')
		end
	end
	
	
	describe '<r:category>' do
		it "should use 'where' option correctly" do
			pages(:home).should render('<r:category where="title=\'Bread\'"><r:product:title /></r:product>').as('Bread')
		end
	end
	
	describe '<r:categories:each>' do
		it "should itterate over every category by default" do
			# We have 2 products - one dot for each one
			pages(:home).should render('<r:categories:each>.</r:categories:each>').as('..')
		end
		
		it "should order OK by title" do
			pages(:home).should render('<r:categories:each order="title DESC"><r:category:title />,</r:categories:each>').as('Pastries,Bread,')
		end
				
		it "should restrict OK by title" do
			pages(:home).should render('<r:categories:each where="title=\'Bread\'"><r:category:title />,</r:categories:each>').as('Bread')
		end
	end
	
	w%(id title description).each do |type|
		describe "<r:category:#{type}>" do
			it "should work inside of categories:each" do
				pages(:home).should render("<r:categories:each><r:category:#{type} />,</r:categories:each>").as(Categories.find(:all).collect { |p| p.send(type.to_sym) }.join(',') + ',')
			end
			
			it "should work inside of category" do
				pages(:home).should render("<r:category where=\"title='Bread'\"><r:category:#{type} /></r:category>").as(Products.find_by_title('White').send(type.to_sym))
			end
		end
	end

end
