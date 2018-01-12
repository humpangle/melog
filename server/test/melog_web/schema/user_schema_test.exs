defmodule MelogWeb.UserSchemaTest do
  use Melog.DataCase
  alias MelogWeb.Schema
  alias MelogWeb.UserQueries
  alias Melog.Accounts
  alias Melog.Accounts.User
  alias Melog.ExperienceAPI
  alias Melog.Experiences.Experience

  describe "mutation" do
    test "create user without username" do
      %{
        email: email,
        password: password
      } = build(:user)

      assert {:ok,
              %{
                data: %{
                  "createUser" => %{
                    "id" => _,
                    "username" => username,
                    "email" => ^email,
                    "jwt" => _,
                    "insertedAt" => _insertedAt,
                    "updatedAt" => _
                  }
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

      assert username == email
    end

    test "create user with username" do
      %{
        email: email,
        password: password,
        username: username
      } = Map.put(build(:user), :username, "random user")

      assert {:ok,
              %{
                data: %{
                  "createUser" => %{
                    "id" => _,
                    "username" => ^username,
                    "email" => ^email,
                    "jwt" => _,
                    "insertedAt" => _,
                    "updatedAt" => _
                  }
                }
              }} =
               Absinthe.run(
                 UserQueries.mutation(:create_user),
                 Schema,
                 variables: %{
                   "user" => %{
                     "email" => email,
                     "password" => password,
                     "username" => username
                   }
                 }
               )

      refute username == email
    end

    test "login user" do
      %{
        email: email,
        password: password
      } = build(:user)

      Accounts.create_user(%{
        email: email,
        password: password
      })

      assert {:ok,
              %{
                data: %{
                  "login" => %{
                    "id" => _,
                    "username" => _,
                    "email" => ^email,
                    "jwt" => _
                  }
                }
              }} =
               Absinthe.run(
                 UserQueries.mutation(:login),
                 Schema,
                 variables: %{
                   "user" => %{
                     "email" => email,
                     "password" => password
                   }
                 }
               )
    end
  end

  describe "query" do
    test "get user by id" do
      %{
        email: email,
        password: password
      } = build(:user)

      {:ok, %User{id: id}} =
        Accounts.create_user(%{
          email: email,
          password: password
        })

      string_id = Integer.to_string(id)

      assert {:ok,
              %{
                data: %{
                  "user" => %{
                    "id" => ^string_id,
                    "username" => _,
                    "insertedAt" => _,
                    "updatedAt" => _,
                    "experiences" => []
                  }
                }
              }} =
               Absinthe.run(
                 UserQueries.query(:user),
                 Schema,
                 variables: %{
                   "user" => %{
                     "id" => string_id
                   }
                 }
               )
    end

    test "get user by email" do
      %{
        email: email,
        password: password
      } = build(:user)

      {:ok, %User{id: id}} =
        Accounts.create_user(%{
          email: email,
          password: password
        })

      string_id = Integer.to_string(id)

      assert {:ok,
              %{
                data: %{
                  "user" => %{
                    "id" => ^string_id,
                    "username" => _,
                    "insertedAt" => _,
                    "updatedAt" => _
                  }
                }
              }} =
               Absinthe.run(
                 UserQueries.query(:user),
                 Schema,
                 variables: %{
                   "user" => %{
                     "email" => email
                   }
                 }
               )
    end

    test "get user by id and email email" do
      %{
        email: email,
        password: password
      } = build(:user)

      {:ok, %User{id: id}} =
        Accounts.create_user(%{
          email: email,
          password: password
        })

      string_id = Integer.to_string(id)

      assert {:ok,
              %{
                data: %{
                  "user" => %{
                    "id" => ^string_id,
                    "username" => _,
                    "insertedAt" => _,
                    "updatedAt" => _
                  }
                }
              }} =
               Absinthe.run(
                 UserQueries.query(:user),
                 Schema,
                 variables: %{
                   "user" => %{
                     "email" => email,
                     "id" => string_id
                   }
                 }
               )
    end

    test "get user errors because user is not authenticate" do
      # An unauthenticated user should not be able to access email field
      %{
        email: email
      } = user = build(:user)

      Accounts.create_user(user)

      assert {:ok,
              %{
                errors: _errors
              }} =
               Absinthe.run(
                 UserQueries.query(:user_error),
                 Schema,
                 variables: %{
                   "user" => %{
                     "email" => email
                   }
                 }
               )
    end

    test "get all users succeeds" do
      Accounts.create_user(build(:user))

      %{
        email: email,
        password: password
      } = build(:user)

      {:ok,
       %User{
         id: id,
         username: username
       }} =
        Accounts.create_user(%{
          email: email,
          password: password
        })

      string_id = Integer.to_string(id)

      assert {:ok,
              %{
                data: %{
                  "users" => users
                }
              }} =
               Absinthe.run(
                 UserQueries.query(:users),
                 Schema
               )

      assert length(users) == 2

      assert %{
               "id" => ^string_id,
               "username" => ^username
             } = List.last(users)
    end

    test "get user with experiences" do
      {:ok,
       %{
         data: %{
           "createUser" => %{
             "id" => string_id,
             "email" => email
           }
         }
       }} =
        Absinthe.run(
          UserQueries.mutation(:create_user),
          Schema,
          variables: %{
            "user" => map_atom_keys_to_string_keys(build(:user))
          }
        )

      {:ok,
       %Experience{
         id: exp_id,
         title: title,
         intro: intro
       }} =
        ExperienceAPI.create_experience(
          build(:experience, %{
            user_id: string_id,
            email: email
          })
        )

      string_exp_id = Integer.to_string(exp_id)

      assert {:ok,
              %{
                data: %{
                  "user" => %{
                    "id" => ^string_id,
                    "username" => _,
                    "insertedAt" => _,
                    "updatedAt" => _,
                    "experiences" => [
                      %{
                        "id" => ^string_exp_id,
                        "title" => ^title,
                        "intro" => ^intro
                      }
                    ]
                  }
                }
              }} =
               Absinthe.run(
                 UserQueries.query(:user),
                 Schema,
                 variables: %{
                   "user" => %{
                     "email" => email
                   }
                 }
               )
    end
  end

  def map_atom_keys_to_string_keys(map) do
    Map.new(map, fn {k, v} -> {Atom.to_string(k), v} end)
  end
end
