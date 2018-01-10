defmodule MelogWeb.UserSerializer do
  @moduledoc false

  use Guardian, otp_app: :melog

  alias Melog.Accounts

  def subject_for_token(%{email: email}, _claims) do
    {:ok, email}
  end
  def subject_for_token(_, _) do
    {:error, "Unknown resource type"}
  end

  def resource_from_claims(%{"sub" => email} = _claims) do
    {:ok, Accounts.get_user_by(email: email)}
  end
  def resource_from_claims(_) do
    {:error, "Unknown resource type"}
  end

  def auth_error(_conn, _params, _opts) do
    %{errors: "Invalid email/username or password"}
  end
end