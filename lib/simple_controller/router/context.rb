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

      def _call
        route.call params, context, controller_path_block
      end

      def parse_route_path(route_path)
        route_path = route_path.dup
        variant = extract_extension!(route_path)
        format = extract_extension!(route_path)

        if format.empty?
          format = variant
          variant = ''
        end
        @context = { format: format, variant: variant }
        context.each { |k, v| context[k] = v.empty? ? nil : context[k].to_sym }

        route_path
      end

      def extract_extension!(route_path)
        extension = File.extname(route_path)
        route_path.chomp!(extension)
        extension[0] = ''
        extension
      end
    end
  end
end