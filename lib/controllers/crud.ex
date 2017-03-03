defmodule ParknSpots.Controllers.CRUD do
  import ParknSpots.Utils, only: :functions

  alias ParknSpots.DB.CRUD

  @doc """
    Takes a connection.
    Converts the body to a struct of type, creates it in the collection.
    Returns the inserted_id
  """
  @spec create(Plug.Conn, String.t, DBConnection.Poolboy) :: Plug.Conn
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
  @spec read_all(Plug.Conn, String.t, DBConnection.Poolboy, struct) :: Plug.Conn
  def read_all(conn, connection, pool, type) do
    CRUD.read_all(connection, pool)
    |> Enum.map(fn(map) -> to_struct(map, type, encode_id: true) end)
    |> send(conn, 200)
  end

  @doc """
    Takes a connection, and numeric ID.
    Decodes the ID to a BSON ObjectId, finds it in the db,
    converts it to a Property struct and returns a response.
  """
  @spec read_by_id(Plug.Conn, String.t,  String.t, DBConnection.Poolboy, struct) :: Plug.Conn
  def read_by_id(conn, id, collection, pool, type) do
    BSON.ObjectId.decode!(id)
    |> CRUD.read_by_id(collection, pool)
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
  @spec update_by_id(Plug.Conn, map, String.t,  String.t, DBConnection.Poolboy, struct) :: Plug.Conn
  def update_by_id(conn, map, id, collection, pool, type) do
    BSON.ObjectId.decode!(id)
    |> CRUD.update_by_id(map, collection, pool)
    |> handle_result(conn, type)
  end

  @doc """
    Takes a connection, and numeric ID.
    Decodes the ID to a BSON ObjectId, deletes.
  """
  @spec delete_by_id(Plug.Conn, String.t,  String.t, DBConnection.Poolboy, struct) :: Plug.Conn
  def delete_by_id(conn, id, collection, pool, type) do
    BSON.ObjectId.decode!(id) 
    |> CRUD.delete_by_id(collection, pool)
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
