defmodule Melog.Repo.Migrations.FieldNameUniqueConstraint do
  use Ecto.Migration

  def change do
    create(unique_index(:fields, [:name, :experience_id]))
  end
end
