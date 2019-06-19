defmodule ExTripcode.Hasher do
  @moduledoc false

  @doc false
  def __hash__(input) do
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

  @doc false
  def __hash__(input, seed) do
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

  defp salt_replace(":"), do: "A"
  defp salt_replace(";"), do: "B"
  defp salt_replace("<"), do: "C"
  defp salt_replace("="), do: "D"
  defp salt_replace(">"), do: "E"
  defp salt_replace("?"), do: "F"
  defp salt_replace("@"), do: "G"
  defp salt_replace("["), do: "a"
  defp salt_replace("\\"), do: "b"
  defp salt_replace("]"), do: "c"
  defp salt_replace("^"), do: "d"
  defp salt_replace("_"), do: "e"
  defp salt_replace("`"), do: "f"
  defp salt_replace(char), do: char
end
