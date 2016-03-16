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

## Router
An **optional** router is provided to decouple controller classes from identifiers.

```ruby
class Router < SimpleController::Router
end

# Router.instance is a singleton for ease of use
Router.instance.draw do
  match "threes/multiply"
  match "threes/dividing" => "threes#divide"

  controller :threes do
    match :add
    match subtracting: "subtract"
  end
  # custom syntax
  controller :threes, actions: %i[power]
  
  namespace :some_namespace do
    match :magic
  end
  
  # no other Rails-like syntax is available
end

Router.call("threes/multiply", number: 6) # calls ThreesController.call(:multiply, number: 6)
Router.instance.call("threes/multiply", number: 6) # same as above
```

To custom namespace the controller:
```ruby
Router.instance.parse_controller_path {|controller_path| "#{controller_path}_controller".classify.constantize } # this is the default

Router.call("threes/multiply", number: 6) # calls ThreesController.call(:multiply, number: 6)
```