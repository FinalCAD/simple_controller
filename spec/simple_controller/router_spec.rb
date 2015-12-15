require 'spec_helper'

describe SimpleController::Router do
  let(:instance) { ThreesRouter.instance }

  describe "#route_paths" do
    let(:instance) do
      class SimpleRouter < SimpleController::Router; end
      SimpleRouter.instance.draw do
        match 'call/me'
        controller :control do
          match :basic_route
        end
      end
      SimpleRouter.instance
    end

    subject { instance.route_paths }

    it "returns the route paths" do
      expect(subject).to match_array %w[call/me control/basic_route]
    end
  end

  describe "#call" do
    let(:params) { { number: 6 } }
    let(:namespace) { nil }
    let(:route_path) { [namespace, "threes", action_name].compact.join("/") }
    subject { instance.call route_path, params }

    shared_examples "route variations" do |controller_class|
      context "only route" do
        let(:action_name) { "multiply" }
        it ("calls the correct controller function") do
          expect_any_instance_of(controller_class).to receive(action_name).and_call_original
          expect(subject).to eql 18
        end
      end

      context "route with to" do
        let(:action_name) { "dividing" }
        it ("calls the correct controller function") do
          expect_any_instance_of(controller_class).to receive(:divide).and_call_original
          expect(subject).to eql 0.5
        end
      end

      context "within controller scope" do
        let(:action_name) { "add" }
        it ("calls the correct controller function") do
          expect_any_instance_of(controller_class).to receive(action_name).and_call_original
          expect(subject).to eql 9
        end

        context "route with to" do
          let(:action_name) { "subtracting" }
          it ("calls the correct controller function") do
            expect_any_instance_of(controller_class).to receive(:subtract).and_call_original
            expect(subject).to eql -3
          end
        end
      end

      context "defined by controller" do
        let(:action_name) { "power" }

        it ("calls the correct controller function") do
          expect_any_instance_of(controller_class).to receive(action_name).and_call_original
          expect(subject).to eql 729
        end
      end
    end

    include_examples "route variations", ThreesController

    context "with namespace appended" do
      let(:namespace) { "namespace" }

      include_examples "route variations", Namespace::ThreesController
    end

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