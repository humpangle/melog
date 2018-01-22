defmodule Melog.ExperienceAPI do
  import Ecto.Query, warn: false
  alias Melog.Repo
  alias Melog.Experiences.Experience

  @doc """
  Returns the list of experiences.

  ## Examples

      iex> list_experiences()
      [%Experience{}, ...]

  """
  def list_experiences(params \\ nil) do
    if params == nil do
      Repo.all(Experience)
    else
      query = from(exp in Experience)

      query =
        if Map.has_key?(params, :user_id) do
          user_id = params.user_id
          from(q in query, where: q.user_id == ^user_id)
        else
          query
        end

      Repo.all(query)
    end
  end

  @doc """
  Gets a single experience.

  Returns `nil` if the Experience does not exist.

  ## Examples

      iex> get_experience_by(id: 123)
      %Experience{}

      iex> get_experience_by(title: "non existing title")
      ** nil

  """
  def get_experience_by(%{title: _title, user_id: _user_id} = arg) do
    Repo.get_by(Experience, arg)
  end

  def get_experience_by([title: _title, user_id: _user_id] = arg) do
    Repo.get_by(Experience, arg)
  end

  # If we query by title without user_id, we simply return nil
  def get_experience_by(%{title: _title}) do
    nil
  end

  def get_experience_by(title: _title) do
    nil
  end

  def get_experience_by(params) do
    Repo.get_by(Experience, params)
  end

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
          user_id: String.t()
        }) :: {:ok, %Experience{}} | {:error, %Ecto.Changeset{}}
  def create_experience(attrs) do
    %Experience{}
    |> Experience.changeset(attrs)
    |> Repo.insert()
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
  def change_experience(%Experience{} = experience, attrs = %{}) do
    Experience.changeset(experience, attrs)
  end
end
