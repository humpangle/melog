defmodule Melog.FieldApi do
  @moduledoc """
  The Api interface to the experience schema
  """
  import Ecto.Query, warn: false
  alias Melog.Repo

  alias Melog.Experiences.Field

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
  def change_field(%Field{} = field) do
    Field.changeset(field, %{})
  end
end
