defmodule MelogWeb.ExperienceSchemaTest do
  use Melog.DataCase
  alias MelogWeb.Schema
  alias MelogWeb.UserQueries
  alias MelogWeb.ExperienceQueries
  alias Melog.ExperienceAPI, as: Api
  alias Melog.Experiences.Experience
  alias Melog.Accounts
  alias Melog.Accounts.User

  defp create_user_setup(_) do
    {:ok, user: create_user()}
  end

  defp create_experience_setup(_) do
    user = create_user()

    {:ok, user: user, experience: create_experience(user)}
  end

  defp create_user() do
    %{
      email: email,
      password: password
    } = _user_params = build(:user)

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

  defp create_experience(user) do
    %{
      "id" => id,
      "email" => email
    } = user

    {:ok, exp} =
      build(:experience, email: email, user_id: id)
      |> Api.create_experience()

    exp
  end

  describe "mutation" do
    setup [:create_user_setup]

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

      assert {:ok,
              %{
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
      assert {:ok,
              %{
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

    test "create experience succeeds when two users use same title", %{user: user} do
      %{
        "email" => email,
        "jwt" => jwt,
        "id" => id
      } = user

      %{
        title: title,
        intro: intro
      } = build(:experience)

      # We create a new user
      {:ok,
       %User{
         email: email1,
         id: id1
       }} = Accounts.create_user(build(:user))

      # We create an experience for new user with the title above
      {:ok, %Experience{title: title1}} =
        Api.create_experience(%{
          title: title,
          intro: intro,
          email: email1,
          user_id: id1
        })

      assert title == title1
      refute email == email1

      # We then create another experience, different user and same title
      assert {:ok,
              %{
                data: %{
                  "createExperience" => %{
                    "title" => ^title,
                    "user" => %{
                      "id" => ^id
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

    test "create experience fails because user is not authenticated" do
      %{
        title: title,
        intro: intro
      } = build(:experience)

      assert {:ok,
              %{
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

  describe "query" do
    setup [:create_experience_setup]

    test "get experience by id succeeds", %{user: user, experience: exp} do
      %{
        "jwt" => jwt
      } = user

      %Experience{
        id: id,
        title: title,
        intro: intro
      } = exp

      string_id = Integer.to_string(id)

      assert {:ok,
              %{
                data: %{
                  "experience" => %{
                    "id" => ^string_id,
                    "title" => ^title,
                    "intro" => ^intro
                  }
                }
              }} =
               Absinthe.run(
                 ExperienceQueries.query(:experience),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "id" => string_id,
                     "jwt" => jwt
                   }
                 }
               )
    end

    test "get experience by title succeeds", %{user: user, experience: exp} do
      %{
        "jwt" => jwt
      } = user

      %Experience{
        title: title
      } = exp

      assert {:ok,
              %{
                data: %{
                  "experience" => %{
                    "title" => ^title
                  }
                }
              }} =
               Absinthe.run(
                 ExperienceQueries.query(:experience),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "title" => title,
                     "jwt" => jwt
                   }
                 }
               )
    end

    test "get experience by id and title succeeds", %{user: user, experience: exp} do
      %{
        "jwt" => jwt
      } = user

      %Experience{
        id: id,
        title: title,
        intro: intro
      } = exp

      string_id = Integer.to_string(id)

      assert {:ok,
              %{
                data: %{
                  "experience" => %{
                    "id" => ^string_id,
                    "title" => ^title,
                    "intro" => ^intro
                  }
                }
              }} =
               Absinthe.run(
                 ExperienceQueries.query(:experience),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "id" => string_id,
                     "title" => title,
                     "jwt" => jwt
                   }
                 }
               )
    end

    test "get experience fails for unauthenticated user", %{experience: exp} do
      %Experience{
        id: id
      } = exp

      string_id = Integer.to_string(id)

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 ExperienceQueries.query(:experience),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "id" => string_id
                   }
                 }
               )
    end

    test "get experiences succeeds", %{user: user, experience: exp} do
      create_experience(user)

      %Experience{
        id: id,
        title: title,
        intro: intro
      } = exp

      string_id = Integer.to_string(id)

      assert {:ok,
              %{
                data: %{
                  "experiences" => [
                    %{
                      "id" => ^string_id,
                      "title" => ^title,
                      "intro" => ^intro
                    } = _first_exp,
                    _second_exp
                  ]
                }
              }} =
               Absinthe.run(
                 ExperienceQueries.query(:experiences),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "jwt" => user["jwt"]
                   }
                 }
               )
    end

    test "a user can not query another's experiences", %{user: user, experience: exp} do
      user1 = create_user()
      exp1 = create_experience(user1)

      assert {:ok,
              %{
                data: %{
                  "experiences" => [exp0]
                }
              }} =
               Absinthe.run(
                 ExperienceQueries.query(:experiences),
                 Schema,
                 variables: %{
                   "experience" => %{
                     "jwt" => user["jwt"]
                   }
                 }
               )

      # There are a total of 2 experiences in the database
      assert 2 == Api.list_experiences() |> length()

      # The experience from query is same one created for user
      id = String.to_integer(exp0["id"])
      assert exp.id == id

      # The two users are not the same
      assert String.to_integer(user["id"]) < String.to_integer(user1["id"])

      # The two experiences in database are not the same
      assert id < exp1.id
    end
  end
end
