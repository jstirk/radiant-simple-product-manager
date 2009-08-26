class Product < ActiveRecord::Base
	belongs_to :category
	
	validates_presence_of :title
	validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true

end
