defmodule Melog.Repo.Migrations.CreateFields do
  use Ecto.Migration

  def change do
    create table(:fields) do
      add :name, :text, null: false
      add :single_text, :text
      add :multi_text, :text
      add :date, :date
      add :date_time, :utc_datetime
      add :number, :integer
      add :boolean, :boolean
      add :decimal, :float
      add :experience_id, references(:experiences, on_delete: :delete_all)

      timestamps()
    end

    create index(:fields, [:experience_id])
  end
end
