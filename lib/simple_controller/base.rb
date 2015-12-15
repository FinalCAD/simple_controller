require 'simple_controller/base/core'
require 'simple_controller/base/callbacks'

module SimpleController
  class Base
    include Core
    include Callbacks # included last to wrap method
  end
end