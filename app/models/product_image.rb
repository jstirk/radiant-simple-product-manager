class ProductImage < ActiveRecord::Base

  has_attachment :storage => :file_system,
                 :thumbnails => defined?(PRODUCT_ATTACHMENT_SIZES) && PRODUCT_ATTACHMENT_SIZES || {:thumbnail => '75x75>', :product => '250x250>'},
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

	def thumbnail_url
		public_filename(:thumbnail)
	end

	def url
		public_filename(:product)
	end

	def thumbnail_tag(options={})
		options[:alt] ||= description
		image_tag(thumbnail_url, options)
	end

	def tag(options={})
		options[:alt] ||= description
		image_tag(url, options)
	end

private
	# For some reason ActionView::Helpers::AssetTagHelper#image_tag is throwing errors
	def image_tag(url, options={})
		o="<img src=\"#{url}\" "
		o << options.keys.collect{ |x| x.to_s }.sort.collect { |key| "#{key}=\"#{options[key.to_sym]}\"" }.join(' ')
		o << " />"
		o
	end

	def set_product_id_from_parent
		if !self.parent.blank? then
			self.product_id=self.parent.product_id
		end
	end

end
