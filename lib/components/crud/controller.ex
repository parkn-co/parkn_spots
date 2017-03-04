defmodule ParknSpots.Components.CRUD.Controller do
  @moduledoc """
    Takes the output from CRUD.Utils and update the response body/headers accordingly.
  """
  import ParknSpots.Components.Utils, only: :functions

  alias ParknSpots.Components.CRUD.Opts, as: CrudOpts 

  @doc """
    Creates object from request body and returns a response with it's new ID.
    If body is of wrong format, returns 415.
  """
  def create(conn, map, struct, collection, pool) do
    if convert_and_validate(map, struct) do
      CrudOpts.create(map, collection, pool) 
      |> handle_result(conn)
    else
      send(%{}, conn, 415)
    end
  end

  @doc """
    Reads all values.
    If collection is empty, returns empty array.
  """
  def read_all(conn, struct, collection, pool) do
    send(CrudOpts.read_all(collection, pool, struct), conn, 200)
  end

  @doc """
    Returns for object with the provided ID.
    If not found returns an empty object.
  """
  def read_by_id(conn, id, struct, collection, pool) do
    CrudOpts.read_by_id(id, collection, pool, struct)
    |> handle_result(conn)
  end

  @doc """
    Finds the object, and updates it the provided map.
    If body is of wrong format, returns 415.
    If not found, returns an empty map.
  """
  def update_by_id(conn, id, map, struct, collection, pool) do
    if convert_and_validate(map, struct) do
      Map.drop(map, ["_id"])
      |> CrudOpts.update_by_id(id, collection, pool, struct)
      |> handle_result(conn)
    else
      send(%{}, conn, 415)
    end
  end

  @doc """
    Finds the object, and deletes it.
    If not found, returns an empty map.
  """
  def delete_by_id(conn, id, struct, collection, pool) do
      CrudOpts.delete_by_id(id, collection, pool, struct)
      |> handle_result(conn)
  end
end
