module SpmHelper
	def custom_fields(classname=:category)
		Radiant::Config["simple_product_manager.#{classname.to_s}_fields"].split(',').collect { |x| x.strip }
	end

	def humanize(text)
		ActiveSupport::Inflector::humanize(text)
	end
end
