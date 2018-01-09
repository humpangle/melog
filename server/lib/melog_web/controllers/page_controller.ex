defmodule MelogWeb.PageController do
  use MelogWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
