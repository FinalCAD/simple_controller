require 'simple_controller/router/route'

module SimpleController
  class Router
    class Mapper
      attr_reader :router, :scope

      def initialize(router, scope=nil)
        @router, @scope = router, scope
      end

      def controller(controller_name, &block)
        raise "can't have multiple controller scopes" if has_scope?

        mapper = self.class.new(router, controller_name)
        mapper.instance_eval(&block)
      end

      def match(arg)
        controller_name = scope
        if arg.class == Hash
          raise "takes only one option" unless arg.size == 1
          route_path = arg.keys.first.to_s
          partition = arg.values.first.to_s.rpartition("#")
        else
          route_path = arg.to_s
          partition = route_path.rpartition("/")
        end

        route_path = "#{scope}/#{route_path}" if scope
        controller_name ||= partition.first
        action_name = partition.last

        router.add_route route_path, Route.new(controller_name, action_name)
      end

      def has_scope?
        !!scope
      end
    end
  end
end