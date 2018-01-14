defmodule Melog.Experiences.Field do
  use Ecto.Schema
  import Ecto.Changeset
  alias Melog.Experiences.{Field, Experience}

  @timestamps_opts [
    type: Timex.Ecto.DateTime,
    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}
  ]

  schema "fields" do
    field(:name, :string)
    field(:field_type, FieldTypeEnum)
    field(:boolean, :boolean)
    field(:number, :integer)
    field(:decimal, :float)
    field(:single_text, :string)
    field(:multi_text, :string)
    field(:date, :date)
    field(:date_time, :utc_datetime)
    belongs_to(:experience, Experience)

    timestamps()
  end

  @doc false
  def changeset(%Field{} = field, attrs) do
    field
    |> cast(attrs, [
      :name,
      :field_type,
      :single_text,
      :multi_text,
      :date,
      :date_time,
      :number,
      :boolean,
      :decimal,
      :experience_id
    ])
    |> validate_required([:name, :field_type, :experience_id])
    |> validate_length(:name, min: 2)
    |> unique_constraint(:name, name: :fields_name_experience_id_index)
  end
end
