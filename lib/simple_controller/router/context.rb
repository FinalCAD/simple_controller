module SimpleController
  class Router
    module Context
      extend ActiveSupport::Concern

      included do
        attr_reader :context
      end

      def call(route_path, params={})
        route_path = parse_route_path(route_path)

        super(route_path, params)
      ensure
        @context = nil
      end

      protected

      def _call(route)
        route.call params, context, controller_path_block
      end

      def parse_route_path(route_path)
        processors = []

        until (extension = File.extname(route_path)).empty?
          route_path = route_path.chomp(extension)
          processors << extension[1..-1].to_sym
        end

        @context = { processors: processors }

        route_path
      end
    end
  end
end