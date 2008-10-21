require File.dirname(__FILE__) + '/../spec_helper'

describe Category do
  before(:each) do
    @category = Category.new
  end

  it "should be valid" do
    @category.should be_valid
  end
end
