class ThreesRouter < SimpleController::Router
end

ThreesRouter.instance.draw do
  match "threes/multiply"
  match "threes/dividing" => "threes#divide"

  controller :threes do
    match :add
    match subtracting: "subtract"
  end
end