require File.dirname(__FILE__) + '/../spec_helper'

describe Product do
  before(:each) do
    @product = Product.new(:title => 'Test', :category => Category.find(:first))
  end

  it "should be valid" do
    @product.should be_valid
  end
end
