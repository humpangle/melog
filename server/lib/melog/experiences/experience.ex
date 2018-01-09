defmodule Melog.Experiences.Experience do
  use Ecto.Schema
  import Ecto.Changeset
  alias Melog.Experiences.Experience

  @timestamps_opts [
    type: Timex.Ecto.DateTime,
    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}
  ]

  schema "experiences" do
    field :intro, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Experience{} = experience, attrs) do
    experience
    |> cast(attrs, [:title, :intro])
    |> validate_required([:title, :intro])
  end
end
