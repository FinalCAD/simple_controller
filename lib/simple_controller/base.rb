require 'simple_controller/core'
require 'simple_controller/callbacks'

module SimpleController
  class Base
    include Core
    include Callbacks # included last to wrap method
  end
end