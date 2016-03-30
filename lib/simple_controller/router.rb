require 'simple_controller/router/core'
require 'simple_controller/router/context'

module SimpleController
  class Router
    include Core
    include Context
  end
end