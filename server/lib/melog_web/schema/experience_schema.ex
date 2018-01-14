defmodule MelogWeb.ExperienceSchema do
  @moduledoc """
  Schema types for Experience
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Melog.Repo
  alias MelogWeb.ExperienceResolver

  @desc "Create experience input"
  input_object :create_experience_input do
    @desc "if we are calling from a non-web context e.g. in tests, we can
     specify the token for authentication. In web context, jwt will be taken
     from headers"
    field(:jwt, :string)
    field(:title, non_null(:string))
    field(:intro, :string)
  end

  @desc "Get experience input. ID and title are unique fields."
  input_object :get_experience_input do
    field(:id, :id)
    field(:title, :string)

    @desc "For authentication if calling from non web context"
    field(:jwt, :string)
  end

  @desc "Get experiences input."
  input_object :get_experiences_input do
    @desc "For authentication if calling from non web context"
    field(:jwt, :string)
  end

  @desc "An experience a user wishes to keep track of"
  object :experience do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:intro, :string)

    @desc "The creator/owner of this experience"
    field(:user, :user, resolve: assoc(:user))

    @desc "Contain different data about the experience"
    field(:fields, list_of(:field), resolve: assoc(:fields))

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

  @desc "Queries allowed on the experience object"
  object :experience_query do
    @desc "Get an experience by id or title or both"
    field :experience, type: :experience do
      arg(:experience, non_null(:get_experience_input))

      resolve(&ExperienceResolver.experience/3)
    end

    @desc "Get a list of experiences for a user"
    field :experiences, type: list_of(:experience) do
      arg(:experience, :get_experiences_input)

      resolve(&ExperienceResolver.experiences/3)
    end
  end
end
