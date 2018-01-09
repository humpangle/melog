defmodule Melog.Experiences.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Melog.Experiences.Comment


  schema "comments" do
    field :text, :string
    field :experience_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
