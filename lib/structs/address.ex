defmodule ParknSpots.Structs.Address do
  @derive [Poison.Encoder]
  defstruct [:_id, :street, :city, :state, :country, :zip]

  use Vex.Struct
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :zip, presence: true
end 
