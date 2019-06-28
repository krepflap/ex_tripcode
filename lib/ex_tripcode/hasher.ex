defmodule ExTripcode.Hasher do
  @moduledoc false

  @doc """
  Generate regular tripcode.
  """
  def __hash__(input) do
    escape = fn x -> for <<c <- x>>, do: html_escape(c), into: "" end

    converted =
      input
      |> String.slice(0..7)
      |> to_shift_jis()
      |> escape.()

    salt = calc_salt(converted)

    converted
    |> String.pad_trailing(8, <<0>>)
    |> Crypt3.crypt(salt)
    |> String.slice(-10..-1)
  end

  @doc """
  Generate secure tripcode.
  """
  def __hash__(input, seed) do
    converted = to_shift_jis(input)
    salt = Base.decode64!(seed, padding: false)

    :crypto.hash(:sha, converted <> salt)
    |> Base.encode64()
    |> String.slice(0..14)
  end

  defp to_shift_jis(input) do
    convert = fn x ->
      case :iconv.convert("utf-8", "shift-jis", <<x::utf8>>) do
        "" -> "?"
        c -> c
      end
    end

    for <<c::utf8 <- input>>, do: convert.(c), into: ""
  end

  defp calc_salt(input) do
    replace = fn x -> for <<c <- x>>, do: salt_replace(c), into: "" end
    (input <> "H..") |> String.slice(1..2) |> replace.()
  end

  defp html_escape(?&), do: "&amp;"
  defp html_escape(?"), do: "&quot;"
  defp html_escape(?<), do: "&lt;"
  defp html_escape(?>), do: "&gt;"
  defp html_escape(c), do: <<c>>

  # Replace characters not between . and z
  defp salt_replace(c) when c < ?. or c > ?z, do: "."
  # Replace characters in :;<=>?@[\]^_` with the corresponding character
  # from ABCDEFGabcdef
  defp salt_replace(?:), do: "A"
  defp salt_replace(?;), do: "B"
  defp salt_replace(?<), do: "C"
  defp salt_replace(?=), do: "D"
  defp salt_replace(?>), do: "E"
  defp salt_replace(??), do: "F"
  defp salt_replace(?@), do: "G"
  defp salt_replace(?[), do: "a"
  defp salt_replace(?\\), do: "b"
  defp salt_replace(?]), do: "c"
  defp salt_replace(?^), do: "d"
  defp salt_replace(?_), do: "e"
  defp salt_replace(?`), do: "f"
  defp salt_replace(c), do: <<c>>
end
