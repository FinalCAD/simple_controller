# SimpleController

Use the Ruby on Rails Controller pattern outside of the Rails request stack.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_controller'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_controller

## Usage

```ruby
class UserController < SimpleController::Base
    before_action do
        @user = User.find(params[:user_id])
    end

    def touch
        @user.touch
        @user
    end
end

UserController.call(:touch, user_id: 1) # => returns User object
UserController.new.call(:touch, user_id: 1) # => same as above
```

It works like a Rails Controller, but has only has the following features:
- Callbacks
- `params`
- `action_name`