# ExTripcode

Elixir library for generating tripcodes.

From [the full wiki](http://www.thefullwiki.org/Tripcode):

>A tripcode is a means of telecommunication authentication that does not require
>registration. Tripcodes are most often used in 2channel-style message boards or
>Futaba Channel-style imageboards. A tripcode is a hashed password by which a
>person can be identified by others.

## Installation

The package can be installed by adding `ex_tripcode` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_tripcode, "~> 0.1.0"},
  ]
end
```

## Usage

### Generating Tripcodes

Most simple usage:

```elixir
iex> ExTripcode.hash("elixir")
"..."
```

Secure Tripcodes work too, just pass in a secret salt:

```elixir
iex> salt = "secret"
iex> ExTripcode.hash("elixir", salt)
"..."
```

### Parsing user strings

You can also parse a user string straight away. Note that if you don't pass
a salt, it will only parse for regular Tripcodes, not Secure Tripcodes.

```elixir
iex> salt = "secret"
iex> ExTripcode.parse("User#elixir#elixir", salt)
{user: "User", code: "...", secure: "..."}

iex> ExTripcode.parse("User##elixir", salt)
{user: "User", code: "", secure: "..."}

iex> ExTripcode.parse("User#elixir", salt)
{user: "User", code: ""}

iex> ExTripcode.parse("User#elixir")
{user: "User", code: ""}
```

## Links

* https://github.com/justinjensen/tripcode
* https://github.com/Nepeta/tripcode
* http://www.thefullwiki.org/Tripcode
* https://www.4chan.org/faq#trip

## License

MIT.
