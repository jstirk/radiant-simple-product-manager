require File.dirname(__FILE__) + '/../spec_helper'

describe Product do
	before(:each) do
		@product = Product.new(:title => 'Test', :category => Category.find(:first))
	end

	it "should be valid" do
		@product.should be_valid
	end

	describe "instance" do
		before do
			@product.save
		end

		it "should generate a valid parameter string" do	
			@product.to_param.should =~ /^\d+-[A-Za-z0-9\-]+/
		end

		it "should generate a valid url" do
			@product.url.should == "#{@product.category.url}/#{@product.to_param}"
		end
	end
end
