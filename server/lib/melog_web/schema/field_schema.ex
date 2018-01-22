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

  @desc "Inputs for creating a field for an existing experience"
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

  @desc "Inputs for a single field in a collection of fields."
  input_object :single_field do
    @desc "The name of the field e.g 'sleep start'"
    field(:name, non_null(:string))

    @desc "The data type of field. E.g. for a field named 'sleep start', date_time"
    field(:field_type, non_null(:field_data_type))
  end

  @desc "Inputs for creating a single experience and multiple fields for that experuence"
  input_object :create_experience_fields_collection_input do
    @desc "Inputs for the experience to which the fields collection belongs"
    field(:experience, non_null(:create_experience_input))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)

    @desc "The list of fields belonging to same experience"
    field(:fields, :single_field |> list_of() |> non_null())
  end

  @desc "Inputs for storing an integer value"
  input_object :store_number_input do
    @desc "The ID of the field"
    field(:id, non_null(:id))

    @desc "The data type of field. Must be `NUMBER` in this case."
    field(:field_type, non_null(:field_data_type))

    @desc "The integer value to store e.g. 60"
    field(:value, non_null(:integer))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Inputs for storing a boolean value"
  input_object :store_boolean_input do
    @desc "The ID of the field"
    field(:id, non_null(:id))

    @desc "The data type of field. Must be `BOOLEAN` in this case."
    field(:field_type, non_null(:field_data_type))

    @desc "The boolean value to store e.g. 'true'"
    field(:value, non_null(:boolean))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Inputs for storing a decimal value"
  input_object :store_decimal_input do
    @desc "The ID of the field"
    field(:id, non_null(:id))

    @desc "The data type of field. Must be `DECIMAL` in this case."
    field(:field_type, non_null(:field_data_type))

    @desc "The decimal value to store e.g. 'true'"
    field(:value, non_null(:float))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Inputs for storing a single text value"
  input_object :store_single_text_input do
    @desc "The ID of the field"
    field(:id, non_null(:id))

    @desc "The data type of field. Must be `SINGLETEXT` in this case."
    field(:field_type, non_null(:field_data_type))

    @desc "The string value to store e.g. 'some short text'"
    field(:value, non_null(:string))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Inputs for storing a multi line text value"
  input_object :store_multi_text_input do
    @desc "The ID of the field"
    field(:id, non_null(:id))

    @desc "The data type of field. Must be `MULTITEXT` in this case."
    field(:field_type, non_null(:field_data_type))

    @desc "The string value to store e.g. 'some long text'"
    field(:value, non_null(:string))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Inputs for storing a date value"
  input_object :store_date_input do
    @desc "The ID of the field"
    field(:id, non_null(:id))

    @desc "The data type of field. Must be `DATE` in this case."
    field(:field_type, non_null(:field_data_type))

    @desc "The date value to store e.g. '2018-01-14'"
    field(:value, non_null(:date))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Inputs for storing a date_time value"
  input_object :store_date_time_input do
    @desc "The ID of the field"
    field(:id, non_null(:id))

    @desc "The data type of field. Must be `DATETIME` in this case."
    field(:field_type, non_null(:field_data_type))

    @desc "The date time value to store e.g. '2018-01-14T16:48:01 +03:00'"
    field(:value, non_null(:iso_datetime))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Inputs for retrieving a field"
  input_object :get_field_input do
    @desc "The ID of the field we wish to retrieve."
    field(:id, non_null(:id))

    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Inputs for retrieving all fields belonging to a user"
  input_object :get_fields_input do
    @desc "For authentication in non web contexts"
    field(:jwt, :string)
  end

  @desc "Object represeting data about experience user wishes to record."
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

  @desc "Object representing a fields collection i.e experience and a list of fields beloging to that experience"
  object :fields_collection do
    @desc "Experience to which all fields in the collection belong"
    field(:experience, type: :experience)

    @desc "The list of fields belonging to same experience"
    field(:fields, type: list_of(:field))
  end

  @desc "The mutations allowed on the field object"
  object :field_mutation do
    @desc "Create a field for an existing experience."
    field :create_field, type: :field do
      arg(:field, non_null(:create_field_input))

      resolve(&FieldResolver.create_field/3)
    end

    @desc "Create an experience and collection of fields for the new experience."
    field :create_experience_fields_collection, type: :fields_collection do
      arg(
        :experience_fields,
        non_null(:create_experience_fields_collection_input)
      )

      resolve(&FieldResolver.create_experience_fields_collection/3)
    end

    @desc "Store number data in a field."
    field :store_number, type: :field do
      arg(:data, non_null(:store_number_input))

      resolve(&FieldResolver.store_value/3)
    end

    @desc "Store boolean data in a field."
    field :store_boolean, type: :field do
      arg(:data, non_null(:store_boolean_input))

      resolve(&FieldResolver.store_value/3)
    end

    @desc "Store floating point number data in a field."
    field :store_decimal, type: :field do
      arg(:data, non_null(:store_decimal_input))

      resolve(&FieldResolver.store_value/3)
    end

    @desc "Store single text data in a field."
    field :store_single_text, type: :field do
      arg(:data, non_null(:store_single_text_input))

      resolve(&FieldResolver.store_value/3)
    end

    @desc "Store multiple lines text data in a field."
    field :store_multi_text, type: :field do
      arg(:data, non_null(:store_multi_text_input))

      resolve(&FieldResolver.store_value/3)
    end

    @desc "Store date data in a field."
    field :store_date, type: :field do
      arg(:data, non_null(:store_date_input))

      resolve(&FieldResolver.store_value/3)
    end

    @desc "Store datetime data in a field."
    field :store_date_time, type: :field do
      arg(:data, non_null(:store_date_time_input))

      resolve(&FieldResolver.store_value/3)
    end
  end

  @desc "The queries allowed on the a field object"
  object :field_query do
    field :field, type: :field do
      arg(:field, non_null(:get_field_input))

      resolve(&FieldResolver.field/3)
    end

    field :fields, type: list_of(:field) do
      arg(:field, :get_fields_input)

      resolve(&FieldResolver.fields/3)
    end
  end
end
