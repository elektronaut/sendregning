# Sendregning

Ruby client for the SendRegning Web Service.

## Getting started

Install with RubyGems:

    gem install sendregning

Now start sending invoices:

    # Create a new client
    client = Sendregning::Client.new('my@email.com', 'myawesomepassword')

    # Start a new email invoice
    invoice = client.new_invoice(
      name:           'My Client',
      zip:            '0123',
      city:           'Oslo',
      shipment:       :email,
      emailaddresses: 'my@email.com'
    )

    # Add an item
    invoice.add_line qty: 1, desc: 'Bananaphone', unitPrice: '500,00'

    # Send it away!
    invoice.send!

    # Get the invoice number for future reference
    id = invoice.invoiceNo

Let's check how we're doing!

    invoice = client.find_invoice(id)
    invoice.paid? # => true

Pass `test: true` to the constructor to use the test API

    # Create a new client
    client = Sendregning::Client.new('my@email.com', 'myawesomepassword', test: true)


## Copyright

Copyright (c) 2010 Inge Jørgensen. See LICENSE for details.
