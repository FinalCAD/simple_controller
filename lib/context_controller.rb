autoload = false
# autoload = true #uncomment for testing purposes only, not covered by rspec

require "context_controller/version"

if autoload && defined?(Rails)
  require 'context_controller/engine'
else
  require 'context_controller/base'
end


module ContextController
  # Your code goes here...
end
