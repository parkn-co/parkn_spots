defmodule ParknSpots.Controller do
  import Plug.Conn

  def send(body, conn, status) do
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(Plug.Conn.Status.code(status), Poison.encode!(body))
  end
end
