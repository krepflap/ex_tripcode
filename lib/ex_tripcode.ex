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

      iex> ExTripcode.hash("elixir")
      "H3R1pplX/."

  """
  def hash(""), do: ""
  def hash(input), do: gen_tripcode(input)
  def hash("", _), do: ""
  def hash(input, salt), do: gen_tripcode(input, salt)

  defp calc_salt(input) do
    (input <> "H..")
    |> String.slice(1..2)
    |> String.replace(~r/[^\.-z]/, ".")
    |> String.graphemes()
    |> Enum.map_join(&salt_replace/1)
    |> String.pad_trailing(2, <<0>>)
  end

  defp gen_tripcode(input) do
    converted =
      input
      |> String.slice(0..7)
      |> to_shift_jis()
      |> html_escape()

    salt = calc_salt(converted)

    converted
    |> String.pad_trailing(8, <<0>>)
    |> Crypt3.crypt(salt)
    |> String.slice(-10..-1)
  end

  defp gen_tripcode(input, salt) do
    input
    |> to_shift_jis()
  end

  defp html_escape(input) do
    input
    |> String.replace("&", "&amp;")
    |> String.replace(~S("), "&quot;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
  end

  defp to_shift_jis(input) do
    input
    |> String.graphemes()
    |> Enum.map_join(fn x ->
      case :iconv.convert("utf-8", "shift-jis", x) do
        "" -> "?"
        y -> y
      end
    end)
  end

  defp salt_replace(char) do
    case char do
      ":" -> "A"
      ";" -> "B"
      "<" -> "C"
      "=" -> "D"
      ">" -> "E"
      "?" -> "F"
      "@" -> "G"
      "[" -> "a"
      "\\" -> "b"
      "]" -> "c"
      "^" -> "d"
      "_" -> "e"
      "`" -> "f"
      _ -> char
    end
  end
end
