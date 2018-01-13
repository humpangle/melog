defmodule Melog.Repo.Migrations.ExperienceTitleUniqueConstraint do
  use Ecto.Migration

  def change do
    drop(index(:experiences, [:title]))
    create(unique_index(:experiences, [:title, :user_id]))
  end
end
