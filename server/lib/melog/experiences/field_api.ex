defmodule Melog.FieldApi do
  @moduledoc """
  The Api interface to the experience schema
  """
  import Ecto.Query, warn: false
  alias Melog.Repo

  alias Melog.Experiences.{Field, Experience}
  alias Melog.ExperienceAPI
  alias Ecto.Multi

  @doc """
  Returns the list of fields.

  ## Examples

      iex> list_fields()
      [%Field{}, ...]

  """
  def list_fields do
    Repo.all(Field)
  end

  @doc """
  Gets a single field.

  Raises `Ecto.NoResultsError` if the Field does not exist.

  ## Examples

      iex> get_field!(123)
      %Field{}

      iex> get_field!(456)
      ** (Ecto.NoResultsError)

  """
  def get_field!(id), do: Repo.get!(Field, id)

  def get_field_for_user(user_id, id) do
    Repo.one(
      from(
        f in Field,
        where: f.id == ^id,
        left_join: e in assoc(f, :experience),
        where: e.user_id == ^user_id
      )
    )
  end

  def get_fields_for_user(user_id) do
    Repo.all(
      from(
        f in Field,
        left_join: e in assoc(f, :experience),
        where: e.user_id == ^user_id
      )
    )
  end

  @doc """
  Creates a field.

  ## Examples

      iex> create_field(%{field: value})
      {:ok, %Field{}}

      iex> create_field(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_field(attrs \\ %{}) do
    %Field{}
    |> Field.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an experience and a collection of fields beloging to that experience
  simulataneously. Returns the experience struct and associated fields (for
  success case) or changeset errors (for failure case)

  ## Examples

      iex> create_experience_fields_collection(%{
        experience: %{intro: "intro", title: "title"},
        fields: [
           %{name: "field1", field_type: "boolean"},
            %{name: "field2", field_type: "number"}
        ]
      })
      {:ok, %{
        experience: %Experience{},
        fields: {2, [%Field{}, %Field{}]}
      }}

      iex> create_experience_fields_collection(%{
        experience: %{intro: "intro", title: "title"},
        fields: [
           %{name: "field1", field_type: "boolean"},
            %{name: "field2", field_type: "number"}
        ]
      })
      {
        :error,
        :fields,
        {2, nil},
        %{
          experience: %Expereince{}
        }
      }

      iex> create_experience_fields_collection(%{
        experience: %{intro: "intro", title: "title"},
        fields: [
           %{name: "field1", field_type: "boolean"},
            %{name: "field2", field_type: "number"}
        ]
      })
      {:error, :experience, %Ecto.Changeset{}, nil}

  """
  @spec create_experience_fields_collection(%{
          experience: Map.t(),
          fields: [Map.t()]
        }) ::
          {:ok,
           %{
             experience: %Experience{}
           }
           | %{required(String.t()) => %Field{}}}
          | {:error, :experience | String.t(), %Ecto.Changeset{}, any}
  def create_experience_fields_collection(%{
        experience: experience,
        fields: fields_
      }) do
    inserts =
      Multi.new()
      |> Multi.insert(
        :experience,
        ExperienceAPI.change_experience(%Experience{}, experience)
      )
      |> Multi.merge(fn %{experience: %Experience{id: id}} ->
        [field0 | rest_fields] =
          Enum.map(
            fields_,
            &Enum.into(&1, %{experience_id: id})
          )

        multi0 = make_field_multi({field0, 0})

        rest_fields
        |> Enum.with_index(1)
        |> Enum.reduce(multi0, &Multi.append(&2, make_field_multi(&1)))
      end)

    Repo.transaction(inserts)
  end

  defp make_field_multi({field, index}) do
    Multi.new()
    |> Multi.insert(
      Integer.to_string(index),
      change_field(%Field{}, field)
    )
  end

  @doc """
  Updates a field.

  ## Examples

      iex> update_field(field, %{field: new_value})
      {:ok, %Field{}}

      iex> update_field(field, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_field(%Field{} = field, attrs) do
    field
    |> Field.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Field.

  ## Examples

      iex> delete_field(field)
      {:ok, %Field{}}

      iex> delete_field(field)
      {:error, %Ecto.Changeset{}}

  """
  def delete_field(%Field{} = field) do
    Repo.delete(field)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking field changes.

  ## Examples

      iex> change_field(field)
      %Ecto.Changeset{source: %Field{}}

  """
  def change_field(%Field{} = field, attrs = %{}) do
    Field.changeset(field, attrs)
  end

  def data_type(:raw, dtype) do
    {:ok, field_type} = FieldTypeEnum.dump(dtype)
    field_type
  end

  def data_type(dtype) do
    data_type(:raw, dtype) |> String.upcase()
  end
end
