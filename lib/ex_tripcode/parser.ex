defmodule ExTripcode.Parser do
  @moduledoc false

  alias ExTripcode.Hasher

  @doc """
  Parse string for user and tripcode password.
  """
  def __parse__(input) do
    [user, password] = input |> String.split("#") |> Enum.slice(0..1)

    case password do
      "" -> %{user: user}
      _ -> %{user: user, code: Hasher.__hash__(password)}
    end
  end

  @doc """
  Parse string for user and tripcode passwords, including the one for secure
  tripcodes.
  """
  def __parse__(input, seed) do
    case input |> String.split("#") |> Enum.slice(0..2) do
      [""] ->
        %{user: ""}

      [user, ""] ->
        %{user: user}

      [user, password] ->
        %{user: user, code: Hasher.__hash__(password)}

      [user, "", ""] ->
        %{user: user}

      [user, "", secure_password] ->
        %{user: user, secure: Hasher.__hash__(secure_password, seed)}

      [user, password, secure_password] ->
        %{
          user: user,
          code: Hasher.__hash__(password),
          secure: Hasher.__hash__(secure_password, seed)
        }
    end
  end
end
