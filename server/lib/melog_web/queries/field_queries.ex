defmodule MelogWeb.FieldQueries do
  def mutation("create_field") do
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
end
