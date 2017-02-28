defmodule ParknSpots.Router do
  use Plug.Router
  alias ParknSpots.Routes

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug Plug.Logger, log: :debug
  plug Plug.Parsers, parsers: [:json],
                     json_decoder: Poison

  plug :match
  plug :dispatch

  forward "/properties", to: Routes.Properties

  match _, do:
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(404, ~s({"status": 404, "message": "Not Found"}))
end

