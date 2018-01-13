defmodule MelogWeb.ExperienceResolver do
  alias Melog.ExperienceAPI, as: Api
  alias MelogWeb.ResolversUtil
  alias Melog.Experiences.Experience

  @doc """
  Create an experience for an authenticated user.
  """
  @spec create_experience(
          any,
          %{
            experience:
              %{
                title: String.t(),
                intro: String.t()
              }
              | %{
                  title: String.t(),
                  intro: String.t(),
                  jwt: String.t()
                }
              | %{
                  title: String.t()
                }
              | %{
                  title: String.t(),
                  jwt: String.t()
                }
          },
          any
        ) :: {:ok, %Experience{}} | {:error, message: String.t()}
  def create_experience(
        _root,
        %{experience: inputs},
        %{context: %{current_user: user}} = _info
      ) do
    update_create_experience_inputs(inputs, user)
    |> create_an_experience()
  end

  def create_experience(_root, %{experience: %{jwt: _} = inputs}, _info) do
    {jwt, inputs_} = Map.pop(inputs, :jwt)

    case ResolversUtil.user_from_token(jwt) do
      {:tokenerror, error} ->
        error

      {:ok, user} ->
        update_create_experience_inputs(inputs_, user)
        |> create_an_experience()
    end
  end

  def create_experience(_, _, _) do
    ResolversUtil.unauthorized()
  end

  defp update_create_experience_inputs(inputs, %{id: id}) do
    Enum.into(inputs, %{user_id: id})
  end

  defp create_an_experience(%{user_id: _} = inputs) do
    case Api.create_experience(inputs) do
      {:ok, exp} ->
        {:ok, exp}

      {:error, changeset} ->
        {
          :error,
          message: ResolversUtil.changeset_errors_to_string(changeset)
        }
    end
  end

  @doc """
  Get an experience either by id or title or both for only authenticated user.
  """
  @spec experience(
          any,
          %{
            experience:
              %{
                id: String.t()
              }
              | %{
                  id: String.t(),
                  title: String.t()
                }
              | %{
                  title: String.t()
                }
          },
          any
        ) :: {:ok, %Experience{}} | {:error, message: String.t()}
  def experience(
        _root,
        %{experience: inputs},
        %{context: %{current_user: user}} = _info
      ) do
    get_an_experience(user, inputs)
  end

  def experience(_root, %{experience: %{jwt: jwt} = inputs}, _info) do
    case ResolversUtil.user_from_token(jwt) do
      {:ok, user} -> get_an_experience(user, inputs)
      {:tokenerror, error} -> error
    end
  end

  def experience(_, _, _) do
    ResolversUtil.unauthorized()
  end

  defp get_an_experience(user, inputs) do
    # jwt is not a field on experience
    {_, inputs_} = Map.put(inputs, :user_id, user.id) |> Map.pop(:jwt)

    case Api.get_experience_by(inputs_) do
      nil -> {:error, message: "Experience not found."}
      exp -> {:ok, exp}
    end
  end

  @doc """
  Get experiences created by an authenticated user.
  """
  @spec experiences(
          any,
          %{
            experience: %{jwt: String.t()} | %{}
          },
          any
        ) :: {:ok, [%Experience{}]} | {:error, message: String.t()}
  def experiences(
        _root,
        %{experience: _inputs},
        %{context: %{current_user: user}} = _info
      ) do
    get_experiences(user)
  end

  def experiences(
        _root,
        _inputs,
        %{context: %{current_user: user}} = _info
      ) do
    get_experiences(user)
  end

  def experiences(_root, %{experience: %{jwt: jwt} = _inputs}, _info) do
    case ResolversUtil.user_from_token(jwt) do
      {:ok, user} -> get_experiences(user)
      {:tokenerror, error} -> error
    end
  end

  def experiences(_, _, _) do
    ResolversUtil.unauthorized()
  end

  defp get_experiences(user, _inputs \\ nil) do
    {:ok, Api.list_experiences(%{user_id: user.id})}
  end
end
