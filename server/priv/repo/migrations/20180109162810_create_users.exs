defmodule Melog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :text, null: false
      add :username, :text
      add :password, :text, null: false

      timestamps()
    end

    create index(:users, [:email], unique: true)
  end
end
