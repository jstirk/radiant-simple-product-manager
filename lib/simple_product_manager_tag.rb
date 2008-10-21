module SimpleProductManagerTag
  include Radiant::Taggable
  include ERB::Util
  include ActionView::Helpers::NumberHelper

  tag 'products' do |tag|
    tag.expand
  end
  
  tag 'product' do |tag|
    tag.expand
  end

  tag 'products:each' do |tag|
    attr = tag.attr.symbolize_keys
    order=attr[:order] || 'title ASC'
    result = []
    if tag.locals.category then
    	prods=tag.locals.category.products.find(:all, :order => order)
    else
	    prods=Product.find(:all, :order => order)
	  end
    prods.each do |product|
      tag.locals.product = product
      result << tag.expand
    end
    result
  end

  tag 'product:id' do |tag|
    product = tag.locals.product
    html_escape product.id
  end
  tag 'product:title' do |tag|
    product = tag.locals.product
    html_escape product.title
  end
  tag 'product:description' do |tag|
    product = tag.locals.product
    html_escape product.description
  end
  tag 'product:price' do |tag|
    product = tag.locals.product
    number_to_currency(product.price.to_f)
  end
  tag 'product:image' do |tag|
    product = tag.locals.product
    "#{image_tag product.photo, :alt => product.title}"
  end
  
  tag 'categories' do |tag|
    tag.expand
  end
  
  tag 'category' do |tag|
    tag.expand
  end

  tag 'categories:each' do |tag|
    attr = tag.attr.symbolize_keys
    order=attr[:order] || 'title ASC'
    result = []
    Category.find(:all, :order => order).each do |category|
      tag.locals.category = category
      result << tag.expand
    end
    result
  end

  tag 'category:id' do |tag|
    category = tag.locals.category
    html_escape category.id
  end
  tag 'category:title' do |tag|
    category = tag.locals.category
    html_escape category.title
  end
  tag 'category:description' do |tag|
    category = tag.locals.category
    html_escape category.description
  end
end
