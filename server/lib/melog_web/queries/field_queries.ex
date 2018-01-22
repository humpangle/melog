defmodule MelogWeb.FieldQueries do
  def mutation(:create_field) do
    """
    mutation CreateField($field: CreateFieldInput!){
      createField(field: $field) {
        id
        name
        fieldType
        insertedAt
        updatedAt
      }
    }
    """
  end

  def mutation(:create_experience_fields_collection) do
    """
    mutation CreateExperienceFieldsCollection(
      $experienceFields: CreateExperienceFieldsCollectionInput!
    ){
      createExperienceFieldsCollection(experienceFields: $experienceFields) {
        fields {
          id
          name
          fieldType
          insertedAt
          updatedAt
        }
        experience {
          id
          title
          intro
          user {
            id
          }
        }
      }
    }
    """
  end

  def mutation(:store_number) do
    """
    mutation StoreNumber($data: StoreNumberInput!){
      storeNumber(data: $data) {
        id
        name
        fieldType
        number
        insertedAt
        updatedAt
      }
    }
    """
  end

  def mutation(:store_boolean) do
    """
    mutation StoreBoolean($data: StoreBooleanInput!){
      storeBoolean(data: $data) {
        id
        name
        fieldType
        boolean
        number
        insertedAt
        updatedAt
      }
    }
    """
  end

  def mutation(:store_decimal) do
    """
    mutation StoreDecimal($data: StoreDecimalInput!){
      storeDecimal(data: $data) {
        id
        name
        fieldType
        decimal
        boolean
        number
        insertedAt
        updatedAt
      }
    }
    """
  end

  def mutation(:store_single_text) do
    """
    mutation StoreSingleText($data: StoreSingleTextInput!){
      storeSingleText(data: $data) {
        id
        name
        fieldType
        single_text
        decimal
        boolean
        number
        insertedAt
        updatedAt
      }
    }
    """
  end

  def mutation(:store_multi_text) do
    """
    mutation StoreMultiText($data: StoreMultiTextInput!){
      storeMultiText(data: $data) {
        id
        name
        fieldType
        multi_text
        single_text
        decimal
        boolean
        number
        insertedAt
        updatedAt
      }
    }
    """
  end

  def mutation(:store_date) do
    """
    mutation StoreDate($data: StoreDateInput!){
      storeDate(data: $data) {
        id
        name
        fieldType
        date
        multi_text
        single_text
        decimal
        boolean
        number
        insertedAt
        updatedAt
      }
    }
    """
  end

  def mutation(:store_date_time) do
    """
    mutation StoreDateTime($data: StoreDateTimeInput!){
      storeDateTime(data: $data) {
        id
        name
        fieldType
        dateTime
        date
        multi_text
        single_text
        decimal
        boolean
        number
        insertedAt
        updatedAt
      }
    }
    """
  end

  def query(:field) do
    """
    query GetField($field: GetFieldInput!) {
      field(field: $field) {
        id
        name
        fieldType
        number
        insertedAt
        updatedAt
        experience {
          id
          title
          intro
          user {
            id
            username
          }
        }
      }
    }
    """
  end

  def query(:fields) do
    """
    query GetFields($field: GetFieldsInput) {
      fields(field: $field) {
        id
        name
        fieldType
        number
        insertedAt
        updatedAt
        experience {
          id
          title
          intro
          user {
            id
            username
          }
        }
      }
    }
    """
  end
end
