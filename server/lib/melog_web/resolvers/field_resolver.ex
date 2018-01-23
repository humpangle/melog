defmodule MelogWeb.FieldResolver do
  alias MelogWeb.ResolversUtil
  alias Melog.FieldApi, as: Api
  alias Melog.Experiences.{Field}

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
    %Field{
      name: name,
      field_type: original_type
    } = field = Api.get_field!(id)

    if field_type == original_type do
      store_a_value(field, Map.put(%{}, field_type, value))
    else
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

  def field(
        _root,
        %{field: inputs},
        %{context: %{current_user: user}} = _info
      ) do
    get_field(user.id, inputs)
  end

  def field(_root, %{field: %{jwt: _} = inputs}, _info) do
    {jwt, inputs_} = Map.pop(inputs, :jwt)

    case ResolversUtil.user_from_token(jwt) do
      {:tokenerror, error} ->
        error

      {:ok, user} ->
        get_field(user.id, inputs_)
    end
  end

  def field(_, _, _) do
    ResolversUtil.unauthorized()
  end

  defp get_field(user_id, %{id: id} = _inputs) do
    case Api.get_field_for_user(user_id, id) do
      nil -> ResolversUtil.unauthorized()
      field -> {:ok, field}
    end
  end

  def fields(
        _root,
        _inputs,
        %{context: %{current_user: user}} = _info
      ) do
    get_fields(user.id)
  end

  def fields(_root, %{field: %{jwt: jwt} = _inputs}, _info) do
    case ResolversUtil.user_from_token(jwt) do
      {:tokenerror, error} ->
        error

      {:ok, user} ->
        get_fields(user.id)
    end
  end

  def fields(_, _, _) do
    ResolversUtil.unauthorized()
  end

  defp get_fields(user_id) do
    {:ok, Api.get_fields_for_user(user_id)}
  end

  def create_experience_fields_collection(
        _root,
        %{experience_fields: inputs},
        %{context: %{current_user: user}} = _info
      ) do
    create_collection(inputs, user)
  end

  def create_experience_fields_collection(
        _root,
        %{experience_fields: %{jwt: _} = inputs},
        _info
      ) do
    {jwt, inputs_} = Map.pop(inputs, :jwt)

    case ResolversUtil.user_from_token(jwt) do
      {:tokenerror, error} ->
        error

      {:ok, user} ->
        create_collection(inputs_, user)
    end
  end

  def create_experience_fields_collection(_, _inputs, _) do
    ResolversUtil.unauthorized()
  end

  defp create_collection(
         %{
           experience: experience,
           fields: _fields
         } = inputs,
         %{id: user_id}
       ) do
    inputs_ =
      Map.put(
        inputs,
        :experience,
        Map.put(experience, :user_id, user_id)
      )

    case Api.create_experience_fields_collection(inputs_) do
      {:ok, result} ->
        {experience, result_} = Map.pop(result, :experience)
        fields = Enum.reduce(result_, [], fn {_, v}, acc -> [v | acc] end)
        {:ok, %{experience: experience, fields: fields}}

      {:error, failed_operation, changeset, _success} ->
        changeset_string = ResolversUtil.changeset_errors_to_string(changeset)

        {
          :error,
          message: "{name: #{failed_operation}, error: #{changeset_string}}"
        }
    end
  end
end
