defmodule ParknSpots.Structs.Spot do
  @derive [Poison.Encoder]
  defstruct [:id, :address, :spots]
end 
