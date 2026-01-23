# frozen_string_literal: true

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
      return unless item.lines.any?

      invoice.lines do |line_builder|
        item.lines.each { |l| l.to_xml(builder: line_builder) }
      end
    end

    def optional_attributes(invoice)
      return unless item.optional.any?

      invoice.optional do |optional|
        item.optional.each do |key, value|
          key = key.to_sym
          if value.is_a?(Date) || value.is_a?(Time)
            value = value.strftime("%d.%m.%y")
          end
          optional.tag! key, value
        end
      end
    end

    def shipment_attributes(invoice)
      return unless item.shipment.any?

      invoice.shipment do |shipment|
        shipment.text! item.shipment_mode
        item.shipment.each do |key, values|
          key = key.to_sym
          next if key == :shipment

          shipment.tag! key do |emails|
            Array(values).each { |v| emails.email v }
          end
        end
      end
    end
  end
end
