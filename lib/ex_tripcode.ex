defmodule ExTripcode do
  @moduledoc """
  This module provides functions to generate and parse tripcodes.

  Tripcodes are generated as follows:

  1. Convert the input to Shift JIS.
  2. Generate the salt as follows:
     a. Take the second and third characters of the string obtained by appending
        H.. to the end of the input.
     b. Replace any characters not between . and z with ..
     c. Replace any of the characters in :;<=>?@[\]^_` with the corresponding
        character from ABCDEFGabcdef.
  3. Call the crypt() function with the input and salt.
  4. Return the last 10 characters. (compressional data harvest)
  """

  @doc """
  Takes a string value as input and transforms it into a tripcode.
  When specifying a salt, we use this to generate the tripcode instead of
  calculating the salt.

  Returns a string containing the tripcode.

  ## Examples

      iex> ExTripcode.hash("廨A齬ﾙｲb")
      "sTrIKeleSs"

  """
  def hash(input), do: gen_tripcode(input)
  def hash(input, salt), do: gen_tripcode(input, salt)

  defp calc_salt(input) do
    input
  end

  defp gen_tripcode(input) do
    jis = to_shift_jis(input)
    salt = calc_salt(jis)

    jis
    |> Crypt3.crypt(salt)
    |> String.slice(-10..-1)
    |> String.trim
  end

  defp gen_tripcode(input, salt) do
    input
    |> to_shift_jis()
    |>
  end

  defp to_shift_jis(input), do: :iconv.convert("utf-8", "shift-jis", input)
end
