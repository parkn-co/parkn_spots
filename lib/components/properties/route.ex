defmodule ParknSpots.Components.Properties.Route do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Components.Properties.Controller, as: PropertiesController

  post "/", do: PropertiesController.create conn, conn.body_params
  get "/", do: PropertiesController.read_all conn
  get "/:id", do: PropertiesController.read_by_id conn, id
  put "/:id", do: PropertiesController.update_by_id conn, id, conn.body_params
end
