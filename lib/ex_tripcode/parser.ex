defmodule ExTripcode.Parser do
  @moduledoc """
  This module implements the parsing of user/password strings containing
  tripcodes.

  It is provided as a convience for parsing your user input.

  Returns a map containing user and tripcode values.
  """

  alias ExTripcode.Hasher

  @doc """
  Parse a string for user and tripcode values.

  Everything before the "#" symbol is user, after is the password for the
  tripcode. We don't check for a second password for secure tripcodes,
  since no seed was specified.

  Returns a map containing the values user and tripcode.

  Note: The user can be an empty string, this is valid.

  ## Examples

      iex> ExTripcode.Parser.parse("#elixir")
      %{user: "", code: "H3R1pplX/."}

      iex> ExTripcode.Parser.parse("Joe")
      %{user: "Joe"}

  """
  def parse(input) do
    [user, password] = String.split(input, "#", parts: 2)

    case password do
      "" -> %{user: user}
      _ -> %{user: user, code: Hasher.hash(password)}
    end
  end

  @doc """
  Parse a string for user and tripcode values.

  We check for a second password to generate a secure tripcode.

  Returns a map containing the values user and both tripcodes.
  If the first password was omitted, only the secure tripcode value is
  returned.

  """
  def parse(input, seed) do
    case String.split(input, "#", parts: 3) do
      [""] ->
        %{user: ""}

      [user, ""] ->
        %{user: user}

      [user, password] ->
        %{user: user, code: Hasher.hash(password)}

      [user, "", secure_password] ->
        %{user: user, secure: Hasher.hash(secure_password, seed)}

      [user, password, secure_password] ->
        %{user: user, code: Hasher.hash(password), secure: Hasher.hash(secure_password, seed)}
    end
  end
end
