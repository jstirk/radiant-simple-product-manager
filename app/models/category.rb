class Category < ActiveRecord::Base
	has_many :products, :dependent => :destroy
	belongs_to :parent, :class_name => 'Category'
	has_many :subcategories, :class_name => 'Category', :foreign_key => :parent_id

	validates_presence_of :title

	def to_s
		o=[]
		o << self.parent.to_s unless self.parent.nil?
		o << self.title
		o.join(' > ')
	end

	def tag_names
		return '' if self.tags.blank?
		a=self.tags
		a.split(',').compact.reject { |x| x.blank? }.join(', ')
	end

	def tag_names=(new_tags)
		case new_tags
			when Array
				# NOTE: Surrounding commas are important!
				setter=",#{new_tags.join(',')},"
			when String
				set=new_tags.split(/,/)
				list=set.collect { |x| x.strip }
				# NOTE: Surrounding commas are important!
				setter=",#{list.join(',')},"
			when NilClass
				setter=''
			else
				raise ArgumentError, "Don't know how to handle #{new_tags.class.name}"
		end

		setter='' if setter == ',,'
		self.tags=(setter)
	end

	def self.find_all_except(c, options={})
		options[:conditions]=[ 'id != ?', c.id ] unless (c.blank? || c.new_record? )
		self.find(:all, options)
	end

	def self.find_all_top_level(options={})
		if options[:conditions] then
			options[:conditions]=[options[:conditions]] if !options[:conditions].is_a?(Array)
			options[:conditions][0]="(#{options[:conditions][0]}) AND parent_id IS NULL"
		else
			options[:conditions]="parent_id IS NULL"
		end
		self.find(:all, options)
	end
end
