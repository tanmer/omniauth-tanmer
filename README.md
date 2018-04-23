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

Put below code to `config/application.rb`:

    config.middleware.use OmniAuth::Builder do
        provider :tanmer, ENV['OAUTH_TANMER_KEY'], ENV['OAUTH_TANMER_SECRET'],
        scope: 'public',
        client_options: { 
            site: ENV['OAUTH_TANMER_SITE'],
            authorize_url: ENV['OAUTH_TANMER_AUTH_URL'] || '/oauth/authorize'
        }
    end

Like docker-compose/kubernetes infrastructure, we set `ENV['OAUTH_TANMER_SITE']='http://sso`, then user frontend will redirect to `http://sso/oauth/authorize`， To fix this, we can define `ENV['OAUTH_TANMER_AUTH_URL']='http://sso.my-site.com/oauth/authorize'`

## Features

Sync permissions:

```ruby
current_permissions = [
  { name: '查看', group_name: '会员', subject_class: 'Member', subject_id: nil, action: 'show', description: '' },
  { name: '创建', group_name: '会员', subject_class: 'Member', subject_id: nil, action: 'create', description: '' },
  { name: '修改', group_name: '会员', subject_class: 'Member', subject_id: nil, action: 'update', description: '' },
  { name: '删除', group_name: '会员', subject_class: 'Member', subject_id: nil, action: 'destroy', description: '' },
]

client = Omniauth::Tanmer::Permission.new(ENV['OAUTH_TANMER_HOST'], ENV['OAUTH_TANMER_KEY'], ENV['OAUTH_TANMER_SECRET'])
client.sync(current_permissions)
```

This will sync permission definitions between local project and SSO.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
