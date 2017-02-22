defmodule ParknSpots do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    port = Application.get_env(:parkn_spots, :cowboy_port, 4004)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, ParknSpots.Router, [], port: port),
      worker(Mongo, [[name: :mongo, database: "parknspots", pool: DBConnection.Poolboy]])
    ]

    opts = [strategy: :one_for_one, name: ParknSpots.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
