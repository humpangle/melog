defmodule Melog.ExperienceAPI do
  import Ecto.Query, warn: false
  import Melog.Experiences.Experience, only: [title_modifier_string: 0]
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
  def get_experience_by(%{title: _title, email: _email} = arg) do
    params = %{title: encode_title(arg)}

    params =
      if Map.has_key?(arg, :id) do
        Map.put(params, :id, arg.id)
      else
        params
      end

    get_experience_by(params)
  end

  def get_experience_by([title: title, email: email] = arg) do
    params = %{title: encode_title(%{title: title, email: email})}

    params =
      if Keyword.has_key?(arg, :id) do
        Map.put(params, :id, Keyword.get(arg, :id))
      else
        params
      end

    get_experience_by(params)
  end

  # We can not query experience by user's email. Email only used for title
  # transform
  def get_experience_by(%{email: _email} = params) do
    {_, params_} = Map.pop(params, :email)
    get_experience_by(params_)
  end

  def get_experience_by([email: _email] = params) do
    {_, params_} = Keyword.pop(params, :email)
    get_experience_by(params_)
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

  @doc """
  Make a title unique for a user by transforming the title with user's email.
  """
  @spec encode_title(%{title: String.t(), email: String.t()} | Map.t()) :: String.t()
  def encode_title(%{title: title, email: email}) do
    "#{email}#{title_modifier_string()}#{title}"
  end

  @doc """
  Given an experience whose title has been transformed using user's email,
  return the plain title (without email transform)
  """
  @spec decode_title({:ok, %Experience{}} | %Experience{} | String.t() | any) ::
          {:ok, %Experience{}} | %Experience{} | String.t() | any
  def decode_title({:ok, %Experience{} = exp}) do
    {:ok, decode_title(exp)}
  end

  def decode_title(%Experience{title: encoded_title} = exp) do
    %{exp | title: decode_title(encoded_title)}
  end

  def decode_title(title) when is_binary(title) do
    if String.contains?(title, title_modifier_string()) do
      String.split(title, title_modifier_string()) |> List.last()
    else
      title
    end
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
