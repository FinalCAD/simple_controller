class ThreesController < SimpleController::Base
  def multiply
    3 * params[:number]
  end

  def divide
    3.to_f / params[:number]
  end

  def add
    3 + params[:number]
  end

  def subtract
    3 - params[:number]
  end

  def power
    3**params[:number]
  end
end