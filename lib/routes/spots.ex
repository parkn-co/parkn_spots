defmodule ParknSpots.Routes.Spots do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Controllers.Spots, as: SpotsController

  post "/", do: SpotsController.create conn
  get "/", do: SpotsController.read_all conn
  get "/:id", do: SpotsController.read_by_id conn, id
  put "/:id", do: SpotsController.update_by_id conn, id
  delete "/:id", do: SpotsController.delete_by_id conn, id
end
