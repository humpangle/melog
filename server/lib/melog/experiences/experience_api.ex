defmodule Melog.ExperienceAPI do
  import Ecto.Query, warn: false
  alias Melog.Repo
  alias Melog.Experiences.Experience

  @title_modifier_string "....."

  @doc """
  Returns the list of experiences.

  ## Examples

      iex> list_experiences()
      [%Experience{}, ...]

  """
  def list_experiences do
    Repo.all(Experience)
  end

  @doc """
  Gets a single experience.

  Raises `Ecto.NoResultsError` if the Experience does not exist.

  ## Examples

      iex> get_experience!(123)
      %Experience{}

      iex> get_experience!(456)
      ** (Ecto.NoResultsError)

  """
  def get_experience!(id), do: Repo.get!(Experience, id)

  @doc """
  Creates a experience.

  ## Examples

      iex> create_experience(%{field: value})
      {:ok, %Experience{}}

      iex> create_experience(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_experience(%{
          title: String.t(),
          intro: String.t(),
          user_id: String.t(),
          email: String.t()
        }) :: {:ok, %Experience{}} | {:error, %Ecto.Changeset{}}
  def create_experience(attrs) do
    attrs =
      Map.put(
        attrs,
        :title,
        encode_title(attrs)
      )

    %Experience{}
    |> Experience.changeset(attrs)
    |> Repo.insert()
    |> decode_title()
  end

  def encode_title(%{title: title, email: email}) do
    "#{email}#{@title_modifier_string}#{title}"
  end

  def decode_title({:ok, %Experience{} = exp}) do
    {:ok, decode_title(exp)}
  end

  def decode_title(%Experience{title: encoded_title} = exp) do
    %{exp | title: decode_title(encoded_title)}
  end

  def decode_title(title) when is_binary(title) do
    String.split(title, @title_modifier_string) |> List.last()
  end

  def decode_title(arg) do
    arg
  end

  @doc """
  Updates a experience.

  ## Examples

      iex> update_experience(experience, %{field: new_value})
      {:ok, %Experience{}}

      iex> update_experience(experience, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_experience(%Experience{} = experience, attrs) do
    experience
    |> Experience.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Experience.

  ## Examples

      iex> delete_experience(experience)
      {:ok, %Experience{}}

      iex> delete_experience(experience)
      {:error, %Ecto.Changeset{}}

  """
  def delete_experience(%Experience{} = experience) do
    Repo.delete(experience)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking experience changes.

  ## Examples

      iex> change_experience(experience)
      %Ecto.Changeset{source: %Experience{}}

  """
  def change_experience(%Experience{} = experience) do
    Experience.changeset(experience, %{})
  end
end
