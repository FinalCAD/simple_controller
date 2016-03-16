module SimpleController
  class Router
    class Route
      attr_reader :controller_path, :action_name
      attr_accessor :controller_path_block

      def initialize(controller_path, action_name)
        @controller_path, @action_name = controller_path, action_name
      end

      def controller(controller_path_block=nil)
        controller_path_block ? controller_path_block.call(controller_path) : "#{controller_path}_controller".classify.constantize
      end

      def call(params, controller_path_block=nil)
        controller(controller_path_block).call action_name, params
      end
    end
  end
end