require 'spec_helper'

describe SimpleController::Router do
  describe "::call" do
    let(:params) { { number: 6 } }
    subject { ThreesRouter.call action_name, params }

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
end