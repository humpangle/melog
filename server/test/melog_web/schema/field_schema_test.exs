defmodule MelogWeb.FieldSchemaTest do
  use Melog.DataCase
  alias MelogWeb.Schema
  alias MelogWeb.FieldQueries
  alias Melog.Experiences.{Field}
  alias Melog.FieldApi, as: Api

  @now Timex.now()

  setup do
    user = create_user()
    {:ok, user: user, experience: create_experience(user)}
  end

  describe "mutation - create field" do
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
                 FieldQueries.mutation(:create_field),
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
                 FieldQueries.mutation(:create_field),
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
                 FieldQueries.mutation(:create_field),
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
                 FieldQueries.mutation(:create_field),
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

  describe "mutation - store number" do
    test "store number succeeds", %{user: user, experience: experience} do
      field_type = Field.data_type(:number)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        name: name,
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = 5

      assert {:ok,
              %{
                data: %{
                  "storeNumber" => %{
                    "id" => ^id,
                    "name" => ^name,
                    "fieldType" => ^field_type,
                    "number" => ^value
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_number),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "store number fails for non integer values", %{user: user, experience: experience} do
      field_type = Field.data_type(:number)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = 5.0

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_number),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "does not store value for a different data type", %{user: user, experience: experience} do
      field_type1 = Field.data_type(:number)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          # field was created with type number
          field_type: field_type1
        })

      # but now we wish to store a decimal type. This should error
      field_type2 = Field.data_type(:decimal)

      value = 5.0

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_decimal),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type2,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end
  end

  describe "mutation - store boolean" do
    test "store boolean succeeds", %{user: user, experience: experience} do
      field_type = Field.data_type(:boolean)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        name: name,
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = true

      assert {:ok,
              %{
                data: %{
                  "storeBoolean" => %{
                    "id" => ^id,
                    "name" => ^name,
                    "fieldType" => ^field_type,
                    "boolean" => ^value,
                    "number" => nil
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_boolean),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "store boolean fails for non boolean values", %{user: user, experience: experience} do
      field_type = Field.data_type(:boolean)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = "true"

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_boolean),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end
  end

  describe "mutation - store decimal" do
    test "store decimal succeeds", %{user: user, experience: experience} do
      field_type = Field.data_type(:decimal)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        name: name,
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = 5.0

      assert {:ok,
              %{
                data: %{
                  "storeDecimal" => %{
                    "id" => ^id,
                    "name" => ^name,
                    "fieldType" => ^field_type,
                    "decimal" => ^value,
                    "boolean" => nil,
                    "number" => nil
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_decimal),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "store decimal fails for non decimal values", %{user: user, experience: experience} do
      field_type = Field.data_type(:decimal)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = "5.0"

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_decimal),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end
  end

  describe "mutation - store single_text" do
    test "store single_text succeeds", %{user: user, experience: experience} do
      field_type = Field.data_type(:single_text)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        name: name,
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = "A single text"

      assert {:ok,
              %{
                data: %{
                  "storeSingleText" => %{
                    "id" => ^id,
                    "name" => ^name,
                    "fieldType" => ^field_type,
                    "single_text" => ^value,
                    "decimal" => nil,
                    "boolean" => nil,
                    "number" => nil
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_single_text),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "store single_text fails for non string values", %{user: user, experience: experience} do
      field_type = Field.data_type(:single_text)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = 5.0

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_single_text),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end
  end

  describe "mutation - store multi_text" do
    test "store multi_text succeeds", %{user: user, experience: experience} do
      field_type = Field.data_type(:multi_text)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        name: name,
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = "A multi
      line text"

      assert {:ok,
              %{
                data: %{
                  "storeMultiText" => %{
                    "id" => ^id,
                    "name" => ^name,
                    "fieldType" => ^field_type,
                    "multi_text" => ^value,
                    "single_text" => nil,
                    "decimal" => nil,
                    "boolean" => nil,
                    "number" => nil
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_multi_text),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "store multi_text fails for non string values", %{user: user, experience: experience} do
      field_type = Field.data_type(:multi_text)

      %{
        "jwt" => jwt
      } = user

      %{
        string_id: experience_id
      } = experience

      %{
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = 5.0

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_multi_text),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end
  end

  describe "mutation - store date" do
    test "store date succeeds", %{user: %{"jwt" => jwt}, experience: %{string_id: experience_id}} do
      field_type = Field.data_type(:date)

      %{
        name: name,
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      {:ok, value} = Timex.format(@now, "{ISOdate}")

      assert {:ok,
              %{
                data: %{
                  "storeDate" => %{
                    "id" => ^id,
                    "name" => ^name,
                    "fieldType" => ^field_type,
                    "date" => ^value,
                    "multi_text" => nil,
                    "single_text" => nil,
                    "decimal" => nil,
                    "boolean" => nil,
                    "number" => nil
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_date),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "store date fails for invalid date", %{
      user: %{"jwt" => jwt},
      experience: %{string_id: experience_id}
    } do
      field_type = Field.data_type(:date)

      %{
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = "2018-01"

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_date),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end
  end

  describe "mutation - store date_time" do
    test "store date_time succeeds", %{
      user: %{"jwt" => jwt},
      experience: %{string_id: experience_id}
    } do
      field_type = Field.data_type(:date_time)

      %{
        name: name,
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      {:ok, value} = Timex.format(@now, "{ISO:Extended:Z}")

      assert {:ok,
              %{
                data: %{
                  "storeDateTime" => %{
                    "id" => ^id,
                    "name" => ^name,
                    "fieldType" => ^field_type,
                    "dateTime" => ^value,
                    "date" => nil,
                    "multi_text" => nil,
                    "single_text" => nil,
                    "decimal" => nil,
                    "boolean" => nil,
                    "number" => nil
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_date_time),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "store date_time fails for invalid date_time", %{
      user: %{"jwt" => jwt},
      experience: %{string_id: experience_id}
    } do
      field_type = Field.data_type(:date_time)

      %{
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = "2018-01"

      assert {:ok,
              %{
                errors: _
              }} =
               Absinthe.run(
                 FieldQueries.mutation(:store_date_time),
                 Schema,
                 variables: %{
                   "data" => %{
                     "value" => value,
                     "fieldType" => field_type,
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end
  end

  describe "query" do
    test "get field succeeds", %{user: user, experience: experience} do
      %{
        "jwt" => jwt,
        "username" => username,
        "id" => user_id
      } = user

      %{
        string_id: experience_id,
        intro: intro,
        title: title
      } = experience

      field_type = Field.data_type(:number)

      %{
        name: name,
        string_id: id
      } =
        create_field(%{
          experience_id: experience_id,
          field_type: field_type
        })

      value = 10
      field = Api.get_field!(id)
      {:ok, _} = Api.update_field(field, %{number: value})

      assert {:ok,
              %{
                data: %{
                  "field" => %{
                    "id" => ^id,
                    "name" => ^name,
                    "fieldType" => ^field_type,
                    "number" => ^value,
                    "experience" => %{
                      "id" => ^experience_id,
                      "title" => ^title,
                      "intro" => ^intro,
                      "user" => %{
                        "id" => ^user_id,
                        "username" => ^username
                      }
                    }
                  }
                }
              }} =
               Absinthe.run(
                 FieldQueries.query(:field),
                 Schema,
                 variables: %{
                   "field" => %{
                     "jwt" => jwt,
                     "id" => id
                   }
                 }
               )
    end

    test "user can only get field that belongs to her.", %{
      experience: %{string_id: experience_id0},
      user: %{"id" => user_id0, "jwt" => jwt0}
    } do
      field_type = Field.data_type(:date_time)

      # user 0 has two fields for same experience
      %{
        string_id: id01
      } =
        create_field(%{
          experience_id: experience_id0,
          field_type: field_type
        })

      %{
        string_id: id02
      } =
        create_field(%{
          experience_id: experience_id0,
          field_type: field_type
        })

      # Another user creates a field
      %{"id" => user_id1} = user1 = create_user()
      %{string_id: experience_id1} = create_experience(user1)

      create_field(%{
        experience_id: experience_id1,
        field_type: field_type
      })

      # we check to make sure they are indeed different users with different
      # experiences
      refute user_id0 == user_id1
      refute experience_id0 == experience_id1

      # We have created 3 fields in all: 2 for user0 and 1 for user1
      assert 3 == Api.list_fields() |> length()

      assert {:ok,
              %{
                data: %{
                  # we got only two from query as expected
                  "fields" => [
                    %{
                      "id" => ^id01,
                      "experience" => %{
                        "id" => experience_id0,
                        "user" => %{
                          "id" => user_id0
                        }
                      }
                    },
                    %{
                      "id" => ^id02,
                      "experience" => %{
                        "id" => experience_id0,
                        "user" => %{
                          "id" => user_id0
                        }
                      }
                    }
                  ]
                }
              }} =
               Absinthe.run(
                 FieldQueries.query(:fields),
                 Schema,
                 variables: %{
                   "field" => %{
                     "jwt" => jwt0
                   }
                 }
               )
    end
  end

  defp create_field(attrs) do
    attrs =
      if Map.has_key?(attrs, :field_type) do
        Map.put(attrs, :field_type, String.downcase(attrs.field_type))
      else
        attrs
      end

    {:ok, %Field{id: id} = field} =
      build(:field, attrs)
      |> Api.create_field()

    Map.from_struct(field)
    |> Map.put(:string_id, Integer.to_string(id))
  end
end
