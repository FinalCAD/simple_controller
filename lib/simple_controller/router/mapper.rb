require 'simple_controller/router/route'

module SimpleController
  class Router
    class Mapper
      attr_reader :router, :namespaces, :controller_path

      def initialize(router, namespaces=[], controller_path=nil)
        @router, @namespaces, @controller_path = router, namespaces, controller_path
      end

      def namespace(namespace, &block)
        @namespaces << namespace

        mapper = self.class.new(router, namespaces, controller_path)
        mapper.instance_eval(&block)
      ensure
        @namespaces.pop
      end

      def controller(controller_path, options={}, &block)
        raise "can't have multiple controller scopes" if self.controller_path

        mapper = self.class.new(router, namespaces, controller_path)
        Array(options[:actions]).each { |action| mapper.match(action) }

        mapper.instance_eval(&block) if block_given?
      end

      def match(arg)
        route_path, partition = parse_match_arg(arg)

        route_parts = [route_path]
        route_parts.unshift(self.controller_path) if self.controller_path
        route_parts.unshift(*namespaces)

        controller_path_parts = [self.controller_path || partition.first]
        controller_path_parts.unshift(*namespaces)

        action_name = partition.last

        router.add_route join_parts(route_parts), Route.new(join_parts(controller_path_parts), action_name)
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