require File.dirname(__FILE__) + '/../spec_helper'

describe 'SimpleCategoryManager' do
	dataset :pages

	before do
		@c1=Category.create(:title => 'Test Category')
		c2=Category.create(:title => 'Another Category', :parent_id => @c1.id)
		c2=Category.create(:title => 'Subcategory', :parent_id => @c1.id)
	end


	describe '<r:subcategories:each>' do
		it "should itterate over every subcategory by default" do
			pages(:home).should render("<r:category:find where='id=#{@c1.id}'><r:subcategories:each>.</r:subcategories:each></r:category:find>").as('..')
		end
		
		it "should order OK by title" do
			pages(:home).should render("<r:category:find where='id=#{@c1.id}'><r:subcategories:each order=\"title DESC\"><r:subcategory:title />,</r:subcategories:each></r:category:find>").as('Subcategory,Another Category,')
		end
	end
	
	%w(id title description).each do |type|
		describe "<r:subcategory:#{type}>" do
			it "should work inside of subcategories:each" do
				pages(:home).should render("<r:category:find where='id=#{@c1.id}'><r:subcategories:each order=\"title\"><r:subcategory:#{type} />,</r:subcategories:each></r:category:find>").as(@c1.subcategories.find(:all, :order => 'title').collect { |p| p.send(type.to_sym) }.join(',') + ',')
			end
		end
	end

	describe "<r:subcategory:link>" do
		it "should work inside of subcategory:find"

		it "should work inside of subcategories:each"

		it "should default to the title if no content"

		it "should set a class when the current page"

		it "should set a custom class when provided and selected"
	end
	
	describe "<r:subcategory:field>" do
		before do
			@c=Category.create(:title => "Test", :parent => @c1)
			@c.json_field_set(:fieldname, "Foo")
			@c.save!
		end

		it "should fetch existing data OK"

		it "should return nothing on missing data"
	end

end
