defmodule ParknSpots.Controllers.CRUD do
  import ParknSpots.Utils, only: :functions

  alias ParknSpots.DB.CRUD

  @doc """
    Takes a connection.
    Converts the body to an Address struct, creates it in the collection,
    and returns a response.
  """
  def create(conn, collection, pool) do
    case CRUD.create(conn.body_params, collection, pool) do
      {:ok, body} ->
        send(%{id: BSON.ObjectId.encode!(body.inserted_id)}, conn, 200)
      {:error, _error} -> send(%{status: 500, message: "Error"}, conn, 500)
    end
  end

  @doc """
    Takes a connection
    Reads all data from the collection and converts it to a Address struct
    and returns a response.
  """
  def readAll(conn, connection, pool, type) do
    CRUD.read(connection, pool)
    |> Enum.map(fn(spotMap) -> to_struct(spotMap, type, encode_id: true) end)
    |> send(conn, 200)
  end

  @doc """
    Takes a connection, and numeric ID.
    Decodes the ID to a BSON ObjectId, finds it in the db,
    converts it to a Property struct and returns a response.
  """
  def readById(conn, id, collection, pool, type) do
    value = BSON.ObjectId.decode!(id)
    |> CRUD.readById(collection, pool)
    |> Enum.at(0)
    |> case do
      0 -> nil
      val -> val
    end

    if value == nil do
      send(%{}, conn, 200)
    else
      to_struct(value, type, encode_id: true) |> send(conn, 200)
    end
  end
end
