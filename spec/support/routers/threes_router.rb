class ThreesRouter < SimpleController::Router
end

ThreesRouter.instance.draw do
  draw_block = Proc.new do
    match "threes/multiply"
    match "threes/dividing" => "threes#divide"

    controller :threes do
      match :add
      match subtracting: "subtract"
    end
    controller :threes, actions: %i[power log]
  end

  instance_eval(&draw_block)

  namespace :namespace do
    instance_eval(&draw_block)
  end
end