module ContextController
  class Engine < ::Rails::Engine
    config.autoload_paths += %W[#{config.root}/lib/]
  end
end