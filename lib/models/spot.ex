defmodule ParknSpots.Models.Spot do
  @derive [Poison.Encoder]
  defstruct [:id, :address, :spots]
end 
