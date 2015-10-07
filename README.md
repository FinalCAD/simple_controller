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
        @user = User.find(context.user_id)
    end

    def touch
        @user.touch
        @user
    end
end

UserController.call(:touch, user_id: 1) # => returns User object
```

It works like a Rails Controller, but has the following differences:
- `context` is used instead of `params`, and `context` is an [`OpenStruct`](http://ruby-doc.org/stdlib-2.2.3/libdoc/ostruct/rdoc/OpenStruct.html)
- `action_name` is a `Symbol`
- It isn't part of the Rails request stack, so many methods are missing (obviously)