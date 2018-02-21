defmodule Melog.Factory do
  use ExMachina.Ecto, repo: Melog.Repo

  # alias Melog.Accounts.User

  def user_factory do
    {user, _next_sequence} = make_user_no_username()
    user
  end

  def user_with_username_factory do
    {user, next_sequence} = make_user_no_username()
    Map.put(user, :username, "user#{next_sequence}")
  end

  def experience_factory do
    %{
      title: Faker.Lorem.words() |> Enum.join("") |> String.capitalize(),
      intro: Faker.Lorem.paragraph()
    }
  end

  def field_factory do
    %{name: sequence("Field name")}
  end

  defp make_user_no_username do
    next_sequence = sequence("")

    user = %{
      email: "user#{next_sequence}@me.com",
      password: "password#{next_sequence}"
    }

    {user, next_sequence}
  end
end
