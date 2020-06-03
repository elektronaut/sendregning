# frozen_string_literal: true

module Sendregning
  class XmlSerializer
    class << self
      def build(item, options = {})
        builder = options[:builder] || xml_builder
        new(item, builder).build
      end

      protected

      def xml_builder
        xml = Builder::XmlMarkup.new(indent: 2)
        xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
        xml
      end
    end

    def initialize(item, builder)
      @item = item
      @builder = builder
    end

    def build
      raise("XmlSerializer is an abstract class, subclass and overwrite " \
            "the build method")
    end

    protected

    attr_reader :builder

    attr_reader :item
  end
end
