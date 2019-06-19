defmodule ExTripcode do
  @moduledoc ~S"""
  This module provides functions to generate and parse tripcodes.

  Regular tripcodes are generated as follows:

  1. Convert the input to Shift JIS.
  2. Generate the salt as follows:
     * Take the second and third characters of the string obtained by appending
       `H..` to the end of the input.
     * Replace any characters not between `.` and `z` with `.`.
     * Replace any of the characters in **:;<=>?@[\\]^_\`** with the corresponding
       character from **ABCDEFGabcdef**.
  3. Call the `crypt()` function with the input and salt.
  4. Return the last 10 characters. (compressional data harvest)

  Secure tripcodes are generated as follows:

  1. Convert the input to Shift JIS.
  2. Create a hash by taking the SHA1 sum of input & the base64 decoded seed.
  3. Base64 encode this hash.
  4. Return the first 15 characters.

  """

  alias ExTripcode.Hasher
  alias ExTripcode.Parser

  @doc """
  Takes a string value as input and transforms it into a tripcode.

  Returns a string containing the tripcode.

  ## Examples

      iex> ExTripcode.hash("elixir")
      "H3R1pplX/."

  """
  def hash(""), do: ""
  def hash(input), do: Hasher.__hash__(input)

  @doc """
  Takes a string value as input, with a secret seed and transforms it into a
  secure tripcode.

  Returns a string containing the tripcode.

  ## Examples

      iex> ExTripcode.hash("elixir", "secret")
      "KZ1B7o9AtcJD9XQ"

  """
  def hash("", _), do: ""
  def hash(input, seed), do: Hasher.__hash__(input, seed)

  @doc """
  Parses a user and tripcode string, in the form of `user#tripcode`.

  Returns a map containing key-values for all values that are found.

  Note: The user can be an empty string, this is valid.

  ## Examples

      iex> ExTripcode.parse("User#elixir")
      %{user: "User", code: "H3R1pplX/."}

  """
  def parse(""), do: %{user: ""}
  def parse(input), do: Parser.__parse__(input)

  @doc """
  Parses for (secure) tripcodes in the form of `user#tripcode#secure`.
  You need to provide a secret seed you store only on the server and keep
  hidden from your users.

  Returns a map containing key-values for all values that are found.

  Note: The user can be an empty string, this is valid.

  ## Examples

      iex> ExTripcode.parse("User#elixir#elixir", "secret")
      %{user: "User", code: "H3R1pplX/.", secure: "KZ1B7o9AtcJD9XQ"}

      iex> ExTripcode.parse("User##elixir", "secret")
      %{user: "User", secure: "KZ1B7o9AtcJD9XQ"}

      iex> ExTripcode.parse("User#elixir", "secret")
      %{user: "User", code: "H3R1pplX/."}

  """
  def parse("", _), do: %{user: ""}
  def parse(input, seed), do: Parser.__parse__(input, seed)
end
