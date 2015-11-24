require 'spec_helper'

describe SimpleController::Router do
  let(:instance) { ThreesRouter.instance }

  describe "#call" do
    let(:params) { { number: 6 } }
    subject { instance.call action_name, params }

    shared_examples "route variations" do |controller_class|
      context "only route" do
        let(:action_name) { "threes/multiply" }
        it ("calls the correct controller function") do
          expect_any_instance_of(controller_class).to receive(:multiply).and_call_original
          expect(subject).to eql 18
        end
      end

      context "route with to" do
        let(:action_name) { "threes/dividing" }
        it ("calls the correct controller function") do
          expect_any_instance_of(controller_class).to receive(:divide).and_call_original
          expect(subject).to eql 0.5
        end
      end

      context "within controller scope" do
        let(:action_name) { "threes/add" }
        it ("calls the correct controller function") do
          expect_any_instance_of(controller_class).to receive(:add).and_call_original
          expect(subject).to eql 9
        end

        context "route with to" do
          let(:action_name) { "threes/subtracting" }
          it ("calls the correct controller function") do
            expect_any_instance_of(controller_class).to receive(:subtract).and_call_original
            expect(subject).to eql -3
          end
        end
      end
    end

    include_examples "route variations", ThreesController

    context "with #parse_controller_name" do
      let(:instance) do
        instance = ThreesRouter.instance.dup
        instance.parse_controller_name {|controller_name| "#{controller_name}_suffix_controller".classify.constantize }
        instance
      end
      include_examples "route variations", ThreesSuffixController
    end
  end
end