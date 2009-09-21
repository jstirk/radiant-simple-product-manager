require File.dirname(__FILE__) + '/../spec_helper'

describe ProductImage do
	before(:each) do
		@product=Product.create(:title => 'Test', :category => Category.find(:first))
		@product_image=@product.product_images.new(:description => 'Foo', :filename => "foo.jpg", :content_type => 'images/jpeg', :size => 100)
	end

	it "should be valid" do
		@product_image.should be_valid
	end

	it "should respond to description" do
		@product_image.description.should == 'Foo'
	end

	describe "saved instance" do
		before do
			@product_image.save!
		end

		it "should respond to the attachment_fu methods" do
			@product_image.public_filename.should =~ /product_images\/\d+\/\d+\/foo\.jpg/
			@product_image.public_filename(:thumbnail).should =~ /product_images\/\d+\/\d+\/foo_thumbnail\.jpg/
			@product_image.filename.should == 'foo.jpg'
		end

		it "should respond to our url helper method" do
			@product_image.url.should =~ /product_images\/\d+\/\d+\/foo_product\.jpg/
			PRODUCT_ATTACHMENT_SIZES.keys.each do |size|
				@product_image.url(size).should =~ /product_images\/\d+\/\d+\/foo_#{size}\.jpg/
			end
			@product_image.url(:fullsize).should =~ /product_images\/\d+\/\d+\/foo\.jpg/
		end

		describe "tag helper method" do
			it "should render tag with with defaults" do
				@product_image.tag.should == "<img src=\"#{@product_image.url}\" alt=\"Foo\" />"
			end

			it "should render tag with with options" do
				@product_image.tag(:width => 120, :height => 90, :alt => 'BletchBang').should == "<img src=\"#{@product_image.url}\" alt=\"BletchBang\" height=\"90\" width=\"120\" />"
			end

			PRODUCT_ATTACHMENT_SIZES.keys.each do |size|
				it "should render tag for '#{size}' size" do
					@product_image.tag(:type => size).should == "<img src=\"#{@product_image.url(size)}\" alt=\"Foo\" />"
				end

				it "should render tag for size '#{size}' with with options" do
					@product_image.tag(:type => size, :width => 120, :height => 90, :alt => 'BletchBang').should == "<img src=\"#{@product_image.url(size)}\" alt=\"BletchBang\" height=\"90\" width=\"120\" />"
				end
			end

			it "should render tag for fullsize image" do
				@product_image.tag(:type => :fullsize).should == "<img src=\"#{@product_image.url(:fullsize)}\" alt=\"Foo\" />"
			end

			it "should render tag for fullsize image with options" do
				@product_image.tag(:type => :fullsize, :width => 120, :height => 90, :alt => 'BletchBang').should == "<img src=\"#{@product_image.url(:fullsize)}\" alt=\"BletchBang\" height=\"90\" width=\"120\" />"
			end
		end
	end
end
