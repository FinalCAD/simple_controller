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

  def log
    Math.log(3, params[:number]) if context.format == :integer && context.variant == :math
  end
end