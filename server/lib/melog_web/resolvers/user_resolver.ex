defmodule MelogWeb.UserResolver do
  @moduledoc """
  A resolver for the user schema
  """
  alias Melog.Accounts
  alias Melog.Accounts.User
  alias MelogWeb.ResolversUtil

  @unauthorized "Unauthorized"

  @doc """
  Get a single user either by email or id or both.
  """
  @spec user(any, %{user: %{id: nil | String.t() | integer, email: nil | String.t()}}, any) ::
          {:ok, %User{}} | {:error, message: String.t()}
  def user(_root, %{user: get_user_params} = _args, _info) do
    case Accounts.get_user_by(get_user_params) do
      %User{} = user -> {:ok, user}
      nil -> {:error, message: "User does not exist."}
    end
  end

  @doc """
  Get all existing users.
  """
  @spec users(any, any, any) :: {:ok, [%User{}]}
  def users(_root, _args, _info) do
    {:ok, Accounts.list_users()}
  end

  @spec create_user(any, %{user: User.registration_params()}, any) ::
          {:ok, %User{}} | {:error, message: String.t()}
  def create_user(_root, %{user: user_params} = _args, _info) do
    with {:ok, user} <- Accounts.create_user(user_params),
         {:ok, jwt, _} <- MelogWeb.UserSerializer.encode_and_sign(user, %{}) do
      {
        :ok,
        Enum.into(Map.from_struct(user), %{
          jwt: jwt,
          creation_done: true
        })
      }
    else
      {:error, changeset} ->
        {
          :error,
          message: ResolversUtil.changeset_errors_to_string(changeset)
        }

      _ ->
        {:error, message: "Unable to create user"}
    end
  end

  @spec login(any, %{user: %{email: String.t(), password: String.t()}}, any) ::
          {:ok, %User{}} | {:error, message: String.t()}
  def login(_root, %{user: login_params}, _info) do
    with {:ok, user} <- Accounts.authenticate_user(login_params),
         {:ok, jwt, _} <- MelogWeb.UserSerializer.encode_and_sign(user, %{}) do
      {
        :ok,
        Enum.into(Map.from_struct(user), %{
          jwt: jwt,
          login_done: true
        })
      }
    else
      _ -> {:error, message: "Invalid email or password"}
    end
  end

  @doc """
  Only an authenticated user or newly created user can query her own email.
  """
  def email(user1, _, %{context: %{current_user: user2}} = _context) do
    if is_same_user(user1, user2) do
      email(user1)
    else
      {:error, message: @unauthorized}
    end
  end

  def email(%{creation_done: true} = user, _, _) do
    email(user)
  end

  def email(%{login_done: true} = user, _, _) do
    email(user)
  end

  def email(_, _, _) do
    {:error, message: @unauthorized}
  end

  defp email(%{email: email_}) do
    {:ok, email_}
  end

  @spec is_same_user(%{id: String.t(), email: String.t()}, %{id: String.t(), email: String.t()}) ::
          boolean
  defp is_same_user(%{id: id, email: email}, %{id: id, email: email}) do
    true
  end

  defp is_same_user(_, _) do
    false
  end
end
