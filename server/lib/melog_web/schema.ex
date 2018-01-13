defmodule MelogWeb.Schema do
  use Absinthe.Schema

  import_types(MelogWeb.Schema.Types)
  import_types(MelogWeb.UserSchema)
  import_types(MelogWeb.ExperienceSchema)

  query do
    import_fields(:user_query)
    import_fields(:experience_query)
  end

  mutation do
    import_fields(:user_mutation)
    import_fields(:experience_mutation)
  end
end
