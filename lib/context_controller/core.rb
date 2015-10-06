module ContextController
  module Core
    extend ActiveSupport::Concern

    included do
      attr_reader :context, :action_name
    end

    def call(action_name, context={})
      @context ||= OpenStruct.new(context)
      @context.options ||= {}
      @action_name ||= action_name.to_sym

      call_action
    end

    protected

    def call_action
      public_send action_name
    end

    module ClassMethods
      def call(*args)
        new.call *args
      end
    end
  end
end