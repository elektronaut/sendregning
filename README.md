[![Version](https://img.shields.io/gem/v/sendregning.svg?style=flat)](https://rubygems.org/gems/sendregning)
[![Build](https://github.com/elektronaut/sendregning/actions/workflows/build.yml/badge.svg)](https://github.com/elektronaut/sendregning/actions/workflows/build.yml)

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


## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/elektronaut/sendregning). See
[CONTRIBUTING.md](CONTRIBUTING.md) for how to get set up and how
commits are formatted, and note that this project ships with a
[code of conduct](CODE_OF_CONDUCT.md).

## License

Released under the [MIT License](LICENSE).
