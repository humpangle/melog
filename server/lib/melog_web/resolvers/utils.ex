defmodule MelogWeb.ResolversUtil do
  @moduledoc """
  Helper utilities for resolvers
  """
  alias Phoenix.View
  alias MelogWeb.ChangesetView

  @doc """
  Takes a changeset error and converts it to a string
  """
  @spec changeset_errors_to_string(%Ecto.Changeset{}) :: String.t
  def changeset_errors_to_string(%Ecto.Changeset{} =  changeset) do
    Enum.map_join(
      View.render(ChangesetView, "error.json", changeset: changeset)[:errors],
      " | ",
      fn({k, v}) ->
        value = Enum.join(v, ",")
        "#{k}: #{value}"
      end)
  end
end