defmodule MelogWeb.ExperienceResolver do
  @unauthorized "Unauthorized"

  alias Melog.ExperienceAPI, as: Api
  alias MelogWeb.ResolversUtil
  alias MelogWeb.UserSerializer

  @doc """
  Create an experience for an authenticated user.
  """
  def create_experience(
        _root,
        %{experience: inputs},
        %{context: %{current_user: user}} = _info
      ) do
    create_experience(create_experience(inputs, user))
  end

  def create_experience(_root, %{experience: %{jwt: _} = inputs}, _info) do
    {jwt, inputs_} = Map.pop(inputs, :jwt)

    case UserSerializer.resource_from_token(jwt) do
      {:ok, nil, _claims} ->
        {:error, message: @unauthorized}

      {:ok, user, _claims} ->
        create_experience(create_experience(inputs_, user))
    end
  end

  def create_experience(_, _, _) do
    {:error, message: @unauthorized}
  end

  defp create_experience(inputs, %{email: email, id: id}) do
    Enum.into(inputs, %{email: email, user_id: id})
  end

  defp create_experience(%{email: _, user_id: _} = inputs) do
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
end
