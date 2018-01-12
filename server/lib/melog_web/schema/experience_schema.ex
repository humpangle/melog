defmodule MelogWeb.ExperienceSchema do
  @moduledoc """
  Schema types for Experience
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Melog.Repo
  alias MelogWeb.ExperienceResolver

  @desc "Create experience input"
  input_object :create_experience_input do
    # if we are calling from a non-web context e.g. in tests, we can specify
    # the token for authentication. In web context, jwt will be taken from
    # headers
    field(:jwt, :string)
    field(:title, non_null(:string))
    field(:intro, :string)
  end

  @desc "An experience a user wishes to keep track of"
  object :experience do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:intro, :string)
    field(:user, :user, resolve: assoc(:user))
    field(:inserted_at, non_null(:iso_datetime))
    field(:updated_at, non_null(:iso_datetime))
  end

  @desc "Various mutations allowed on the experience object"
  object :experience_mutation do
    field :create_experience, type: :experience do
      arg(:experience, non_null(:create_experience_input))

      resolve(&ExperienceResolver.create_experience/3)
    end
  end
end
