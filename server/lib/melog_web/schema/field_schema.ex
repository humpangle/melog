defmodule MelogWeb.FieldSchema do
  @moduledoc """
  The GraphQl schema for the Field Ecto schema
  """
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Melog.Repo
  alias MelogWeb.FieldResolver

  @desc "The possible data type for a field"
  enum :field_data_type do
    value(:boolean, description: "A field value that may be true or false")
    value(:number, description: "A field value that must be an integer")
    value(:decimal, description: "A field value that must be a float")

    value(
      :single_text,
      description: "A field value that must be single line text"
    )

    value(
      :multi_text,
      description: "A field value that must be multi line text"
    )

    value(:date, description: "A field value that must be a date")
    value(:date_time, description: "A field value that must be date time")
  end

  @desc "Inputs for creating field"
  input_object :create_field_input do
    @desc "The name of the field e.g 'sleep start'"
    field(:name, non_null(:string))

    @desc "Experience to which the field belongs"
    field(:experience_id, non_null(:id))

    @desc "The data type of field. E.g. for a field named 'sleep start', date_time"
    field(:field_type, non_null(:field_data_type))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "A field that will contain data about experience user wishes to record."
  object :field do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:field_type, non_null(:field_data_type))

    field(:boolean, :boolean)
    field(:number, :integer)
    field(:decimal, :float)
    field(:single_text, :string)
    field(:multi_text, :string)
    field(:date, :date)
    field(:date_time, :iso_datetime)

    field(:experience, :experience, resolve: assoc(:experience))
    field(:inserted_at, non_null(:iso_datetime))
    field(:updated_at, non_null(:iso_datetime))
  end

  @desc "The mutations allowed on the field object"
  object :field_mutation do
    field :create_field, type: :field do
      arg(:field, non_null(:create_field_input))

      resolve(&FieldResolver.create_field/3)
    end
  end
end
