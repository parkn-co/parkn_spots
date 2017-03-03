defmodule ParknSpots.Components.Addresses.Controller do
  alias ParknSpots.Components.CRUD
  alias ParknSpots.Structs.Address

  @collection "addresses"
  @pool DBConnection.Poolboy

  @doc """
    Takes a connection.
    Creates an Address and returns it's new ID.
  """
  # @spec create(any, string, any) :: any | no_return
  # def create(conn, collection, pool)

  def create(conn) do
    CRUD.create(conn, @collection, @pool)
  end

  @doc """
    Takes a connection
    Reads all Addresses.
    If collection is empty, returns empty array.
  """
  def read_all(conn) do
    CRUD.read_all(conn, @collection, @pool, Address)
  end

  @doc """
    Takes a connection, and ID.
    Reads for the specific address.
    If not found, returns an empty object.
  """
  def read_by_id(conn, id) do
    CRUD.read_by_id(conn, id, @collection, @pool, Address)
  end

  @doc """
    Takes a connection, struct, and ID.
    Updates the specific address.
  """
  def update_by_id(conn, id) do
    map = Map.drop(conn.body_params, ["_id"])
    CRUD.update_by_id(conn, map, id, @collection, @pool, Address)
  end

  @doc """
    Takes a connection, struct, and ID.
    Deletes the specific address.
  """
  def delete_by_id(conn, id) do
    CRUD.delete_by_id(conn, id, @collection, @pool, Address)
  end
end
