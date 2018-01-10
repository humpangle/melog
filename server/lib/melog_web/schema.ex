defmodule MelogWeb.Schema do
  use Absinthe.Schema

  import_types MelogWeb.Schema.Types
  import_types MelogWeb.UserSchema

  query do
    import_fields :user_query
  end

  mutation do
    import_fields :user_mutation
  end
end