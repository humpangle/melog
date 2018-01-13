defmodule MelogWeb.FieldResolver do
  alias MelogWeb.ResolversUtil
  alias Melog.FieldApi, as: Api
  alias Melog.Experiences.Field

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

  def store_value(
        _root,
        %{data: inputs},
        %{context: %{current_user: _}} = _info
      ) do
    store_a_value(inputs)
  end

  def store_value(_root, %{data: %{jwt: _} = inputs}, _info) do
    {jwt, inputs_} = Map.pop(inputs, :jwt)

    case ResolversUtil.user_from_token(jwt) do
      {:tokenerror, error} ->
        error

      {:ok, _user} ->
        store_a_value(inputs_)
    end
  end

  def store_value(_, _, _) do
    ResolversUtil.unauthorized()
  end

  defp store_a_value(%{id: id, field_type: field_type, value: value}) do
    %Field{name: name} = field = Api.get_field!(id)

    case field_type do
      type_ when is_atom(type_) ->
        store_a_value(field, Map.put(%{}, type_, value))

      _ ->
        {:error, message: "Can not update value for field " <> name}
    end
  end

  defp store_a_value(%Field{} = field, params) do
    case Api.update_field(field, params) do
      {:ok, data} ->
        {:ok, data}

      {:error, changeset} ->
        {
          :error,
          message: ResolversUtil.changeset_errors_to_string(changeset)
        }
    end
  end
end
