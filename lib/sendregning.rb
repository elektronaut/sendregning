require 'rubygems'
require 'builder'
require 'httparty'
require 'httmultiparty'

dir = Pathname(__FILE__).dirname.expand_path

require dir + 'sendregning/xml_serializer'
require dir + 'sendregning/client'
require dir + 'sendregning/invoice'
require dir + 'sendregning/invoice_serializer'
require dir + 'sendregning/line'
require dir + 'sendregning/line_serializer'
require dir + 'sendregning/version'

module Sendregning
end
