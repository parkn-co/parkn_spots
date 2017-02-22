defmodule ParknSpots.Models.Spots do
  @collection "spots"
  @pool DBConnection.Poolboy

  @doc """
    Inserts a single spot into the collection.
  """
  def create(spot) do
    Mongo.insert_one(:mongo, @collection, spot, pool: @pool);
  end
  
  @doc """
    Finds single spot based on the ID from the collection.
  """
  def findById(id) do
    Mongo.find(:mongo, @collection, %{"_id": id}, limit: 1, pool: @pool)
  end
end
