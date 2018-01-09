defmodule Melog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :text, null: false
      add :experience_id, references(:experiences, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:experience_id])
  end
end
