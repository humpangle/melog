defmodule MelogWeb.UserResolver do
  @moduledoc """
  A resolver for the user schema
  """
  alias Melog.Accounts
  alias Melog.Accounts.User
  alias MelogWeb.ResolversUtil



  @spec user(any, %{user: Accounts.get_user_by_params}, any) ::
    {:ok, %User{}} | {:error, message: String.t}
  def user(_root, %{user: get_user_params} = _args, _info) do
    case Accounts.get_user_by(get_user_params) do
      %User{} = user -> {:ok, user}
      nil -> {:error, message: "User does not exist."}
    end
  end

  @spec users(any, any, any) :: {:ok, [%User{}]}
  def users(_root, _args, _info) do
    {:ok, Accounts.list_users()}
  end

  @spec create_user(any, %{user: User.registration_params}, any) ::
    {:ok, %User{}} | {:error, message: String.t}
  def create_user(_root, %{user: user_params} = _args, _info) do
    case Accounts.create_user(user_params) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {
          :error,
          message: ResolversUtil.changeset_errors_to_string(changeset)
        }
      _error -> {:error, message: "Unknown error while creating user."}
    end
  end

  @spec login(any, %{user: %{email: String.t, password: String.t}}, any) ::
    {:ok, %User{}} | {:error, message: String.t}
  def login(_root, %{user: login_params}, _info) do
    with {:ok, user} <- Accounts.authenticate_user(login_params),
         {:ok, jwt, _} <- MelogWeb.UserSerializer.encode_and_sign(user, %{}) do
      {:ok, Map.put(user, :jwt, jwt)}
    else
      _ -> {:error, message: "Invalid email or password"}
    end
  end

  def is_current_user(%User{} = user) do

  end
end