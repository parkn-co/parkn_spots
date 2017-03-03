defmodule ParknSpots.Components.Properties.Route do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Components.Properties.Controller, as: PropertiesController

  post "/", do: PropertiesController.create conn
  get "/", do: PropertiesController.readAll conn
  get "/:id", do: PropertiesController.readById conn, id
end
