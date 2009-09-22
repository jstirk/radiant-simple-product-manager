require File.dirname(__FILE__) + '/../spec_helper'

describe 'SimpleProductManager' do
	dataset :pages
	dataset :products

	describe "<r:product:images:each>" do
		before do
			@p=Product.create(:title => 'Test', :category => Category.find(:first))
			@p.product_images.create!(:description => 'Foo', :filename => "foo.jpg", :content_type => 'images/jpeg', :size => 100, :tag_names => 'foo,bar')
			@p.product_images.create!(:description => 'Bar', :filename => "bar.jpg", :content_type => 'images/jpeg', :size => 100, :tag_names => 'bar,bletch')
			@p.product_images.create!(:description => 'Bletch', :filename => "bletch.jpg", :content_type => 'images/jpeg', :size => 100, :tag_names => 'bletch')
		end

		it "should itterate over all the images for this product" do
			pages(:home).should render("<r:product:find where='id=#{@p.id}'><r:product:images:each>.</r:product:images:each></r:product:find>").as('...')
		end

		it "should itterate over all the images for this product in order" do
			pages(:home).should render("<r:product:find where='id=#{@p.id}'><r:product:images:each order=\"description ASC\"><r:image:description /></r:product:images:each></r:product:find>").as('BarBletchFoo')
		end

		it "should itterate over all the images for this product in order with a limit" do
			pages(:home).should render("<r:product:find where='id=#{@p.id}'><r:product:images:each limit=\"2\" order=\"description ASC\"><r:image:description /></r:product:images:each></r:product:find>").as('BarBletch')
		end

		it "should itterate over all the images for this product in order with a tag" do
			pages(:home).should render("<r:product:find where='id=#{@p.id}'><r:product:images:each tag=\"bar\" order=\"description ASC\"><r:image:description /></r:product:images:each></r:product:find>").as('BarFoo')
		end

		%w( description filename url tag ).each do |field|
			it "should expose images to <r:product:image:#{field}>" do
				pages(:home).should render("<r:product:find where='id=#{@p.id}'><r:product:images:each><r:product:image:#{field} /></r:product:images:each></r:product:find>").as(@p.product_images.find(:all, :order => 'filename ASC').collect { |i| i.send(field.to_sym) }.join(''))
			end
		end
	end

	describe "<r:product:image:tag>" do
		it "should accept width and height attributes" do
			p=Product.create(:title => 'Test', :category => Category.find(:first))
			pi=p.product_images.create!(:description => 'Bletch', :filename => "foo.jpg", :content_type => 'images/jpeg', :size => 100)
			pages(:home).should render("<r:product:find where='id=#{p.id}'><r:product:images:each><r:product:image:tag width=\"75\" height=\"80\" /></r:product:images:each></r:product:find>").as("<img src=\"#{pi.url}\" alt=\"Bletch\" height=\"80\" width=\"75\" />")
		end
	end
	
	describe "<r:product:image:tag type='thumbnail'>" do
		it "should accept width and height attributes" do
			p=Product.create(:title => 'Test', :category => Category.find(:first))
			pi=p.product_images.create!(:description => 'Bletch', :filename => "foo.jpg", :content_type => 'images/jpeg', :size => 100)
			pages(:home).should render("<r:product:find where='id=#{p.id}'><r:product:images:each><r:product:image:tag type='thumbnail' width=\"75\" height=\"80\" /></r:product:images:each></r:product:find>").as("<img src=\"#{pi.url(:thumbnail)}\" alt=\"Bletch\" height=\"80\" width=\"75\" />")
		end
	end

end
