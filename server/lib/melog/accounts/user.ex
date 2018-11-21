defmodule Melog.Accounts.User do
  @typedoc """
  The specification for the param map required to create a user.
  """
  @type registration_params :: %{
          email: String.t(),
          password: String.t()
          # username is optional
        }

  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  alias Melog.Accounts.User
  alias Melog.Experiences.Experience

  @timestamps_opts [
    type: Timex.Ecto.DateTime,
    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}
  ]

  @mail_regex ~r/@/

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:username, :string)
    field(:password, :string, virtual: true)
    has_many(:experiences, Experience)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password_hash])
    |> validate_required([:email, :username])
    |> validate_format(:email, @mail_regex)
    |> unique_constraint(:email)
  end

  def registration_changeset(%User{} = user, params \\ %{}) do
    params =
      if params[:username] == nil do
        Map.put(params, :username, params[:email])
      else
        params
      end

    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 3)
    |> hashpw()
  end

  defp hashpw(%Ecto.Changeset{valid?: true} = input_changes) do
    put_change(
      input_changes,
      :password_hash,
      hashpwsalt(input_changes.changes.password)
    )
  end

  defp hashpw(changes) do
    changes
  end
end
