defmodule MelogWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(MelogWeb.Schema.Types)
  import_types(MelogWeb.UserSchema)
  import_types(MelogWeb.ExperienceSchema)
  import_types(MelogWeb.FieldSchema)

  query do
    import_fields(:user_query)
    import_fields(:experience_query)
  end

  mutation do
    import_fields(:user_mutation)
    import_fields(:experience_mutation)
    import_fields(:field_mutation)
  end
end
