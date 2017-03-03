defmodule ParknSpots.Components.Addresses.Controller do
  import ParknSpots.Components.Utils, only: [send: 3, handle_result: 2]

  alias ParknSpots.Components.CRUD
  alias ParknSpots.Structs.Address

  @collection "addresses"
  @pool DBConnection.Poolboy

  @doc """
    Takes a connection.
    Creates an Address and returns it's new ID.
  """
  def create(conn) do
    CRUD.create(conn.body_params, @collection, @pool) 
    |> handle_result(conn)
  end

  @doc """
    Takes a connection
    Reads all Addresses.
    If collection is empty, returns empty array.
  """
  def read_all(conn) do
    send(CRUD.read_all(@collection, @pool, Address), conn, 200)
  end

  @doc """
    Takes a connection, and ID.
    Reads for the specific address.
    If not found, returns an empty object.
  """
  def read_by_id(conn, id) do
    CRUD.read_by_id(id, @collection, @pool, Address) 
    |> handle_result(conn)
  end

  @doc """
    Takes a connection, struct, and ID.
    Updates the specific address.
  """
  def update_by_id(conn, id) do
    Map.drop(conn.body_params, ["_id"])
    |> CRUD.update_by_id(id, @collection, @pool, Address)
    |> handle_result(conn)
  end

  @doc """
    Takes a connection, struct, and ID.
    Deletes the specific address.
  """
  def delete_by_id(conn, id) do
    CRUD.delete_by_id(id, @collection, @pool, Address)
    |> handle_result(conn)
  end
end
