defmodule ParknSpots.Router do
  use Plug.Router
  alias ParknSpots.Components

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug Plug.Logger, log: :debug
  plug Plug.Parsers, parsers: [:json],
                     json_decoder: Poison

  plug :match
  plug :dispatch

  forward "/addresses", to: Components.Addresses.Route
  forward "/spots", to: Components.Spots.Route
  forward "/properties", to: Components.Properties.Route

  match _, do:
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(404, %{status: 404, payload: nil})
end

