module Sendregning
  class Line
    # Quantity, as decimal. Example: '7,5'
    attr_accessor :qty

    # Product code. String, max length: 9
    attr_accessor :prodCode

    # Description. String, max length: 75
    attr_accessor :desc

    # Price per unit in decimal. Example: '250,00'
    attr_accessor :unitPrice

    # Discount in percentage as decimal. Optional, defaults to 0
    attr_accessor :discount

    # Tax rate. Valid rates are: '0', '8', '13' and '25'. Default: '25'
    attr_accessor :tax

    attr_accessor :itemNo, :lineTaxAmount, :lineTotal

    def initialize(new_attributes={})
      self.attributes = new_attributes
    end

    # Renders line to XML
    def to_xml(options={})
      LineSerializer.build(self, options)
    end

    protected

    def attributes=(attributes={})
      attributes.each do |key, value|
        set_method = "#{key.to_s}=".to_sym
        self.send(set_method, value) if self.respond_to?(set_method)
      end
      attributes
    end
  end
end
