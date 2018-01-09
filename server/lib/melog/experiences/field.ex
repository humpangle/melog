defmodule Melog.Experiences.Field do
  use Ecto.Schema
  import Ecto.Changeset
  alias Melog.Experiences.Field


  schema "fields" do
    field :boolean, :boolean, default: false
    field :date, :date
    field :date_time, :utc_datetime
    field :decimal, :float
    field :multi_text, :string
    field :name, :string
    field :number, :integer
    field :single_text, :string
    field :experience_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Field{} = field, attrs) do
    field
    |> cast(attrs, [:name, :single_text, :multi_text, :date, :date_time, :number, :boolean, :decimal])
    |> validate_required([:name, :single_text, :multi_text, :date, :date_time, :number, :boolean, :decimal])
  end
end
