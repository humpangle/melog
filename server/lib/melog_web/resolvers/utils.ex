defmodule MelogWeb.ResolversUtil do
  @moduledoc """
  Helper utilities for resolvers
  """
  alias Phoenix.View
  alias MelogWeb.ChangesetView
  alias Melog.Accounts.User
  alias MelogWeb.UserSerializer

  @unauthorized "Unauthorized"

  @doc """
  Takes a changeset error and converts it to a string
  """
  @spec changeset_errors_to_string(%Ecto.Changeset{}) :: String.t()
  def changeset_errors_to_string(%Ecto.Changeset{} = changeset) do
    Enum.map_join(
      View.render(ChangesetView, "error.json", changeset: changeset)[:errors],
      " | ",
      fn {k, v} ->
        value = Enum.join(v, ",")
        "#{k}: #{value}"
      end
    )
  end

  def unauthorized do
    {:error, message: @unauthorized}
  end

  def user_from_token(token) do
    error = {:tokenerror, unauthorized()}

    case UserSerializer.resource_from_token(token) do
      {:ok, %User{} = user, _claims} -> {:ok, user}
      {:ok, nil, _claims} -> error
      _ -> error
    end
  end
end
