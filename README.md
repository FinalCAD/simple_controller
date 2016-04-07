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
class Router < SimpleController::Router; end

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

To customize the controller class:
```ruby
Router.instance.parse_controller_path do |controller_path|
  # similar to default implementation
  "#{controller_name}_suffix_controller".classify.constantize
end
Router.call("threes/multiply", number: 6) # calls ThreesSuffixController.call(:multiply, number: 6)
```

Routers add the following Rails features to the Controllers:
- `params[:action]` and `params[:controller]`
- `controller_path` and `controller_name`

## Post-Process
Inspired by [`rails/sprockets` Processors](https://github.com/rails/sprockets#using-processors), Routes can have processor suffixes to ensure that controller endpoints
are [composable](https://en.wikipedia.org/wiki/Function_composition_(computer_science)). For example, given:

```ruby
class FoldersController < FileSystemController
  def two_readmes
    dir = create_new_directory
    dir.add_files Router.call('files/readme'), Router.call('files/readme')
    dir.path
  end
end

class FilesController < FileSystemController
  def readme
    write_new_file_and_return_path
  end
end
```

And the [Router](#router) is set up, `FoldersController#two_readmes` generates a directory of `FilesController#readme`s. Processors add the ability to do these calls:

```ruby
# calls the `s3_key` processor
Router.call('files/readme.s3_key')
# equivalent to:
FilesController.call(:readme, {}, { processors: [:s3_key] }) 

# calls the `zip` processor then the `s3_key` processor
Router.call('folders/two_readmes.s3_key.zip')
# equivalent to (NOTE the reverse order to the processor suffixes):
FoldersController.call(:two_readmes, {}, { processors: [:zip, :s3_key] })
```

Internally, the `#post_process` method takes the output of your `action` and does the following:
```ruby
# pseudo-code for `SimpleController::Base#call`
def call
   post_process(__call_the_controller_action__, processors)
end
```

So the processors (`zip` and `s3_key`) can be defined and implemented in a common Parent controller `#post_process` method, in this case:
```ruby
class FileSystemController < SimpleController::Base
  # output => "path_to_file_or_directory"
  # processors => some combination of [:zip, :s3_key]
  def post_process(output, processors)
    processors.each do |processor|
      case processor
      when :zip
        output = zip_directory_and_return_path_of_zip(output)
      when :s3_key
        output = upload_file_path_to_amazon_s3_and_return_the_s3_key(output)
      end
    end
    output
  end
end
```