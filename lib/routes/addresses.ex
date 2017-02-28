defmodule ParknSpots.Routes.Addresses do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Controllers.Addresses, as: AddressesController

  post "/", do: AddressesController.create conn
  get "/", do: AddressesController.readAll conn
  get "/:id", do: AddressesController.readById conn, id
end
