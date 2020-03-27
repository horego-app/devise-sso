# Devise::Sso
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise'
gem 'devise-sso', github: 'printerous/devise-sso'
```

And then execute:

    $ bundle install

## Usage

## Setup Sso Server

```ruby
# config/routes.rb
devise_for :users, path: 'sso', path_names: {
  sign_in: 'sessions/login',
  sign_out: 'sessions/logout'
}, controllers: {
  sessions: 'devise/sso/sessions'
}

devise_scope :user do
  post 'sso/authenticate', to: 'devise/sso/authentications#create'
end

# Model
class User < ApplicationRecord
  devise :sso_server

  # override sso-server authentication response
  def sso_data
    {
      id: id,
      email: email,
      name: name
    }
  end
end

# Controller
class ApplicationController < ActionController::Base
  private

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || session.delete(:sso_redirect) || stored_location_for(resource)
  end
end
```

## Setup Sso Client

```ruby
# Controller
before_action :authenticate_sso!

# ENV
SSO_HOST=sso.lvh.me
SSO_PORT=3000
SSO_LOGIN_PATH=/sso/sessions/login
SSO_AUTH_PATH=/sso/authenticate
SSO_SHARED_DOMAIN='.lvh.me'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/printerous/devise-sso. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/printerous/devise-sso/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Devise::Sso project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/printerous/devise-sso/blob/master/CODE_OF_CONDUCT.md).
