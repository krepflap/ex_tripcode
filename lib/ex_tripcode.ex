defmodule ExTripcode do
  @moduledoc """
  This module provides functions to generate and parse tripcodes.
  """

  alias ExTripcode.Hasher
  alias ExTripcode.Parser

  @doc """
  Takes a string value as input and transforms it into a tripcode.
  When specifying a salt, we use this to generate a secure tripcode.

  Returns a string containing the tripcode.

  ## Examples

      iex> ExTripcode.hash("elixir")
      "H3R1pplX/."

  """
  def hash(""), do: ""
  def hash(input), do: Hasher.hash(input)
  def hash("", _), do: ""
  def hash(input, salt), do: Hasher.hash(input, salt)
end
