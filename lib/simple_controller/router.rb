require 'simple_controller/router/mapper'

module SimpleController
  class Router
    attr_reader :route_mapping, :route, :route_path, :controller_path_block

    include ActiveSupport::Callbacks
    define_callbacks :call

    def initialize
      @route_mapping = {}
    end

    def call(route_path, params={})
      @route_path = route_path.to_s
      @route = @route_mapping[@route_path]

      raise "#{self.class} route for '#{@route_path}' not found" unless route

      run_callbacks(:call) do
        @route.call params, controller_path_block
      end
    ensure
      @route_path = nil
      @route = nil
    end

    def route_paths
      route_mapping.keys
    end

    def draw(&block)
      mapper = Mapper.new(self)
      mapper.instance_eval(&block)
    end

    def add_route(route_path, route)
      @route_mapping[route_path] = route
    end

    def parse_controller_path(&block)
      @controller_path_block = block
    end

    class << self
      def instance
        @instance ||= new
      end

      def call(*args)
        instance.call(*args)
      end
    end
  end
end