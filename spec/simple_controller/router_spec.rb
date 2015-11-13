require 'spec_helper'

describe SimpleController::Router do
  let(:instance) { ThreesRouter.instance }

  describe "#call" do
    let(:params) { { number: 6 } }
    subject { instance.call action_name, params }

    shared_examples "route variations" do
      context "only route" do
        let(:action_name) { "threes/multiply" }
        it ("calls the correct controller function") { expect(subject).to eql 18 }
      end

      context "route with to" do
        let(:action_name) { "threes/dividing" }
        it ("calls the correct controller function") { expect(subject).to eql 0.5 }
      end

      context "within controller scope" do
        let(:action_name) { "threes/add" }
        it ("calls the correct controller function") { expect(subject).to eql 9 }

        context "route with to" do
          let(:action_name) { "threes/subtracting" }
          it ("calls the correct controller function") { expect(subject).to eql -3 }
        end
      end
    end

    include_examples "route variations"

    context "with #parse_controller_name" do
      let(:instance) do
        instance = ThreesRouter.instance.dup
        instance.parse_controller_name {|controller_name| "#{controller_name}_suffix_controller".classify.constantize }
        instance
      end
      include_examples "route variations"
    end
  end
end