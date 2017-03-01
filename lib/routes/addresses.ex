defmodule ParknSpots.Routes.Addresses do
  use Plug.Router

  plug :match
  plug :dispatch

  alias ParknSpots.Controllers.Addresses, as: AddressesController

  post "/", do: AddressesController.create conn
  get "/", do: AddressesController.read_all conn
  get "/:id", do: AddressesController.read_by_id conn, id
  put "/:id", do: AddressesController.update_by_id conn, id
  delete "/:id", do: AddressesController.delete_by_id conn, id
end
