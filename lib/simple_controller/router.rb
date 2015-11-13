require 'simple_controller/router/mapper'

module SimpleController
  class Router
    attr_reader :route_mapping, :route, :route_path

    include ActiveSupport::Callbacks
    define_callbacks :call

    def initialize
      @route_mapping = {}
    end

    def call(route_path, params={})
      @route_path = route_path
      @route = @route_mapping[route_path]

      run_callbacks(:call) do
        @route.call params, &self.class.controller_name_block
      end
    ensure
      @route_path = nil
      @route = nil
    end

    def draw(&block)
      mapper = Mapper.new(self)
      mapper.instance_eval(&block)
    end

    def add_route(route_path, route)
      @route_mapping[route_path] = route
    end

    class << self
      attr_reader :controller_name_block

      def instance
        @instance ||= new
      end

      def call(*args)
        instance.call(*args)
      end

      def parse_controller_name(&block)
        @controller_name_block = block
      end
    end
  end
end