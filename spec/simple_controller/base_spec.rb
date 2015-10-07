require 'spec_helper'

class Controller < SimpleController::Base
  before_action(only: :triple) { params[:number] = params[:number].to_i }

  def triple
    params[:number] * 3
  end
end


describe SimpleController::Base do
  describe "instance" do
    let(:instance) { Controller.new }

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
  end

  describe "class" do
    describe "::call" do
      subject { Controller.call(:triple, number: 3) }

      it "works" do
        expect(subject).to eql 9
      end
    end
  end
end