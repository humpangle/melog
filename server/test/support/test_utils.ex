defmodule Melog.TestUtils do
  @moduledoc """
  Test utilities
  """

  @utc_tz "Etc/UTC"
  @iso_extended "{ISO:Extended:Z}"

  @doc """
  Convert a Timex utc to local time zone
  """
  def timex_ecto_date_to_local_datime_tz(date) do
    date
    |> Timex.to_datetime(@utc_tz)
    |> Timex.to_datetime(Timex.Timezone.local())
  end
end