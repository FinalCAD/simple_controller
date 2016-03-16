require 'simple_controller/base/core'
require 'simple_controller/base/context'
require 'simple_controller/base/callbacks'

module SimpleController
  class Base
    include Core
    include Context
    include Callbacks # included last to wrap method
  end
end