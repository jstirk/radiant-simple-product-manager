require File.dirname(__FILE__) + '/../spec_helper'

describe Category do
  before(:each) do
    @category = Category.new
  end

  it "should be valid" do
    @category.should be_valid
  end

	it "should set tags in correct format from tag_names" do
		@category.tag_names='Foo, Bar'
		@category.tags.should == ',Foo,Bar,'
		@category.tag_names='Bletch Blomb'
		@category.tags.should == ',Bletch Blomb,'
		@category.tag_names=[ 'Foo', 'Bar', 'Bletch Blomb' ]
		@category.tags.should == ',Foo,Bar,Bletch Blomb,'
	end

	it "should return tags in correct format from tag_names" do
		@category.tags=',Foo,Bar,Bletch Blomb,'
		@category.tag_names.should == [ 'Foo', 'Bar', 'Bletch Blomb' ]
	end
end
