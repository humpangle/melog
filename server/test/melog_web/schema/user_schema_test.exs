defmodule MelogWeb.UserSchemaTest do
  use Melog.DataCase
  alias MelogWeb.Schema
  alias MelogWeb.UserQueries
  alias Melog.Accounts
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
      %{"id" => id} = create_user()

      assert {:ok,
              %{
                data: %{
                  "user" => %{
                    "id" => ^id,
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
                     "id" => id
                   }
                 }
               )
    end

    test "get user by email" do
      %{"email" => email, "id" => id} = create_user()

      assert {:ok,
              %{
                data: %{
                  "user" => %{
                    "id" => ^id,
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
      %{"email" => email, "id" => id} = create_user()

      assert {:ok,
              %{
                data: %{
                  "user" => %{
                    "id" => ^id,
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
                     "id" => id
                   }
                 }
               )
    end

    test "get user errors because user is not authenticate" do
      # An unauthenticated user should not be able to access email field
      %{"email" => email} = create_user()

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
      # first user
      create_user()

      # 2nd user
      %{"username" => username, "id" => id} = create_user()

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
               "id" => ^id,
               "username" => ^username
             } = List.last(users)
    end

    test "get user with experiences" do
      %{"id" => id} = user = create_user()

      %Experience{
        id: exp_id,
        title: title,
        intro: intro
      } = create_experience(user)

      string_exp_id = Integer.to_string(exp_id)

      assert {:ok,
              %{
                data: %{
                  "user" => %{
                    "id" => ^id,
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
                     "id" => id
                   }
                 }
               )
    end
  end
end
