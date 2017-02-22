defmodule ParknSpots.Controllers.Spots do
  import ParknSpots.Controller

  alias ParknSpots.Structs.Spot, as: Spot
  alias ParknSpots.Models.Spots, as: Spots

  @doc """
    Takes a connection.
    Converts the body to a Spot struct, creates it in the collection,
    and returns a response.
  """
  def create(conn) do
    case Spots.create(conn.body_params) do
      {:ok, body} ->
        send(%{id: BSON.ObjectId.encode!(body.inserted_id)}, conn, 200)
      {:error, _error} -> send(%{status: 500, message: "Error"}, conn, 500)
    end
  end

  @doc """
    Takes a connection, and numeric ID.
    Decodes the ID to a BSON ObjectId, finds it in the db,
    converts it to a Spot struct and retursn a response.
  """
  def findById(conn, id) do
    BSON.ObjectId.decode!(id)
      |> Spots.findById
      |> Enum.map(fn(spotMap) -> mapToSpot(spotMap) end)
      |> send(conn, 200)
  end

  defp mapToSpot(%{"_id" => id, "address" => address, "spots" => spots}) do
      %Spot{id: BSON.ObjectId.encode!(id), address: address, spots: spots}
  end
end
