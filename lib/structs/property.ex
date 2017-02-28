defmodule ParknSpots.Structs.Property do
  @derive [Poison.Encoder]
  defstruct [:_id, :address, :spots]

  use Vex.Struct
  validates :address, presence: true
  validates :spots, presence: true
end 
