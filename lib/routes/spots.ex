defmodule ParknSpots.Routes.Spots do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Controllers.Spots, as: SpotsController

  post "/", do: SpotsController.create conn
  get "/", do: SpotsController.readAll conn
  get "/:id", do: SpotsController.readById conn, id
end
