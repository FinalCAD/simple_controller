$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simple_controller'

Dir[Dir.pwd + '/spec/support/**/*.rb'].each { |f| require f }