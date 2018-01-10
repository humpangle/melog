defmodule MelogWeb.UserResolver do
  @moduledoc """
  A resolver for the user schema
  """
  alias Melog.Accounts
  alias Melog.Accounts.User
  alias MelogWeb.ResolversUtil

  @spec user(any, %{user: Accounts.get_user_by_params()}, any) ::
          {:ok, %User{}} | {:error, message: String.t()}
  def user(_root, %{user: get_user_params} = _args, _info) do
    case Accounts.get_user_by(get_user_params) do
      %User{} = user -> {:ok, user}
      nil -> {:error, message: "User does not exist."}
    end
  end

  @unauthorized "Unauthorized"

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
          document_name: :create_user
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
          document_name: :login
        })
      }
    else
      _ -> {:error, message: "Invalid email or password"}
    end
  end

  @doc """
  Only an authenticated user or newly created user can query her own email.
  """
  def email(user1, _, %{context: %{current_user: user2}} = context) do
    %Absinthe.Blueprint.Document.Field{
      name: document_name
    } = Enum.at(context.path, 1)

    cond do
      document_name == "createUser" -> email(user1)
      is_same_user(user1, user2) -> email(user1)
      true -> {:error, message: @unauthorized}
    end
  end

  def email(%{document_name: :create_user} = user, _, _) do
    email(user)
  end

  def email(%{document_name: :login} = user, _, _) do
    email(user)
  end

  def email(_, _, _) do
    {:error, message: @unauthorized}
  end

  defp email(%{email: email}) do
    {:ok, email}
  end

  @spec is_same_user(%{id: String.t(), email: String.t()}, %{id: String.t(), email: String.t()}) ::
          boolean
  defp is_same_user(%{id: id1, email: email1}, %{id: id2, email: email2}) do
    id1 == id2 && email1 == email2
  end

  defp is_same_user(_, _) do
    false
  end
end
