module Sendregning
  class InvoiceParser
    class << self
      def parse(response, invoice=Sendregning::Invoice.new)
        self.new(response, invoice).parse
      end
    end

    def initialize(response, invoice)
      @response = response
      @invoice = invoice
    end

    def parse
      attributes = @response['invoices']['invoice']

      # Flatten optional and shipment attributes
      %w{optional shipment}.each do |section|
        if attributes.has_key?(section)
          attributes = attributes.merge(attributes[section])
          attributes.delete(section)
        end
      end

      lines = attributes['lines']['line']
      attributes.delete('lines')

      @invoice.update(stringify_hash(attributes))
      @invoice.lines = lines.map {|l| Sendregning::Line.new(stringify_hash(l)) }
      @invoice
    end

    protected

    def stringify_hash(hash)
      new_hash = {}
      hash.each do |key, value|
        new_hash[key] = "#{value}"
      end
      new_hash
    end
  end
end