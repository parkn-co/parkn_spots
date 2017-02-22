defmodule ParknSpots.Routes.Spots do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Controllers.Spots, as: SpotsController

  post "/", do: SpotsController.create conn
  get "/:id", do: SpotsController.findById conn, id
end
