module SimpleController
  class Router
    class Route
      attr_reader :controller_name, :action_name
      attr_accessor :controller_name_block

      def initialize(controller_name, action_name)
        @controller_name, @action_name = controller_name, action_name
      end

      def controller(controller_name_block=nil)
        controller_name_block ? controller_name_block.call(controller_name) : "#{controller_name}_controller".classify.constantize
      end

      def call(params, controller_name_block=nil)
        controller(controller_name_block).call action_name, params
      end
    end
  end
end