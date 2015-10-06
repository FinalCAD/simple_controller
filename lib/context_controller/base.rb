require 'context_controller/core'
require 'context_controller/callbacks'

module ContextController
  class Base
    include Core
    include Callbacks # included last to wrap method
  end
end