module ContextController
  class Base
    include Callbacks

    attr_reader :context, :action_name

    def call(action_name, context={})
      setup(action_name, context)
      public_send @action_name
    end

    protected

    def setup(action_name, context)
      @context ||= OpenStruct.new(context)
      @context.options ||= {}
      @action_name ||= action_name.to_sym
    end

    class << self
      def call(*args)
        new.call *args
      end
    end
  end
end