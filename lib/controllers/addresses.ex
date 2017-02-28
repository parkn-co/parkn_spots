defmodule ParknSpots.Controllers.Addresses do
  alias ParknSpots.Controllers.CRUD, as: CrudController
  alias ParknSpots.Structs.Address

  @collection "addresses"
  @pool DBConnection.Poolboy

  @doc """
    Takes a connection.
    Creates an Address and returns it's new ID.
  """
  def create(conn) do
    CrudController.create(conn, @collection, @pool)
  end

  @doc """
    Takes a connection
    Reads all Addresses.
    If collection is empty, returns empty array.
  """
  def readAll(conn) do
    CrudController.readAll(conn, @collection, @pool, Address)
  end

  @doc """
    Takes a connection, and ID.
    Reads for the specific address.
    If not found, returns an empty object.
  """
  def readById(conn, id) do
    CrudController.readById(conn, id, @collection, @pool, Address)
  end
end
