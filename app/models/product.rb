class Product < ActiveRecord::Base
	belongs_to :category
	
	validates_presence_of :title
	validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true

	def to_param
		"#{self.id}-#{self.title.gsub(/[^A-Za-z\-]/,'-').gsub(/-+/,'-')}"
	end

end
