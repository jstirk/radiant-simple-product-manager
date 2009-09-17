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

end
