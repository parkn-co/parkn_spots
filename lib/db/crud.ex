defmodule ParknSpots.DB.CRUD do
  @doc """
    Inserts a single spot into the collection.
  """
  @spec create(map, String.t, Poolboy.pool) :: String.t
  def create(spot, collection, pool) do
    Mongo.insert_one(:mongo, collection, spot, pool: pool);
  end
  
  @doc """
    Finds all spots from the collection
  """
  @spec read_all(String.t, Poolboy.pool) :: Mongo.cursor
  def read_all(collection, pool) do
    Mongo.find(:mongo, collection, %{}, pool: pool)
  end

  @doc """
    Finds single spot based on the ID from the collection.
  """
  @spec read_by_id(String.t, String.t, Poolboy.pool) :: Mongo.cursor
  def read_by_id(id, collection, pool) do
    Mongo.find(:mongo, collection, %{"_id": id}, limit: 1, pool: pool)
  end

  @doc """
    Finds single spot based on the ID and updates it from the collection.
  """
  @spec update_by_id(String.t, map, String.t, Poolbooy.pool) :: map
  def update_by_id(id, map, collection, pool) do
    Mongo.find_one_and_update(
      :mongo,
      collection,
      %{"_id" => id},
      %{"$set" => map},
      pool: pool
    )
  end

  @doc """
    Finds single spot based on the ID and deletes it from the collection.
  """
  @spec delete_by_id(String.t, String.t, Poolbooy.pool) :: map
  def delete_by_id(id, collection, pool) do
    Mongo.find_one_and_delete(
      :mongo,
      collection,
      %{"_id": id},
      pool: pool
    )
  end
end
