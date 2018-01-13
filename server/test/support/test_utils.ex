defmodule Melog.TestUtils do
  @moduledoc """
  Test utilities
  """

  import Melog.Factory
  alias MelogWeb.Schema
  alias MelogWeb.UserQueries
  alias Melog.ExperienceAPI

  # @utc_tz "Etc/UTC"
  # @iso_extended "{ISO:Extended:Z}"

  @doc """
  Convert a Timex utc to local time zone
  """
  def timex_ecto_date_to_local_datime_tz(date) do
    Timex.to_datetime(date, :local)
  end

  @spec create_user() :: Map.t()
  @spec create_user(Map.t()) :: Map.t()
  def create_user(params \\ %{}) do
    %{
      email: email,
      password: password
    } = build(:user, params)

    {:ok,
     %{
       data: %{
         "createUser" => user
       }
     }} =
      Absinthe.run(
        UserQueries.mutation(:create_user),
        Schema,
        variables: %{
          "user" => %{
            "email" => email,
            "password" => password
          }
        }
      )

    user
  end

  def create_experience(user, params \\ %{}) do
    %{
      "id" => id,
      "email" => email
    } = user

    {:ok, exp} =
      build(:experience, Map.merge(%{email: email, user_id: id}, params))
      |> ExperienceAPI.create_experience()

    Map.from_struct(exp) |> Map.put(:string_id, Integer.to_string(exp.id))
  end
end
