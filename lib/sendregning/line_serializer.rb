# frozen_string_literal: true

module Sendregning
  class LineSerializer < Sendregning::XmlSerializer
    def build
      builder.line do |line|
        line.qty       item.qty       if item.qty
        line.prodCode  item.prodCode  if item.prodCode
        line.desc      item.desc      if item.desc
        line.unitPrice item.unitPrice if item.unitPrice
        line.discount  item.discount  if item.discount
        line.tax       item.tax       if item.tax
      end
    end
  end
end
