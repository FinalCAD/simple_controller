require 'simple_controller/router/route'

module SimpleController
  class Router
    class Mapper
      attr_reader :router, :namespace, :controller_name

      def initialize(router, namespace: nil, controller_name: nil)
        @router, @namespace, @controller_name = router, namespace, controller_name
      end

      def controller(controller_name, &block)
        raise "can't have multiple controller scopes" if has_controller_name?

        mapper = self.class.new(router, controller_name: controller_name)
        mapper.instance_eval(&block)
      end

      def match(arg)
        if arg.class == Hash
          raise "takes only one option" unless arg.size == 1
          route_path = arg.keys.first.to_s
          partition = arg.values.first.to_s.rpartition("#")
        else
          route_path = arg.to_s
          partition = route_path.rpartition("/")
        end

        route_path = "#{self.controller_name}/#{route_path}" if self.controller_name
        controller_name = self.controller_name || partition.first
        action_name = partition.last

        router.add_route route_path, Route.new(controller_name, action_name)
      end

      def has_controller_name?
        !!controller_name
      end
    end
  end
end