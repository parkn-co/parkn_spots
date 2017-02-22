defmodule ParknSpots.Models.Spots do
  @collection "spots"
  @pool DBConnection.Poolboy

  def create() do

  end
  
  def findById(id) do
    Mongo.find(:mongo, @collection, %{"_id": id}, limit: 1, pool: @pool)
  end
end
