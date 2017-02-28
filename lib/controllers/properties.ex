defmodule ParknSpots.Controllers.Properties do
  import ParknSpots.Utils, only: :functions

  alias ParknSpots.DB.CRUD
  alias ParknSpots.Structs.Address
  alias ParknSpots.Structs.Spot
  alias ParknSpots.Structs.Property

  @properties "properties"
  @addresses "addresses"
  @spots "spots"
  @pool DBConnection.Poolboy

  @doc """
    Takes a connection.
    Converts the body to a Property struct, creates it in the collection,
    and returns a response.
  """
  def create(conn) do
    addressId = Map.get(conn.body_params, "address")
    |> to_struct(Address)
    |> createAddress(conn)

    spots = Map.get(conn.body_params, "spots")
    |> Enum.map(fn(spotMap) ->
      to_struct(spotMap, Spot)
    end)

    IO.inspect addressId
    IO.inspect spots

    case CRUD.create(conn.body_params, @properties, @pool) do
      {:ok, body} ->
        send(%{id: BSON.ObjectId.encode!(body.inserted_id)}, conn, 200)
      {:error, _error} -> send(%{status: 500, message: "Error"}, conn, 500)
    end
  end

  @doc """
    Takes a connection
    Reads all data from the collection and converts it to a Property struct
    and returns a response.
  """
  def readAll(conn) do
    CRUD.read(@properties, @pool)
    |> Enum.map(fn(spotMap) -> to_struct(spotMap, Property, encode_id: true) end)
    |> send(conn, 200)
  end

  @doc """
    Takes a connection, and numeric ID.
    Decodes the ID to a BSON ObjectId, finds it in the db,
    converts it to a Property struct and returns a response.
  """
  def readById(conn, id) do
    value = BSON.ObjectId.decode!(id)
    |> CRUD.readById(@properties, @pool)
    |> Enum.at(0)
    |> case do
      0 -> nil
      val -> val
    end

    if value == nil do
      send(%{}, conn, 200)
    else
      to_struct(value, Property, encode_id: true) |> send(conn, 200)
    end
  end

  # TODO FIX CRUD CREATE
  defp createAddress(address, conn) do 
    case Vex.valid?(address) do
      true ->
        case CRUD.create(Map.get(conn.body_params, "address"), @addresses, @pool) do
          {:ok, body} ->
            BSON.ObjectId.encode!(body.inserted_id)
          {:error, error} -> error
        end
      false -> ""
    end
  end
end
