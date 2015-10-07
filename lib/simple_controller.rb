autoload = false
# autoload = true #uncomment for testing purposes only, not covered by rspec

require "simple_controller/version"

require 'active_support/callbacks'
require 'active_support/hash_with_indifferent_access'

if autoload && defined?(Rails)
  require 'simple_controller/engine'
else
  require 'simple_controller/base'
end


module SimpleController
  # Your code goes here...
end
