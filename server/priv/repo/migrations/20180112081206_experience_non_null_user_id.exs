defmodule Melog.Repo.Migrations.ExperienceNonNullUserId do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE experiences DROP CONSTRAINT experiences_user_id_fkey")

    alter table("experiences") do
      modify(
        :user_id,
        references(:users, on_delete: :delete_all),
        null: false
      )
    end
  end
end
