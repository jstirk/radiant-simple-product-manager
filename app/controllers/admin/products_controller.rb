class Admin::ProductsController < Admin::ResourceController
	model_class Product
	helper :spm
end
