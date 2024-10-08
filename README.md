# Scribe

> Pretty-print tables of Elixir structs and maps. Inspired by [hirb](https://github.com/cldwalker/hirb).

[![CI](https://github.com/codedge-llc/scribe/actions/workflows/ci.yml/badge.svg)](https://github.com/codedge-llc/scribe/actions/workflows/ci.yml)
[![Version](https://img.shields.io/hexpm/v/scribe.svg)](https://hex.pm/packages/scribe)
[![Total Downloads](https://img.shields.io/hexpm/dt/scribe.svg)](https://hex.pm/packages/scribe)
[![License](https://img.shields.io/hexpm/l/scribe.svg)](https://github.com/codedge-llc/scribe/blob/main/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/codedge-llc/scribe.svg)](https://github.com/codedge-llc/scribe/commits/main)
[![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/scribe/)

## Installation

1. Add `scribe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scribe, "~> 0.11"}
  ]
end
```

## Usage

Print a list of maps or structs as a table. Header columns are taken from the
keys of the first element.

```elixir
iex(1)> data = [%{key: "value", another_key: 123},
...(1)> %{key: "test", another_key: :key}]
iex(2)> Scribe.print(data)
+----------------+-------------+
| :another_key   | :key        |
+----------------+-------------+
| 123            | "value"     |
| :key           | "test"      |
+----------------+-------------+
```

Useful for printing large collections, such as results of database queries

```elixir
# %User{id: nil, email: nil}

iex(1)> User |> limit(5) |> Repo.all() |> Scribe.print()
+-------------+----------------------------+------+
| :__struct__ | :email                     | :id  |
+-------------+----------------------------+------+
| User        | "myles_fisher@beahan.com"  | 5171 |
| User        | "dawson_bartell@lynch.org" | 4528 |
| User        | "hassan1972@langworth.com" | 1480 |
| User        | "kiera.schulist@koch.com"  | 2084 |
| User        | "cynthia1970@mann.name"    | 6599 |
+-------------+----------------------------+------+
```

## Pagination

Scribe uses [pane](https://github.com/codedge-llc/pane) to paginate large tables.
Use with `Scribe.console/2`.

```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}
iex(1)> User |> limit(5) |> Repo.all |> Scribe.console

+-------------+------------------------+-------------+-------+------------+
| :__struct__ | :email                 | :first_name | :id   | :last_name |
+-------------+------------------------+-------------+-------+------------+
| User        | "celestine_satterfield | "Gene"      | 9061  | "Krajcik"  |
| User        | "lynn1978@bednar.org"  | "Maeve"     | 9865  | "Gerlach"  |
| User        | "melisa1975@hilll.biz" | "Theodora"  | 2262  | "Wunsch"   |
| User        | "furman.grady@ryan.org | "Oswaldo"   | 4977  | "Simonis"  |
| User        | "caesar_hirthe@reynold | "Arjun"     | 3907  | "Prohaska" |
+-------------+------------------------+-------------+-------+------------+


[1 of 1] (j)next (k)prev (q)quit
```

## Printing Custom Tables

`Scribe.print/2` takes a list of of columns on the `:data` options key to
customize output. You can use either the atom key or customize the header
with `{"Custom Title", :key}`.

```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}

User
|> limit(5)
|> Repo.all
|> Scribe.print(data: [{"ID", :id}, :first_name, :last_name])

+------+--------------+-------------+
| "ID" | :first_name  | :last_name  |
+------+--------------+-------------+
| 9061 | "Gene"       | "Krajcik"   |
| 9865 | "Maeve"      | "Gerlach"   |
| 2262 | "Theodora"   | "Wunsch"    |
| 4977 | "Oswaldo"    | "Simonis"   |
| 3907 | "Arjun"      | "Prohaska"  |
+------+--------------+-------------+
```

### Function Columns

You can specify functions that take the given row's struct or map as its only argument.

```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}
results =
  User
  |> limit(5)
  |> Repo.all
  |> Scribe.print(data: [{"ID", :id}, {"Full Name", fn(x) -> "#{x.last_name}, #{x.first_name}" end}])

+--------------------------+----------------------------------------------+
| "ID"                     | "Full Name"                                  |
+--------------------------+----------------------------------------------+
| 9061                     | "Krajcik, Gene"                              |
| 9865                     | "Gerlach, Maeve"                             |
| 2262                     | "Wunsch, Theodora"                           |
| 4977                     | "Simonis, Oswaldo"                           |
| 3907                     | "Prohaska, Arjun"                            |
+--------------------------+----------------------------------------------+

:ok
```

## Styling Options

### Width

Pass a `width` option to define table width.

```elixir
iex> Scribe.print(data, width: 80)

+-------------------+-----------------------------------------------------+
| :id               | :key                                                |
+-------------------+-----------------------------------------------------+
| 910               | "B1786AC67B4DEB19"                                  |
| 313               | "30CB8A2DE4750070"                                  |
| 25                | "D0859205FC7E7298"                                  |
| 647               | "8F0060AD0BD6AB04"                                  |
| 253               | "65509A684D619182"                                  |
+-------------------+-----------------------------------------------------+
```

### Disable Colors

```elixir
iex> Scribe.print(data, colorize: false)
```

### Text Alignment

Pass an `alignment` option of `:left`, `:center`, or `:right` for text alignment.
Defaults to `:left`.

```elixir
iex> Scribe.print(data, alignment: :center)

+------------------------------+------------+--------+
|            :body             |  :current  |  :id   |
+------------------------------+------------+--------+
|   "A rather short string."   |    true    |  1234  |
|   "A rather short string."   |   false    |  2222  |
|   "A rather short string."   |    true    |  4444  |
+------------------------------+------------+--------+
```

```elixir
iex> Scribe.print(data, alignment: :right)
+------------------------------+------------+--------+
|                        :body |   :current |    :id |
+------------------------------+------------+--------+
|     "A rather short string." |       true |   1234 |
|     "A rather short string." |      false |   2222 |
|     "A rather short string." |       true |   4444 |
+------------------------------+------------+--------+
```

### Styles

Scribe supports five styling formats natively, with support for custom adapters.

_Default_

```elixir
iex> Scribe.print(data, style: Scribe.Style.Default)

+-------+-----------------------------------+------------------------+
| :id   | :inserted_at                      | :key                   |
+-------+-----------------------------------+------------------------+
| 457   | "2017-03-27 14:42:34.095202Z"     | "CEB0E055ECDF6028"     |
| 326   | "2017-03-27 14:42:34.097519Z"     | "CF67027F7235B88D"     |
| 756   | "2017-03-27 14:42:34.097553Z"     | "DE016DFF477BEDDB"     |
| 484   | "2017-03-27 14:42:34.097572Z"     | "9194A82EF4BB0123"     |
| 780   | "2017-03-27 14:42:34.097591Z"     | "BF92748B4AAAF14A"     |
+-------+-----------------------------------+------------------------+
```

_Psql_

```elixir
iex> Scribe.print(data, style: Scribe.Style.Psql)

 :id   | :inserted_at                      | :key
-------+-----------------------------------+------------------------
 700   | "2017-03-27 14:41:33.411442Z"     | "A2FA80D0F6DF9388"
 890   | "2017-03-27 14:41:33.412955Z"     | "F95094328A91D950"
 684   | "2017-03-27 14:41:33.412991Z"     | "1EAC6B28045ED644"
 531   | "2017-03-27 14:41:33.413015Z"     | "DC2377B696355642"
 648   | "2017-03-27 14:41:33.413037Z"     | "EA9311B4683A52B3"
```

_Github Markdown_

```elixir
iex> Scribe.print(data, style: Scribe.Style.GithubMarkdown)

| :id   | :inserted_at                      | :key                   |
|-------|-----------------------------------|------------------------|
| 457   | "2017-03-27 14:42:34.095202Z"     | "CEB0E055ECDF6028"     |
| 326   | "2017-03-27 14:42:34.097519Z"     | "CF67027F7235B88D"     |
| 756   | "2017-03-27 14:42:34.097553Z"     | "DE016DFF477BEDDB"     |
| 484   | "2017-03-27 14:42:34.097572Z"     | "9194A82EF4BB0123"     |
| 780   | "2017-03-27 14:42:34.097591Z"     | "BF92748B4AAAF14A"     |
```

_Pseudo_

```elixir
iex> Scribe.print(data, style: Scribe.Style.Pseudo)

┌───────┬───────────────────────────────────┬────────────────────────┐
│ :id   │ :inserted_at                      │ :key                   │
├───────┼───────────────────────────────────┼────────────────────────┤
│ 457   │ "2017-03-27 14:42:34.095202Z"     │ "CEB0E055ECDF6028"     │
│ 326   │ "2017-03-27 14:42:34.097519Z"     │ "CF67027F7235B88D"     │
│ 756   │ "2017-03-27 14:42:34.097553Z"     │ "DE016DFF477BEDDB"     │
│ 484   │ "2017-03-27 14:42:34.097572Z"     │ "9194A82EF4BB0123"     │
│ 780   │ "2017-03-27 14:42:34.097591Z"     │ "BF92748B4AAAF14A"     │
└───────┴───────────────────────────────────┴────────────────────────┘
```

_NoBorder_

```elixir
iex> Scribe.print(data, style: Scribe.Style.NoBorder)

 :id    :inserted_at                       :key
 457    "2017-03-27 14:42:34.095202Z"      "CEB0E055ECDF6028"
 326    "2017-03-27 14:42:34.097519Z"      "CF67027F7235B88D"
 756    "2017-03-27 14:42:34.097553Z"      "DE016DFF477BEDDB"
 484    "2017-03-27 14:42:34.097572Z"      "9194A82EF4BB0123"
 780    "2017-03-27 14:42:34.097591Z"      "BF92748B4AAAF14A"
```

Set a default one in your config if you like:

```elixir
config :scribe, style: Scribe.Style.Psql
```

## Contributing

### Testing

Unit tests can be run with `mix test` or `mix coveralls.html`.

### Formatting

This project uses Elixir's `mix format` and [Prettier](https://prettier.io) for formatting.
Add hooks in your editor of choice to run it after a save. Be sure it respects this project's
`.formatter.exs`.

### Commits

Git commit subjects use the [Karma style](http://karma-runner.github.io/5.0/dev/git-commit-msg.html).

## License

Copyright (c) 2016-2024 Codedge LLC (https://www.codedge.io/)

This library is MIT licensed. See the [LICENSE](https://github.com/codedge-llc/scribe/blob/main/LICENSE) for details.
