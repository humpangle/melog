defmodule Melog.Repo.Migrations.FieldNonNullExperienceId do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE fields DROP CONSTRAINT fields_experience_id_fkey")

    alter table("fields") do
      modify(
        :experience_id,
        references(:experiences, on_delete: :delete_all),
        null: false
      )
    end
  end
end
