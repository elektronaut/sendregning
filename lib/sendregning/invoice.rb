module Sendregning

  class Invoice
    OPTIONAL_ATTRIBUTES = [
      # Request
      :invoiceType, :creditedId, :orderNo, :invoiceDate, :orderNo,
      :invoiceDate, :dueDate, :orderDate, :recipientNo, :address1, :address2,
      :country, :email, :ourRef, :yourRef, :comment, :invoiceText, :printDunningInfo,
      :itemTaxInclude,

      # Response
      :tax, :dueDate, :dunningFee, :invoiceNo, :total, :accountNo, :orgNrSuffix, :kid, :orgNo, :interestRate, :state
    ]

    SHIPMENT_ATTRIBUTES = [
      :shipment, :emailaddresses, :copyaddresses
    ]

    SHIPMENT_MODES = {
      :paper           => 'PAPER',
      :email           => 'EMAIL',
      :paper_and_email => 'PAPER_AND_EMAIL'
    }

    attr_accessor :client
    attr_accessor :name, :zip, :city
    attr_accessor :optional, :shipment
    attr_accessor :lines

    def initialize(attributes={})
      self.update(attributes)
      @lines = []
    end

    def update(attributes={})
      @client  = attributes[:client] if attributes[:client]
      @name    = attributes[:name]   if attributes[:name]
      @zip     = attributes[:zip]    if attributes[:zip]
      @city    = attributes[:city]   if attributes[:city]
      self.optional = attributes
      self.shipment = attributes
    end

    def add_line(line)
      line = Sendregning::Line.new(line) unless line.kind_of?(Sendregning::Line)
      @lines << line
      line
    end

    # Sends an invoice
    def send!
      self.client.send_invoice(self)
    end

    def paid?
      state == 'paid'
    end

    def shipment_mode
      mode = (@shipment[:shipment] || :paper).to_sym
      raise 'Invalid shipment mode!' unless SHIPMENT_MODES.keys.include?(mode)
      SHIPMENT_MODES[mode]
    end

    # Renders invoice to XML
    def to_xml(options={})
      InvoiceSerializer.build(self, options)
    end

    protected

    def optional=(attributes)
      @optional ||= {}
      attributes.each do |key, value|
        @optional[key.to_sym] = value if OPTIONAL_ATTRIBUTES.include?(key.to_sym)
      end
      @optional
    end

    def shipment=(attributes)
      @shipment ||= {}
      attributes.each do |key, value|
        @shipment[key.to_sym] = value if SHIPMENT_ATTRIBUTES.include?(key.to_sym)
      end
      @shipment
    end

    def method_missing(method, *args)
      if OPTIONAL_ATTRIBUTES.include?(method)
        @optional[method]
      elsif SHIPMENT_ATTRIBUTES.include?(method)
        @shipping[method]
      else
        super
      end
    end

    def xml_builder
      xml = Builder::XmlMarkup.new(:indent=>2)
      xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
      xml
    end
  end
end
