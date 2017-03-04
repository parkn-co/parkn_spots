defmodule ParknSpots.Components.Spots.Route do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Components.CRUD.Controller, as: CrudController

  @struct ParknSpots.Structs.Spot
  @collection "spots"
  @pool DBConnection.Poolboy

  post "/",
    do: CrudController.create(conn, conn.body_params, @struct, @collection, @pool)
  get "/",
    do: CrudController.read_all(conn, @struct, @collection, @pool)
  get "/:id",
    do: CrudController.read_by_id(conn, id, @struct, @collection, @pool)
  put "/:id",
    do: CrudController.update_by_id(conn, id, conn.body_params, @struct, @collection, @pool)
  delete "/:id",
    do: CrudController.delete_by_id(conn, id, @struct, @collection, @pool)
end
