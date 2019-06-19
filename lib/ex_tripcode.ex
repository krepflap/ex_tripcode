defmodule ExTripcode do
  @moduledoc """
  This module provides functions to generate and parse tripcodes.
  """

  alias ExTripcode.Hasher
  alias ExTripcode.Parser

  @doc """
  Takes a string value as input and transforms it into a tripcode.
  When specifying a seed, we use this to generate a secure tripcode.

  Returns a string containing the tripcode.

  ## Examples

      iex> ExTripcode.hash("elixir")
      "H3R1pplX/."

      iex> ExTripcode.hash("elixir", "secret")
      "KZ1B7o9AtcJD9XQ"

  """
  def hash(""), do: ""
  def hash(input), do: Hasher.hash(input)
  def hash("", _), do: ""
  def hash(input, seed), do: Hasher.hash(input, seed)

  @doc """
  Parses a user and tripcode string, in the form of "user#tripcode".

  To also parse for secure tripcodes in the form of "user#tripcode#secure"
  you need provide a secret seed you store only on the server and keep
  hidden from your users.

  Returns a map containing key-values for all values that are found.

  ## Examples

      iex> ExTripcode.parse("User#elixir#elixir", "secret")
      %{user: "User", code: "H3R1pplX/.", secure: "KZ1B7o9AtcJD9XQ"}

      iex> ExTripcode.parse("User##elixir", "secret")
      %{user: "User", secure: "KZ1B7o9AtcJD9XQ"}

      iex> ExTripcode.parse("User#elixir", "secret")
      %{user: "User", code: "H3R1pplX/."}

      iex> ExTripcode.parse("User#elixir")
      %{user: "User", code: "H3R1pplX/."}

  """
  def parse(""), do: {}
  def parse(input), do: Parser.parse(input)
  def parse("", _), do: {}
  def parse(input, seed), do: Parser.parse(input, seed)
end
