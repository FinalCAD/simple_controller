require 'spec_helper'

describe SimpleController::Base do
  describe "instance" do
    let(:instance) { BasicController.new }

    describe "#call" do
      let(:params) { { number: 3 } }
      subject { instance.call(:triple, params) }

      it "works" do
        expect(subject).to eql 9
      end

      describe "callbacks" do
        let(:params) { { number: "3" }  }

        it "works" do
          expect(subject).to eql 9
        end
      end

      describe "HashWithIndifferentAccess" do
        let(:params) { { 'number' => 3 }  }

        it "works" do
          expect(subject).to eql 9
        end
      end
    end

    context "after a #call is called" do
      before { instance.call(:triple, params, context) }
      let(:params) { {} }
      let(:context) { {} }

      describe "#action_name" do
        subject { instance.action_name }

        it "shows the action name" do
          expect(subject).to eql "triple"
        end
      end

      describe "#controller_path" do
        subject { instance.controller_path }

        it "gives nil" do
          expect(subject).to eql nil
        end

        context "with controller given in params" do
          let(:params) { { controller: "api/numbers" } }

          it "shows the controller name" do
            expect(subject).to eql "api/numbers"
          end
        end
      end

      describe "#controller_name" do
        subject { instance.controller_name }

        it "gives nil" do
          expect(subject).to eql nil
        end

        context "with controller given in params" do
          let(:params) { { controller: "api/numbers" } }

          it "shows the controller name" do
            expect(subject).to eql "numbers"
          end
        end
      end

      describe "#params" do
        let(:params) { { number: 3, controller: "api/numbers" } }
        subject { instance.params }

        it "works" do
          expect(subject).to eql ActiveSupport::HashWithIndifferentAccess.new(params)
        end
      end

      describe "#context" do
        let(:context) { { some_context: true } }
        subject { instance.context }

        it "works" do
          expect(subject).to eql OpenStruct.new(context)
        end
      end
    end
  end

  describe "class" do
    describe "::call" do
      subject { BasicController.call(:triple, number: 3) }

      it "works" do
        expect(subject).to eql 9
      end
    end
  end
end