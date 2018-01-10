defmodule MelogWeb.Schema.Types do
  @moduledoc """
  Custom types (scalars, objects and input types) shared among schema types
  """
  use Absinthe.Schema.Notation

  scalar :iso_datetime, name: "ISODatime" do
    parse &parse_iso_datetime/1
    serialize &Timex.format!(&1, "{ISO:Extended:Z}")
  end


  @spec parse_iso_datetime(Absinthe.Blueprint.Input.String.t) ::
    {:ok, DateTime.t | NaiveDateTime.t} | :error
  @spec parse_iso_datetime(Absinthe.Blueprint.Input.Null.t) :: {:ok, nil}
  defp parse_iso_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case Timex.parse(value, "{ISO:Extended:Z}") do
      {:ok, val, _} -> {:ok, val}
      {:error, _} -> :error
      _error -> :error
    end
  end
  defp parse_iso_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end
  defp parse_iso_datetime(_) do
    :error
  end
end
