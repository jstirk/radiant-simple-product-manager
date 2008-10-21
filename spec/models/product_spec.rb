require File.dirname(__FILE__) + '/../spec_helper'

describe Product do
  before(:each) do
    @product = Product.new
  end

  it "should be valid" do
    @product.should be_valid
  end
end
