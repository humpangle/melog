defmodule MelogWeb.FieldSchemaTest do
  use Melog.DataCase
  alias MelogWeb.Schema
  alias MelogWeb.FieldQueries
  alias Melog.Experiences.{Field}
  alias Melog.FieldApi, as: Api

  setup do
    user = create_user()
    {:ok, user: user, experience: create_experience(user)}
  end

  describe "mutation" do
    test "create field succeeds", %{user: user, experience: experience} do
      %{name: name} = build(:field)
      field_type = Field.data_type(:boolean)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      assert {:ok,
              %{
                data: %{
                  "createField" => %{
                    "name" => ^name,
                    "fieldType" => ^field_type
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation("create_field"),
                 Schema,
                 variables: %{
                   "field" => %{
                     "name" => name,
                     "experienceId" => experience_id,
                     "fieldType" => field_type,
                     "jwt" => jwt
                   }
                 }
               )
    end

    test "create field fails for unauthenticated user", %{experience: experience} do
      %{name: name} = build(:field)
      field_type = Field.data_type(:boolean)

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation("create_field"),
                 Schema,
                 variables: %{
                   "field" => %{
                     "name" => name,
                     "experienceId" => experience.string_id,
                     "fieldType" => field_type
                   }
                 }
               )
    end

    test "create field fails if name not unique for experience", %{experience: experience} do
      %{name: name} = build(:field)
      %{string_id: experience_id} = experience

      field_type1 = Field.data_type(:raw, :boolean)
      field_type2 = Field.data_type(:number)

      create_field(%{
        name: name,
        field_type: field_type1,
        experience_id: experience_id
      })

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation("create_field"),
                 Schema,
                 variables: %{
                   "field" => %{
                     "name" => name,
                     "experienceId" => experience_id,
                     "fieldType" => field_type2
                   }
                 }
               )
    end

    test "create field succeeds, different experiences can have same field name and type", %{
      experience: experience,
      user: user
    } do
      %{name: name} = build(:field)
      %{string_id: experience_id} = experience
      field_type_raw = Field.data_type(:raw, :boolean)

      %{name: name1, field_type: field_type1} =
        create_field(%{
          name: name,
          field_type: field_type_raw,
          experience_id: experience_id
        })

      # same field type as above
      field_type = Field.data_type(:boolean)

      # a different experience
      %{string_id: experience_id1} = create_experience(user)

      assert {:ok,
              %{
                data: %{
                  "createField" => %{
                    "name" => name2,
                    "fieldType" => field_type2
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation("create_field"),
                 Schema,
                 variables: %{
                   "field" => %{
                     "name" => name,
                     "experienceId" => experience_id1,
                     "fieldType" => field_type,
                     "jwt" => user["jwt"]
                   }
                 }
               )

      assert name1 == name2
      assert Field.data_type(field_type1) == field_type2
    end
  end

  defp create_field(attrs) do
    {:ok, %Field{id: id} = field} = Api.create_field(attrs)
    Map.from_struct(field) |> Map.put(:string_id, Integer.to_string(id))
  end
end
