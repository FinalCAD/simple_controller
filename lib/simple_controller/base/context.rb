module SimpleController
  class Base
    module Context
      extend ActiveSupport::Concern

      included do
        attr_reader :context
      end

      def call(action_name, params={}, context={})
        @context ||= OpenStruct.new context

        super(action_name, params)
      end

      def call_action(*args)
        post_process super, context.processors || []
      end

      protected

      def post_process(output, processors)
        output
      end
    end
  end
end