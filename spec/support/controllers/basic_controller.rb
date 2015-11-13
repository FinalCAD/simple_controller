class BasicController < SimpleController::Base
  before_action(only: :triple) { params[:number] = params[:number].to_i }

  def triple
    params[:number] * 3
  end
end