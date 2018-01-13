defmodule Melog.Repo.Migrations.FieldsAddFieldTypeField do
  use Ecto.Migration

  def change do
    FieldTypeEnum.create_type()

    alter table("fields") do
      add(:field_type, :field_type, null: false)
    end

    create(unique_index(:fields, [:name, :experience_id, :field_type]))
  end
end
