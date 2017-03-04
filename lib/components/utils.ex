defmodule ParknSpots.Components.Utils do
  import Plug.Conn

  @doc """
    Takes a body, connection and status and sets a response with JSON
    content type. Will encode the body to a JSON object.
  """
  def send(body, conn, status) do
    put_resp_content_type(conn, "application/json")
      |> send_resp(
        Plug.Conn.Status.code(status),
        Poison.encode!(%{status: status, payload: body})
      )
  end

  @doc """
    Takes a value and a connection.
    If value is an empty map or Mongo.Error, send error response,
    else send valid response.
  """
  def handle_result(value, conn) do
    case value do
      %Mongo.Error{message: message} ->
        send(%{error: message}, conn, 500)
      map when map == %{} ->
        send(map, conn, 404)
      map ->
        send(map, conn, 200)
    end
  end

  @doc """
  """
  def convert_and_validate(map, type) do
    to_struct(map, type)
    |> Vex.valid?
  end


  @doc """
    Transform a given struct to an object, with the given attributes.
    https://groups.google.com/forum/#!msg/elixir-lang-talk/6geXOLUeIpI/L9einu4EEAAJ

    Provides option to convert key "_id" of type BSON.ObjectId to string
  """
  def to_struct(attrs, kind, opts \\ []) do
    struct = struct(kind)
    
    if attrs == nil or Enum.count(attrs) == 0 do
      struct
    else
      Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
        case Map.fetch(attrs, Atom.to_string(k)) do
          {:ok, v} ->
            cond do
              opts[:encode_id] ->
                %{acc | k => (if (k == :_id), do: BSON.ObjectId.encode!(v), else: v)}
              opts[:decode_id] ->
                %{acc | k => (if (k == :_id), do: BSON.ObjectId.decode!(v), else: v)}
              true -> 
                %{acc | k => v}
            end
          :error -> acc
        end
      end
    end
  end
end
