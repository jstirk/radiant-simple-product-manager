require File.dirname(__FILE__) + '/../spec_helper'

describe 'SimpleProductManager' do
	dataset :pages
	dataset :products

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

		it "should restrict OK by parent id" do
			c=Category.find_by_title('Bread')
			pages(:home).should render("<r:categories:each parent=\"#{c.id}\" order=\"title ASC\"><r:category:title /><br /></r:categories:each>").as('Sourdough Breads<br />Spelt Breads<br />Wholemeal Breads<br />')
		end

		it "should restrict OK by parent title" do
			pages(:home).should render("<r:categories:each parent=\"Bread\" order=\"title ASC\"><r:category:title /><br /></r:categories:each>").as('Sourdough Breads<br />Spelt Breads<br />Wholemeal Breads<br />')
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

	describe "<r:category:link>" do
		before do
			@c=Category.find(:first)
		end

		it "should work inside of category:find" do
			pages(:home).should render("<r:category:find where=\"id=#{@c.id}\"><r:category:link><r:category:title /></r:category:link></r:category:find>").as("<a href=\"/products/#{@c.to_param}\">#{@c.title}</a>")
		end
		it "should default to the title if no content" do
			pages(:home).should render("<r:category:find where=\"id=#{@c.id}\"><r:category:link /></r:category:find>").as("<a href=\"/products/#{@c.to_param}\">#{@c.title}</a>")
		end
		it "should work inside of categories:each" do
			pages(:home).should render("<r:categories:each where=\"id=#{@c.id}\"><r:category:link><r:category:title /></r:category:link></r:categories:each>").as("<a href=\"/products/#{@c.to_param}\">#{@c.title}</a>")
		end

		it "should set a class when the current page" do
			c=Category.find(:first)
			url="/products/#{c.to_param}"
			pages(:home).should render("<r:category:find where=\"id=#{c.id}\" internal_url=\"#{url}\"><r:category:link><r:category:title /></r:category:link></r:category:find>").as("<a href=\"#{url}\" class=\"current\">#{c.title}</a>")
		end

		it "should set a custom class when provided and selected" do
			c=Category.find(:first)
			url="/products/#{c.to_param}"
			pages(:home).should render("<r:category:find where=\"id=#{c.id}\" internal_url=\"#{url}\"><r:category:link selected=\"hilight\"><r:category:title /></r:category:link></r:category:find>").as("<a href=\"#{url}\" class=\"hilight\">#{c.title}</a>")
		end
	end
	
	describe "<r:category:field>" do
		before do
			@c=Category.find(:first)
			@c.json_field_set(:fieldname, "Foo")
			@c.save!
		end

		it "should fetch existing data OK" do
			pages(:home).should render("<r:category:find where=\"id='#{@c.id}'\"><r:category:field name=\"fieldname\" /></r:category:find>").as("Foo")
		end

		it "should return nothing on missing data" do
			pages(:home).should render("<r:category:find where=\"id='#{@c.id}'\">-<r:category:field name=\"different_name\" />-</r:category:find>").as("--")
		end
	end
end
