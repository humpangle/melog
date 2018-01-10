defmodule MelogWeb.UserSchema do
  @moduledoc """
  Schema types for User
  """

  use Absinthe.Schema.Notation
  alias MelogWeb.UserResolver

  @desc "Create user input"
  input_object :create_user_input do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
    field(:username, :string)
  end

  @desc "Get user input"
  input_object :get_user_input do
    field(:id, :id)
    field(:email, :string)
  end

  @desc "Login user input"
  input_object :login_user_input do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  @desc "A User"
  object :user do
    field(:id, non_null(:id))

    field :email, non_null(:string) do
      resolve(&UserResolver.email/3)
    end

    field(:username, :string)
    field(:inserted_at, non_null(:iso_datetime))
    field(:updated_at, non_null(:iso_datetime))
    field(:jwt, non_null(:string))
  end

  @desc "List of users, may be paginated"
  object :users do
    field(:users, list_of(:user))
  end

  @desc "Queries allowed on the User object"
  object :user_query do
    field :user, type: :user do
      arg(:user, non_null(:get_user_input))

      resolve(&UserResolver.user/3)
    end

    field :users, type: list_of(:user) do
      resolve(&UserResolver.users/3)
    end
  end

  @desc "Mutations allowed on the User object"
  object :user_mutation do
    field :create_user, type: :user do
      arg(:user, non_null(:create_user_input))

      resolve(&UserResolver.create_user/3)
    end

    field :login, type: :user do
      arg(:user, non_null(:login_user_input))

      resolve(&UserResolver.login/3)
    end
  end
end
