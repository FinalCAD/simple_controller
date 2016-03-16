require 'simple_controller/router/route'
require 'simple_controller/router/mapper'

module SimpleController
  class Router
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :route_mapping, :route, :route_path, :params, :controller_path_block
      end
      def initialize
        @route_mapping = {}
      end

      def call(route_path, params={})
        @route_path = route_path.to_s
        @route = @route_mapping[@route_path]
        @params = params

        raise "#{self.class} route for '#{@route_path}' not found" unless route

        _call
      ensure
        @route_path = @route = @params = nil
      end

      def route_paths
        route_mapping.keys
      end

      def draw(&block)
        mapper = Mapper.new(self)
        mapper.instance_eval(&block)
        self
      end

      def add_route(route_path, controller_path, action)
        @route_mapping[route_path] = Route.new(controller_path, action)
      end

      def parse_controller_path(&block)
        @controller_path_block = block
      end

      protected
      def _call
        route.call params, controller_path_block
      end

      module ClassMethods
        def instance
          @instance ||= new
        end

        def call(*args)
          instance.call(*args)
        end
      end
    end
  end
end