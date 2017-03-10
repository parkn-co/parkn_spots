defmodule ParknSpots.Components.Properties.Controller do
  import ParknSpots.Components.Utils, only: :functions

  alias ParknSpots.Components.CRUD.Ops, as: CrudOps
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
  def create(conn, map) do
    addressId = create_address(Map.get(map, "address"))
    spotIds = create_spots(Map.get(map, "spots"))

    case CrudOps.create(%{address: addressId, spots: spotIds}, @propertiesCollection, @pool) do
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
  def read_all(conn) do
    CrudOps.read_all(@propertiesCollection, @pool, @property)
    |> Enum.map(fn(property) ->
      normalize_property(property)
    end)
    |> send(conn, 200)
  end

  @doc """
    Reads a single object from the collection and converts it to a Property struct.
    Returns a response.
  """
  def read_by_id(conn, id) do
    case CrudOps.read_by_id(id, @propertiesCollection, @pool, @property) do
      map when map == %{} -> send(%{}, conn, 404)
      property ->
        send(normalize_property(property), conn, 200)
    end
  end

  @doc """
    Updates a single object from the collection and converts it to a Property struct.
    Returns a response.
  """
  def update_by_id(conn, id, map) do
    %Property{address: %{"_id" => addressId}, spots: spots} = to_struct(map, @property)
    errors = case CrudOps.update_by_id(map[:address], addressId, @addressesCollection, @pool, @address) do
      %Mongo.Error{message: message} -> [%{message: message}]
      _ -> []
    end

    errors ++ Enum.map(spots, fn(spot) ->
      case CrudOps.update_by_id(spot, spot["_id"], @spotsCollection, @pool, @spot) do
        %Mongo.Error{message: message} -> %{message: message}
        _ -> nil
      end
    end)

    if Enum.count(errors) > 0 do
      send(%{}, conn, 200)
    else
      send(errors, conn, 500)
    end
  end

  # Address helpers
  defp create_address(address) when is_map(address) do
      CrudOps.create(address, @addressesCollection, @pool)
      |> case do
        %{inserted_id: id} -> id
        error -> error
      end
  end
  defp create_address(_address), do: %{message: "Cannot create address, not a map"}

  defp update_address(id, address) when is_bitstring(id) and is_map(address) do
    case CrudOps.update_by_id(address, id, @addressesCollection, @pool, @address) do
        %Mongo.Error{message: message} -> %{message: message}
        _ -> nil
    end
  end
  defp update_address(_id, _address), do: %{message: "Cannot update address, param"}

  #spot helpters
  defp create_spots(spots) when is_list(spots) do
    Enum.map(spots, fn(spot) ->
      case CrudOps.create(spot, @spotsCollection, @pool) do
        %{inserted_id: id} -> id
        error -> error
      end
    end)
  end
  defp create_spots(_spots),
  do: %{message: "Cannot create spot, invalid param"}

  defp update_spots(ids, spots) when is_list(ids) and is_list(spots) do

  end
  defp update_spots(ids, spots),
  do: %{message: "Cannot update spots, invalid param"}

  defp normalize_property(%Property{address: addressId, spots: spotIds} = property)
  when is_integer(addressId) and is_list(spotIds) do
      address =
        CrudOps.read_by_id(addressId, @addressesCollection, @pool, @address)
      spots = Enum.map(spotIds, fn(spotId) ->
        CrudOps.read_by_id(spotId, @spotsCollection, @pool, @spot)
      end)
      %Property{property | address: address, spots: spots}
  end
  defp normalize_property(_proerty),
  do: %{message: "Cannot normalize property, invalid param"}

  defp clean_property(addressId, spotIds)
  when is_integer(addressId) and is_list(spotIds) do
    CrudOps.delete_by_id(addressId, @addressesCollection, @pool, @address)
    Enum.each spotIds, fn(spotId) ->
        CrudOps.delete_by_id(spotId, @spotsCollection, @pool, @spot)
      end
  end
  defp clean_property(_addressId, _spotIds),
  do: %{message: "Cannot clean property, invalid param"}
end
