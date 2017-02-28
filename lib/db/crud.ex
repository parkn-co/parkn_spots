defmodule ParknSpots.DB.CRUD do
  @doc """
    Inserts a single spot into the collection.
  """
  def create(spot, collection, pool) do
    Mongo.insert_one(:mongo, collection, spot, pool: pool);
  end
  
  @doc """
    Finds all spots from the collection
  """
  def read(collection, pool) do
    Mongo.find(:mongo, collection, %{}, pool: pool)
  end

  @doc """
    Finds single spot based on the ID from the collection.
  """
  def readById(id, collection, pool) do
    Mongo.find(:mongo, collection, %{"_id": id}, limit: 1, pool: pool)
  end
end
