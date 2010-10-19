module Sendregning

	# Client for the SendRegning Web Services.
	#
	# Usage example:
	#
	#  client = SendRegning::Client.new(my_username, my_password)
	
	class Client
		include HTTParty

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
		
			# Returns a list of recipients
			def recipients
				response = get(:action => 'select', :type => 'recipient')
				response['recipients']['recipient']
			end

		protected

			# Prepares options for a request
			def query_options(query={})
				query[:test] = 'true' if @test
				{:basic_auth => @auth, :query => query}
			end

	end
end