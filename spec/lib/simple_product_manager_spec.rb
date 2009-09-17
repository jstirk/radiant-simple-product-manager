require File.dirname(__FILE__) + '/../spec_helper'

describe 'SimpleProductManager' do
	dataset :pages
	dataset :products
	
	%w(products categories subcategories).each do |type|
		describe "<r:#{type}>" do
			it "shouldn't affect page content" do
				pages(:home).should render("<r:#{type}>foo</r:#{type}>").as('foo')
			end
		end
	end
end
