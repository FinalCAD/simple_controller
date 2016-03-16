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

    describe "#action_name" do
      subject { instance.action_name }
      before { instance.call(:triple, number: 3) }

      it "works" do
        expect(subject).to eql "triple"
      end
    end

    describe "#params" do
      subject { instance.params }
      before { instance.call(:triple, number: 3) }

      it "works" do
        expect(subject).to eql ActiveSupport::HashWithIndifferentAccess.new(number: 3)
      end
    end

    describe "#context" do
      subject { instance.context }
      before { instance.call(:triple, { number: 3 }, some_context: true) }

      it "works" do
        expect(subject).to eql OpenStruct.new(some_context: true)
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