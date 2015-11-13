module SimpleController
  class Router
    class Route
      attr_reader :controller_name, :action_name

      def initialize(controller_name, action_name)
        @controller_name, @action_name = controller_name, action_name
      end

      def controller(&block)
        block_given? ? block.call(controller_name) : "#{controller_name}_controller".classify.constantize
      end

      def call(params, &block)
        controller(&block).call action_name, params
      end
    end
  end
end