module Sendregning
  class XmlSerializer
    class << self
      def build(item, options={})
        builder = options[:builder] || xml_builder
        self.new(item, builder).build
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
      raise "XmlSerializer is an abstract class, subclass and overwrite the build method"
    end

    protected

    def builder
      @builder
    end

    def item
      @item
    end
  end
end