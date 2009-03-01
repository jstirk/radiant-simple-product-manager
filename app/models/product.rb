class Product < ActiveRecord::Base
	belongs_to :category
	
	validates_presence_of :title
  validates_numericality_of :price
  
  
  def validate
    errors.add(:price, "should be a positive value") if price.nil? || price < 0.01
  end
end
