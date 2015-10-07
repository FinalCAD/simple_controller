module SimpleController
  module Core
    extend ActiveSupport::Concern

    included do
      attr_reader :params, :action_name
    end

    def call(action_name, params={})
      @params ||= ActiveSupport::HashWithIndifferentAccess.new(params)
      @action_name ||= action_name.to_s

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