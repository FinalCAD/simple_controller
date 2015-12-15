require 'spec_helper'

describe SimpleController::Router::Mapper do
  let(:namespaces) { [] }
  let(:instance) { described_class.new(nil, namespaces) }

  describe "#namespace" do
    context "namespace is filled" do
      let(:namespaces) { %w[1] }

      it "should keep namespaces the original_state" do
        instance.namespace("waka") { }
        expect(instance.namespaces).to eql %w[1]
      end
    end
  end
end