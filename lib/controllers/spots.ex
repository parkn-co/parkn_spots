defmodule ParknSpots.Controllers.Spots do
  import ParknSpots.Controller

  alias ParknSpots.Models.Spots, as: Spots
  alias ParknSpots.Models.Spot, as: Spot

  def create(conn) do
    IO.inspect conn.body_params
    convertToSpotWithoutId(conn.body_params)
      |> send(conn, 200)
  end

  def findById(conn, id) do
    BSON.ObjectId.decode!(id)
      |> Spots.findById
      |> Enum.map(fn(spot) -> convertToSpot(spot) end)
      |> send(conn, 200)
  end

  defp convertToSpotWithoutId(%{"address" => address, "spots" => spots}) do
      %Spot{id: nil, address: address, spots: spots}
  end

  defp convertToSpot(%{"_id" => id, "address" => address, "spots" => spots}) do
      %Spot{id: BSON.ObjectId.encode!(id), address: address, spots: spots}
  end
end
