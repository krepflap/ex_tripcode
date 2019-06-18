defmodule ExTripcode.Hasher do
  @moduledoc """
  This module implements the hashing of values to generate tripcodes.
  """

  @doc """
  Generate a regular tripcode.

  Regular tripcodes are generated as follows:

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
  def hash(input) do
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

  @doc """
  Generate a secure tripcode.

  Secure tripcodes are generated as follows:

  1. Convert the input to Shift JIS.
  2. Create a hash by taking the SHA1 sum of input & the base64 decoded seed.
  3. Base64 encode this hash.
  4. Return the first 15 characters.

  """
  def hash(input, seed) do
    converted = to_shift_jis(input)
    salt = Base.decode64!(seed, padding: false)

    :crypto.hash(:sha, converted <> salt)
    |> Base.encode64()
    |> String.slice(0..14)
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

  defp calc_salt(input) do
    (input <> "H..")
    |> String.slice(1..2)
    |> String.replace(~r/[^\.-z]/, ".")
    |> String.graphemes()
    |> Enum.map_join(&salt_replace/1)
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
