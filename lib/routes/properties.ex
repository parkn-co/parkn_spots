defmodule ParknSpots.Routes.Properties do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Controllers.Properties, as: PropertiesController

  post "/", do: PropertiesController.create conn
  get "/", do: PropertiesController.readAll conn
  get "/:id", do: PropertiesController.readById conn, id
end
