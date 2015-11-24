require 'simple_controller/router/route'

module SimpleController
  class Router
    class Mapper
      attr_reader :router, :namespaces, :controller_name

      def initialize(router, namespaces=nil, controller_name=nil)
        @router, @namespaces, @controller_name = router, namespaces, controller_name
      end

      def namespace(namespace, &block)
        @namespaces ||= []
        @namespaces << namespace

        mapper = self.class.new(router, namespaces, controller_name)
        mapper.instance_eval(&block)
      end

      def controller(controller_name, &block)
        raise "can't have multiple controller scopes" if self.controller_name

        mapper = self.class.new(router, namespaces, controller_name)
        mapper.instance_eval(&block)
      end

      def match(arg)
        route_path, partition = parse_match_arg(arg)

        route_parts = [route_path]
        route_parts.unshift(self.controller_name) if self.controller_name
        route_parts.unshift(*namespaces)

        controller_name_parts = [self.controller_name || partition.first]
        controller_name_parts.unshift(*namespaces)

        action_name = partition.last

        router.add_route join_parts(route_parts), Route.new(join_parts(controller_name_parts), action_name)
      end

      protected
      def join_parts(parts)
        parts.map do |part|
          s = part.to_s.dup
          s.chomp!("/")
          s.slice!(0) if part[0] == "/"
          s
        end.join("/")
      end

      def parse_match_arg(arg)
        if arg.class == Hash
          raise "takes only one option" unless arg.size == 1
          route_path = arg.keys.first.to_s
          partition = arg.values.first.to_s.rpartition("#")
        else
          route_path = arg.to_s
          partition = route_path.rpartition("/")
        end
        [route_path, partition]
      end
    end
  end
end