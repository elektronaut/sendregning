module Sendregning
  class InvoiceSerializer < Sendregning::XmlSerializer
    def build
      builder.invoices do |invoices|
        invoices.invoice do |invoice|
          invoice.name item.name
          invoice.zip  item.zip
          invoice.city item.city

          lines(invoice)
          optional_attributes(invoice)
          shipment_attributes(invoice)
        end
      end
    end

    protected

    def lines(invoice)
      if item.lines.any?
        invoice.lines do |line_builder|
          item.lines.each { |l| l.to_xml(builder: line_builder) }
        end
      end
    end

    def optional_attributes(invoice)
      if item.optional.any?
        invoice.optional do |optional|
          item.optional.each do |key, value|
            key = key.to_sym
            if value.kind_of?(Date) || value.kind_of?(Time)
              value = value.strftime("%d.%m.%y")
            end
            optional.tag! key, value
          end
        end
      end
    end

    def shipment_attributes(invoice)
      if item.shipment.any?
        invoice.shipment do |shipment|
          shipment.text! item.shipment_mode
          item.shipment.each do |key, values|
            key = key.to_sym
            unless key == :shipment
              shipment.tag! key do |emails|
                Array(values).each { |v| emails.email v }
              end
            end
          end
        end
      end
    end
  end
end