# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Melog.Repo.insert!(%Melog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Melog.Factory
alias Melog.Repo
alias Melog.Accounts
alias Melog.Accounts.User
alias Melog.FieldApi

Repo.delete_all(User)

1..5
|> Enum.each(fn _ ->
  {:ok, user} = build(:user) |> Accounts.create_user()

  Enum.each(1..Enum.random(3..5), fn _ ->
    fields =
      1..Enum.random(1..3)
      |> Enum.map(fn _ ->
        field_type =
          [:number, :boolean, :single_text, :decimal, :multi_text]
          |> Enum.random()

        build(:field, field_type: field_type)
      end)

    FieldApi.create_experience_fields_collection(%{
      experience: build(:experience, user_id: user.id, email: user.email),
      fields: fields
    })
  end)
end)
