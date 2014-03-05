require 'yaml'

module Sendregning

  # Client for the SendRegning Web Services.
  #
  # Usage example:
  #
  #  client = SendRegning::Client.new(my_username, my_password)

  class Client
    include HTTMultiParty

    base_uri 'https://www.sendregning.no'
    format   :xml

    def initialize(username, password, options={})
      @auth = {:username => username, :password => password}
      @test = true if options[:test]
    end

    public

      # Performs a GET request
      def get(query={})
        self.class.get('/ws/butler.do', query_options(query))
      end

      # Performs a POST request
      def post(query=nil)
        self.class.post('/ws/butler.do', query_options(query))
      end

      def post_xml(xml, body={})
        body[:test] = true if @test
        body[:xml] = xml_file(xml)
        self.class.post('/ws/butler.do', query: body, detect_mime_type: true, basic_auth: @auth)
      end

      # Returns a list of recipients
      def recipients
        response = get(:action => 'select', :type => 'recipient')
        response['recipients']['recipient']
      end

      # Instances a new invoice
      def new_invoice(attributes={})
        Sendregning::Invoice.new(attributes.merge({:client => self}))
      end

      # Sends an invoice
      def send_invoice(invoice)
        response = post_xml(invoice.to_xml, {:action => 'send', :type => 'invoice'})
        parse_invoice(response['invoices']['invoice'], invoice)
      end

      # Finds an invoice by invoice number
      def find_invoice(invoice_id)
        builder = Builder::XmlMarkup.new(:indent=>2)
        builder.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
        request_xml = builder.select do |select|
          select.invoiceNumbers do |numbers|
            numbers.invoiceNumber invoice_id
          end
        end
        response = post_xml(request_xml, {:action => 'select', :type => 'invoice'})
        parse_invoice(response['invoices']['invoice']) rescue nil
      end


    protected

      def flatten_xml_hash(hash)
        new_hash = {}
        hash.each do |key, value|
          new_hash[key] = "#{value}"
        end
        new_hash
      end

      def parse_invoice(response, invoice=Sendregning::Invoice.new)
        attributes = response.dup
        if attributes['optional']
          attributes = attributes.merge(attributes['optional'])
          attributes.delete('optional')
        end
        if attributes['shipment']
          attributes = attributes.merge(attributes['shipment'])
          attributes.delete('shipment')
        end
        lines = attributes['lines']['line']; attributes.delete('lines')

        invoice.update(flatten_xml_hash(attributes))
        invoice.lines = lines.map{|l| Sendregning::Line.new(flatten_xml_hash(l))}
        invoice
      end

      def parse_response(body)
        self.class.parser.call(body, :xml)
      end

      # Prepares options for a request
      def query_options(query={})
        query[:test] = 'true' if @test
        {:basic_auth => @auth, :query => query}
      end

      def xml_file(xml)
        UploadIO.new(StringIO.new(xml), 'text/xml', 'request.xml')
      end
  end
end
