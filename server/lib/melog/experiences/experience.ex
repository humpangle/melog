defmodule Melog.Experiences.Experience do
  use Ecto.Schema
  import Ecto.Changeset
  alias Melog.Experiences.{Experience, Field}
  alias Melog.Accounts.User

  @timestamps_opts [
    type: Timex.Ecto.DateTime,
    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}
  ]

  schema "experiences" do
    field(:intro, :string)
    field(:title, :string)
    belongs_to(:user, User)
    has_many(:fields, Field)
    timestamps()
  end

  @doc false
  def changeset(%Experience{} = experience, attrs) do
    experience
    |> cast(attrs, [:title, :intro, :user_id])
    |> validate_required([:title, :user_id])
    |> validate_length(:title, min: 2)
    |> unique_constraint(:title, name: :experiences_title_user_id_index)
  end
end
