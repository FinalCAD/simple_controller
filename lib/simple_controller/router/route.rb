module SimpleController
  class Router
    class Route
      attr_reader :controller_path, :action_name

      def initialize(controller_path, action_name)
        @controller_path, @action_name = controller_path, action_name
      end

      def call(*args)
        controller_path_block = args.last
        controller_class = controller_path_block ? controller_path_block.call(controller_path) : "#{controller_path}_controller".classify.constantize
        controller_class.call action_name, *args[0..-2]
      end
    end
  end
end