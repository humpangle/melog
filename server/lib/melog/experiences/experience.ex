defmodule Melog.Experiences.Experience do
  use Ecto.Schema
  import Ecto.Changeset
  alias Melog.Experiences.Experience
  alias Melog.Accounts.User

  @timestamps_opts [
    type: Timex.Ecto.DateTime,
    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}
  ]

  schema "experiences" do
    field(:intro, :string)
    field(:title, :string)
    belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(%Experience{} = experience, attrs) do
    experience
    |> cast(attrs, [:title, :intro, :user_id])
    |> validate_required([:title, :user_id])
    |> unique_constraint(:title)
    |> validate_length(:title, min: 2)
  end
end
