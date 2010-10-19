require 'httparty'

dir = Pathname(__FILE__).dirname.expand_path

require dir + 'sendregning/client'
require dir + 'sendregning/invoice'
require dir + 'sendregning/line'

module Sendregning
end