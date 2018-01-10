defmodule Melog.Accounts do
  @moduledoc """
  The Accouts context.
  """

  import Ecto.Query, warn: false
  import Comeonin.Bcrypt, only: [{:dummy_checkpw, 0}, {:checkpw, 2}]

  alias Melog.Repo
  alias Melog.Accounts.User

  @typedoc """
  The type of the input used to get a single User object. One of "id" and
  "email" is required
  """
  @type get_user_by_params :: %{
          id: nil | String.t() | integer,
          email: nil | String.t()
        }

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user by id or email.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user_by(%{id: 123})
      %User{}

      iex> get_user_by(%{email: "me@you.com"})
      %User{}

      iex> get_user_by(%{id: 123, email: "me@you.com"})
      %User{}

      iex> get_user_by(456)
      nil

  """
  @spec get_user_by(get_user_by_params) :: %User{} | nil
  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  @doc """
  Creates a user. If username is not provided, defaults to email.

  ## Examples

      iex> create_user(%{
            email: "email@user.com",
            password_plain: "pain password"
          })
      {:ok, %User{
        email: "email@user.com",
        id: 1,
        inserted_at: #DateTime<2018-01-10 06:40:37Z>,
        password_hash: "$2b$12$QAxbALli/QfiDaEazEtDsebsqgPowmaOwlHG6lOMP2cpDONJkVBdS",
        updated_at: #DateTime<2018-01-10 06:40:37Z>,
        username: "email@user.com"
      }}

      iex> create_user(%{
            email: "email@user.com",
            password_plain: "pain password",
            username: "cool user"
          })
      {:ok, %User{
        email: "email@user.com",
        id: 1,
        inserted_at: #DateTime<2018-01-10 06:40:37Z>,
        password_hash: "$2b$12$QAxbALli/QfiDaEazEtDsebsqgPowmaOwlHG6lOMP2cpDONJkVBdS",
        updated_at: #DateTime<2018-01-10 06:40:37Z>,
        username: "cool user"
      }}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(User.registration_params()) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Get a user, confirm if a user's email and password are correct and return the
  user
  """
  @spec authenticate_user(%{email: String.t(), password: String.t()}) :: {:ok, %User{}} | :error
  def authenticate_user(%{email: email} = params) do
    case get_user_by(%{email: email}) do
      nil ->
        dummy_checkpw()
        :error

      user ->
        if confirm_password(params, user), do: {:ok, user}, else: :error
    end
  end

  defp confirm_password(%{password: password}, user) do
    confirm_password(password, user)
  end

  defp confirm_password(password, %User{password_hash: password_hash}) do
    checkpw(password, password_hash)
  end
end
