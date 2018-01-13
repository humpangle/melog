defmodule MelogWeb.FieldResolver do
  alias MelogWeb.ResolversUtil
  alias Melog.FieldApi, as: Api

  def create_field(
        _root,
        %{field: inputs},
        %{context: %{current_user: _}} = _info
      ) do
    create_a_field(inputs)
  end

  def create_field(_root, %{field: %{jwt: _} = inputs}, _info) do
    {jwt, inputs_} = Map.pop(inputs, :jwt)

    case ResolversUtil.user_from_token(jwt) do
      {:tokenerror, error} ->
        error

      {:ok, _user} ->
        create_a_field(inputs_)
    end
  end

  def create_field(_, _, _) do
    ResolversUtil.unauthorized()
  end

  defp create_a_field(%{experience_id: _} = inputs) do
    case Api.create_field(inputs) do
      {:ok, field} ->
        {:ok, field}

      {:error, changeset} ->
        {
          :error,
          message: ResolversUtil.changeset_errors_to_string(changeset)
        }
    end
  end
end
