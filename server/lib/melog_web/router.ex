defmodule MelogWeb.Router do
  use MelogWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.Pipeline,
      module: MelogWeb.UserSerializer,
      error_handler: MelogWeb.UserSerializer
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug MelogWeb.Context
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug,
      schema: MelogWeb.Schema,
      context: %{pubsub: MelogWeb.Endpoint}

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: MelogWeb.Schema,
      interface: :simple,
      context: %{pubsub: MelogWeb.Endpoint}
  end
end
