# frozen_string_literal: true

require "yaml"

module Sendregning
  # Client for the SendRegning Web Services.
  #
  # Usage example:
  #
  #  client = SendRegning::Client.new(my_username, my_password)

  class Client
    include HTTMultiParty

    base_uri "https://www.sendregning.no"
    format   :xml

    def initialize(username, password, options = {})
      @auth = { username: username, password: password }
      @test = true if options[:test]
    end

    # Performs a GET request
    def get(query = {})
      self.class.get("/ws/butler.do", query_options(query))
    end

    # Performs a POST request
    def post(query = nil)
      self.class.post("/ws/butler.do", query_options(query))
    end

    def post_xml(xml, query = {})
      query[:xml] = xml_file(xml)
      self.class.post("/ws/butler.do",
                      query_options(query).merge(detect_mime_type: true))
    end

    # Returns a list of recipients
    def recipients
      response = get(action: "select", type: "recipient")
      response["recipients"]["recipient"]
    end

    # Instances a new invoice
    def new_invoice(attributes = {})
      Sendregning::Invoice.new(attributes.merge({ client: self }))
    end

    # Sends an invoice
    def send_invoice(invoice)
      response = post_xml(invoice.to_xml,
                          { action: "send", type: "invoice" })
      InvoiceParser.parse(response, invoice)
    end

    # Finds an invoice by invoice number
    def find_invoice(invoice_id)
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct! :xml, version: "1.0", encoding: "UTF-8"
      request_xml = builder.select do |select|
        select.invoiceNumbers do |numbers|
          numbers.invoiceNumber invoice_id
        end
      end
      response = post_xml(request_xml,
                          { action: "select", type: "invoice" })
      begin
        InvoiceParser.parse(response)
      rescue StandardError
        nil
      end
    end

    protected

    # Prepares options for a request
    def query_options(query = {})
      query[:test] = "true" if @test
      { basic_auth: @auth, query: query }
    end

    def xml_file(xml)
      UploadIO.new(StringIO.new(xml), "text/xml", "request.xml")
    end
  end
end
