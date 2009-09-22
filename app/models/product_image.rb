class ProductImage < ActiveRecord::Base

	has_attachment :storage => :file_system,
	               :thumbnails => PRODUCT_ATTACHMENT_SIZES,
	               :max_size => 3.megabytes

	validates_as_attachment

	belongs_to :created_by,
	           :class_name => 'User',
	           :foreign_key => 'created_by'
	belongs_to :updated_by,
	           :class_name => 'User',
	           :foreign_key => 'updated_by'
	belongs_to :product

	before_save :set_product_id_from_parent

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

	def url(type=:product)
		type=:product if type.blank?
		type=nil if type.to_s == 'fullsize'
		type=type.to_sym unless type.nil?
		public_filename(type)
	end

	def tag(options={})
		if !options.is_a?(Hash) then
			raise ArgumentError, "ProductImage#tag Expected hash but got #{options.inspect}"
		end
		options[:alt] ||= description
		image_tag(url(options[:type]), options)
	end

private
	# For some reason ActionView::Helpers::AssetTagHelper#image_tag is throwing errors
	def image_tag(url, options={})
		o="<img src=\"#{url}\" "
		o << options.keys.reject { |x| [ 'type' ].include?(x.to_s) }.collect{ |x| x.to_s }.sort.collect { |key| "#{key}=\"#{options[key.to_sym]}\"" }.join(' ')
		o << " />"
		o
	end

	def set_product_id_from_parent
		if !self.parent.blank? then
			self.product_id=self.parent.product_id
		end
	end

end
