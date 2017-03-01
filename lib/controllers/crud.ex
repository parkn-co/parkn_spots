defmodule ParknSpots.Controllers.CRUD do
  import ParknSpots.Utils, only: :functions

  alias ParknSpots.DB.CRUD

  @doc """
    Takes a connection.
    Converts the body to a struct of type, creates it in the collection.
    Returns the inserted_id
  """
  def create(conn, collection, pool) do
    case CRUD.create(conn.body_params, collection, pool) do
      {:ok, body} ->
        send(%{insertedId: BSON.ObjectId.encode!(body.inserted_id)}, conn, 201)
      {:error, error} ->
        send(error, conn, 500)
    end
  end

  @doc """
    Takes a connection
    Reads all data from the collection and converts it to a Address struct.
  """
  def read_all(conn, connection, pool, type) do
    CRUD.read(connection, pool)
    |> Enum.map(fn(map) -> to_struct(map, type, encode_id: true) end)
    |> send(conn, 200)
  end

  @doc """
    Takes a connection, and numeric ID.
    Decodes the ID to a BSON ObjectId, finds it in the db,
    converts it to a Property struct and returns a response.
  """
  def read_by_id(conn, id, collection, pool, type) do
    BSON.ObjectId.decode!(id)
    |> CRUD.readById(collection, pool)
    |> Enum.at(0)
    |> case do
      0 -> send(%{}, conn, 404)
      val -> to_struct(val, type, encode_id: true) |> send(conn, 200)
    end
  end

  @doc """
    Takes a connection, and numeric ID.
    Decodes the ID to a BSON ObjectId, updates it in the db.
  """
  def update_by_id(conn, map, id, collection, pool, type) do
    BSON.ObjectId.decode!(id)
    |> CRUD.updateById(map, collection, pool)
    |> handle_result(conn, type)
  end

  @doc """
    Takes a connection, and numeric ID.
    Decodes the ID to a BSON ObjectId, deletes.
  """
  def delete_by_id(conn, id, collection, pool, type) do
    BSON.ObjectId.decode!(id) 
    |> CRUD.deleteById(collection, pool)
    |> handle_result(conn, type)
  end

  defp handle_result(value, conn, type) do
    case value do
      {:ok, value} ->
        if value == nil,
          do: send(%{}, conn, 404),
          else: send(to_struct(value, type, encode_id: true) , conn, 200)
      {:error, error} ->
        send(error, conn, 500)
    end
  end
end
