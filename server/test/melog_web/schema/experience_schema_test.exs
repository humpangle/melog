defmodule MelogWeb.ExperienceSchemaTest do
  use Melog.DataCase
  alias MelogWeb.Schema
  alias MelogWeb.UserQueries
  alias MelogWeb.ExperienceQueries
  alias Melog.ExperienceAPI, as: Api

  def create_user(_) do
    %{
      email: email,
      password: password
    } = _user_params = build(:user)

    {:ok, %{
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

    {:ok, user: user}
  end

  describe "mutation" do
    setup [:create_user]

    test "create experience succeeds", %{user: user} do
      %{
        "id" => user_id,
        "username" => username,
        "jwt" => jwt
      } = user

      %{
        title: title,
        intro: intro
      } = build(:experience)

      assert {:ok, %{
               data: %{
                 "createExperience" => %{
                   "id" => _,
                   "title" => ^title,
                   "intro" => ^intro,
                   "insertedAt" => _,
                   "updatedAt" => _,
                   "user" => %{
                     "id" => ^user_id,
                     "username" => ^username
                   }
                 }
               }
             }} =
               Absinthe.run(
                 ExperienceQueries.mutation(:create_experience),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "title" => title,
                     "intro" => intro,
                     "jwt" => jwt
                   }
                 }
               )
    end

    test "create experience fails because titles not unique for user", %{user: user} do
      %{
        "email" => email,
        "jwt" => jwt,
        "id" => id
      } = user

      %{
        title: title,
        intro: intro
      } = build(:experience)

      # We create an experience for this user with the title above
      {:ok, _} =
        Api.create_experience(%{
          title: title,
          intro: intro,
          email: email,
          user_id: id
        })

      # We then try to create another experience, same user and same title
      assert {:ok, %{
               errors: _
             }} =
               Absinthe.run(
                 ExperienceQueries.mutation(:create_experience),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "title" => title,
                     "intro" => intro,
                     "jwt" => jwt
                   }
                 }
               )
    end

    test "create experience fails because user is not authenticated" do
      %{
        title: title,
        intro: intro
      } = build(:experience)

      assert {:ok, %{
               errors: _
             }} =
               Absinthe.run(
                 ExperienceQueries.mutation(:create_experience),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "title" => title,
                     "intro" => intro
                     # "jwt" => jwt the presence of jwt signals authentication
                   }
                 }
               )
    end
  end
end
