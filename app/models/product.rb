class Product < ActiveRecord::Base
	belongs_to :category
	has_many :product_images, :dependent => :destroy, :conditions => [ 'parent_id IS NULL' ]
	
	validates_presence_of :title
	validates_numericality_of :price, :greater_than => 0.00, :allow_nil => true

	def to_param
		"#{self.id}-#{self.title.gsub(/[^A-Za-z\-]/,'-').gsub(/-+/,'-')}"
	end

	def layout
		self.category.product_layout
	end

	def custom=(values)
		values.each do |key, value|
			self.json_field_set(key, value)
		end
	end

end
