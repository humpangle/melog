defmodule MelogWeb.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case MelogWeb.UserSerializer.Plug.current_resource(conn) do
      nil ->
        conn
      user ->
        put_private(conn, :absinthe, %{context: %{current_user: user}})
    end
  end
end