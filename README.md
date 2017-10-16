# Omniauth::Tanmer

This is the OAuth2 strategy for authenticating to your Tanmer service.

## Requirements
 
## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-tanmer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-tanmer

## Usage

    use OmniAuth::Builder do
      provider :tanmer, ENV['TANMER_KEY'], ENV['TANMER_SECRET'], scope: 'tanmer_service'
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
