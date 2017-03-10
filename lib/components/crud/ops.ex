defmodule ParknSpots.Components.CRUD.Ops do
  @moduledoc """
    Handles the logic and object transformation that is required to
    interact with the mongo instance.
  """
  import ParknSpots.Components.Utils, only: [to_struct: 3]

  alias ParknSpots.DB.CRUD

  @doc """
    Converts the body to a struct of type, creates it in the collection.
    Returns the inserted_id
  """
  @spec create(map, String.t, DBConnection.Poolboy) :: map
  def create(map, collection, pool) do
    case CRUD.create(map, collection, pool) do
      {:ok, body} ->
        BSON.ObjectId.encode!(body.inserted_id)
      {:error, error} ->
        error
    end
  end

  @doc """
    Reads all data from the collection and converts it to the struct.
    Returns an list.
  """
  @spec read_all(String.t, DBConnection.Poolboy, struct) :: list
  def read_all(collection, pool, type) do
    CRUD.read_all(collection, pool)
    |> Enum.map(fn(map) -> to_struct(map, type, encode_id: true) end)
  end

  @doc """
    Decodes the ID to a BSON ObjectId, finds it in the db,
    converts it to the struct and returns the object.
    If not found, returns an empty map.
  """
  @spec read_by_id(String.t,  String.t, DBConnection.Poolboy, struct) :: map
  def read_by_id(id, collection, pool, type) do
    BSON.ObjectId.decode!(id)
    |> CRUD.read_by_id(collection, pool)
    |> Enum.at(0)
    |> case do
      0 -> %{}
      val -> to_struct(val, type, encode_id: true)
    end
  end

  @doc """
    Decodes the ID to a BSON ObjectId, and updates it to the map provided..
    Returns the object deleted.
    If not found, returns an empty map.
  """
  @spec update_by_id(map, String.t,  String.t, DBConnection.Poolboy, struct) :: map
  def update_by_id(map, id, collection, pool, type) do
    BSON.ObjectId.decode!(id)
    |> CRUD.update_by_id(map, collection, pool)
    |> handle_mongo_result(type)
  end

  @doc """
    Decodes the ID to a BSON ObjectId, and deletes.
    Returns the object deleted.
    If not found, returns an empty map.
  """
  @spec delete_by_id(String.t,  String.t, DBConnection.Poolboy, struct) :: map
  def delete_by_id(id, collection, pool, type) do
    BSON.ObjectId.decode!(id) 
    |> CRUD.delete_by_id(collection, pool)
    |> handle_mongo_result(type)
  end

  defp handle_mongo_result(value, type) do
    case value do
      {:ok, value} ->
        if value == nil,
          do: %{},
          else: to_struct(value, type, encode_id: true)
      {:error, error} ->
        error
    end
  end
end
