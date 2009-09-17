require File.dirname(__FILE__) + '/../spec_helper'

describe 'SimpleProductManager' do
	dataset :pages
	dataset :products

	describe "<r:product:images>" do
		it "should itterate over all the images for this product"
		it "should expose images to <r:product:image:.*>"
	end
	

end
