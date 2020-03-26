# Devise::Sso

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/devise/sso`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/devise-sso. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/devise-sso/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Devise::Sso project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/devise-sso/blob/master/CODE_OF_CONDUCT.md).
