defmodule ParknSpots.Components.Properties.Controller do
  import ParknSpots.Components.Utils, only: :functions

  alias ParknSpots.Components.CRUD.Opts, as: CrudOpts
  alias ParknSpots.Structs.Property

  @addressesCollection "addresses"
  @spotsCollection "spots"
  @propertiesCollection "properties"
  @address ParknSpots.Structs.Address
  @spot ParknSpots.Structs.Spot
  @property ParknSpots.Structs.Property
  @pool DBConnection.Poolboy

  @doc """
    Takes the request body and creates and address, and a list of spots.
    Then creates a property objects with refs to the address and spots
    previously created.
  """
  def create(conn) do
    addressId = create_address(Map.get(conn.body_params, "address"))
    spotIds = create_spots(Map.get(conn.body_params, "spots"))

    case CrudOpts.create(%{address: addressId, spots: spotIds}, @propertiesCollection, @pool) do
        %Mongo.Error{message: message} ->
          clean_property(addressId, spotIds)
          send(%{error: message}, conn, 500)
        inserted_id -> send(%{inserted_id: inserted_id}, conn, 201)
      end
  end

  @doc """
    Reads all data from the collection and converts it to a Property struct.
    Returns a response.
  """
  def readAll(conn) do
    CrudOpts.read_all(@propertiesCollection, @pool, @property)
    |> Enum.map(fn(property) ->
      normalize_property(property)
    end)
    |> send(conn, 200)
  end

  @doc """
    Reads a single object from the collection and converts it to a Property struct.
    Returns a response.
  """
  def readById(conn, id) do
    case CrudOpts.read_by_id(id, @propertiesCollection, @pool, @property) do
      map when map == %{} -> send(%{}, conn, 404)
      property ->
        send(normalize_property(property), conn, 200)
    end
  end

  defp normalize_property(%Property{address: addressId, spots: spotIds} = property) do
      address = CrudOpts.read_by_id(addressId, @addressesCollection, @pool, @address)
      spots = Enum.map(spotIds, fn(spotId) ->
        CrudOpts.read_by_id(spotId, @spotsCollection, @pool, @spot)
      end)
      %Property{property | address: address, spots: spots}
  end

  defp create_address(address) when is_map(address) do
      CrudOpts.create(address, @addressesCollection, @pool)
      |> case do
        %{inserted_id: id} -> id
        error -> error
      end
  end

  defp create_spots(spots) when is_list(spots) do
    Enum.map(spots, fn(spot) ->
      case CrudOpts.create(spot, @spotsCollection, @pool) do
        %{inserted_id: id} -> id
        error -> error
      end
    end)
  end

  defp clean_property(addressId, spotIds) do
    CrudOpts.delete_by_id(addressId, @addressesCollection, @pool, @address)
    Enum.each spotIds, fn(spotId) ->
        CrudOpts.delete_by_id(spotId, @spotsCollection, @pool, @spot)
      end
  end
end
