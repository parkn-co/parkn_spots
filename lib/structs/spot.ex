defmodule ParknSpots.Structs.Spot do
  @derive [Poison.Encoder]
  defstruct [:_id, :isReserved, :isReservedBy]

  use Vex.Struct
  validates :isReserved, presence: true
  validates :isReservedBy, presence: true
end 
