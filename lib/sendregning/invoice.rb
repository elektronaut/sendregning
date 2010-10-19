module Sendregning

	class Invoice
		OPTIONAL_ATTRIBUTES = [
			:invoiceType, :creditedId, :orderNo, :invoiceDate, :orderNo,
			:invoiceDate, :dueDate, :orderDate, :recipientNo, :address1, :address2,
			:country, :email, :ourRef, :yourRef, :comment, :invoiceText, :printDunningInfo
			:itemTaxInclude
		]
		SHIPMENT_ATTRIBUTES = [
			:shipment, :emailaddresses, :copyaddresses
		]
		attr_accessor :name, :zip, :city
		attr_accessor :optional, :shipment
		attr_accessor :lines

		def initialize(attributes={})
			@name = attributes[:name]
			@zip  = attributes[:zip]
			@city = attributes[:city]
			optional = attributes
			shipment = attributes
			@lines = []
		end
		
		def optional=(attributes)
			@optional = {}
			attributes.each do |key, value|
				@optional[key] = value if OPTIONAL_ATTRIBUTES.include?(key.to_sym)
			end
			@optional
		end
		
		def shipment=(attributes)
			@shipment = {}
			attributes.each do |key, value|
				@shipment[key] = value if SHIPMENT_ATTRIBUTES.include?(key.to_sym)
			end
			@shipment
		end
		
	end

end