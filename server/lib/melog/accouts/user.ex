defmodule Melog.Accouts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Melog.Accouts.User


  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
  end
end
