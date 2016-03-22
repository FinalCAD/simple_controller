require 'spec_helper'

class SimpleRouter < SimpleController::Router; end

describe SimpleController::Router do
  describe "#call" do
    let(:instance) { ThreesRouter.instance }

    let(:params) { { number: 6 } }
    let(:context) { { format: nil, variant: nil } }

    let(:namespace) { nil }
    let(:route_action_name) { action_name }
    let(:route_path) { [namespace, "threes", route_action_name].compact.join("/") }
    let(:controller_path) { [namespace, "threes"].compact.join("/") }

    subject { instance.call route_path, params }

    let(:controller_class) { ThreesController }
    let(:controller) { controller_class.new }
    let(:action_name) { "add" }

    before do
      expect(controller_class).to receive(:new).and_return(controller)
      expect(controller).to receive(action_name).and_call_original
    end

    shared_examples "route variations" do
      context "only route" do
        let(:action_name) { "multiply" }
        it "calls the correct controller function" do
          expect(subject).to eql 18
        end
      end

      context "route with to" do
        let(:action_name) { 'divide' }
        let(:route_action_name) { "dividing" }
        it "calls the correct controller function" do
          expect(subject).to eql 0.5
        end
      end

      context "within controller scope" do
        let(:action_name) { "add" }
        it "calls the correct controller function" do
          expect(subject).to eql 9
        end

        context "route with to" do
          let(:action_name) { 'subtract' }
          let(:route_action_name) { "subtracting" }
          it "calls the correct controller function" do
            expect(subject).to eql -3
          end
        end
      end

      context "defined by controller" do
        let(:action_name) { "power" }

        it "calls the correct controller function" do
          expect(subject).to eql 729
        end
      end
    end

    include_examples "route variations"

    context "with symbol route_path" do
      subject { instance.call route_path.to_sym, params }

      it "calls the correct controller function" do
        expect(subject).to eql 9
      end
    end

    context "with namespace appended" do
      let(:namespace) { "namespace" }
      let(:controller_class) { Namespace::ThreesController }

      include_examples "route variations"
    end

    context "with #parse_controller_path" do
      before do
        instance.parse_controller_path {|controller_path| "#{controller_path}_suffix_controller".classify.constantize }
      end
      let(:controller_class) { ThreesSuffixController }

      include_examples "route variations"
    end

    describe "setting params" do
      it "sets the controller and action as first key-values" do
        expect(subject).to eql 9
        expect(controller.params).to eql params.merge(controller: controller_path, action: action_name).stringify_keys
        expect(controller.params.keys).to eql %w[controller action number]
      end
    end

    describe "setting the context" do
      let(:action_name) { 'log' }
      let(:params) { { number: 9 } }

      it "sets processors to nil" do
        expect(subject).to eql nil
        expect(controller.context).to eql OpenStruct.new(processors: [])
      end

      context "with format and variant" do
        let(:route_action_name) { "log.string.double" }

        it "it sets the correct context" do
          expect(subject).to eql 0.5
          expect(controller.context).to eql OpenStruct.new(processors: %i[double string])
        end
      end
    end
  end

  describe "#route_paths" do
    let(:instance) { SimpleRouter.new }
    before do
      instance.draw do
        match 'call/me'
        controller :control do
          match :basic_route
        end
      end
    end

    subject { instance.route_paths }

    it "returns the route paths" do
      expect(subject).to match_array %w[call/me control/basic_route]
    end
  end
end