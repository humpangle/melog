defmodule Melog.Repo.Migrations.CreateExperiences do
  use Ecto.Migration

  def change do
    create table(:experiences) do
      add :title, :text, null: false
      add :intro, :text
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:experiences, [:user_id])
    # title will be unique for a given user. So we merge the username to the
    # while casting. E.g, a user can not create two sleep experiences. But
    # user Alice and user Bob can create sleep experiences. So we do
    # alice__sleep and bob__sleep
    create index(:experiences, [:title], unique: true)
  end
end
