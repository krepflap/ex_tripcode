defmodule ExTripcode.Parser do
  @moduledoc false

  alias ExTripcode.Hasher

  @doc false
  def __parse__(input) do
    [user, password] = input |> String.split("#") |> Enum.slice(0..1)

    case password do
      "" -> %{user: user}
      _ -> %{user: user, code: Hasher.hash(password)}
    end
  end

  @doc false
  def __parse__(input, seed) do
    case input |> String.split("#") |> Enum.slice(0..2) do
      [""] ->
        %{user: ""}

      [user, ""] ->
        %{user: user}

      [user, password] ->
        %{user: user, code: Hasher.hash(password)}

      [user, "", ""] ->
        %{user: user}

      [user, "", secure_password] ->
        %{user: user, secure: Hasher.hash(secure_password, seed)}

      [user, password, secure_password] ->
        %{user: user, code: Hasher.hash(password), secure: Hasher.hash(secure_password, seed)}
    end
  end
end
