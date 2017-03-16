[![Build Status](https://travis-ci.org/codedge-llc/scribe.svg?branch=master)](https://travis-ci.org/codedge-llc/scribe)
[![Hex.pm](http://img.shields.io/hexpm/v/scribe.svg)](https://hex.pm/packages/scribe)
# Scribe

Pretty-print tables of Elixir structs and maps. Inspired by [hirb](https://github.com/cldwalker/hirb).

## Installation

  1. Add `scribe` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:scribe, "~> 0.4.0"}]
  end
  ```

## Usage

Print a list of maps as a table. Header columns are taken from the map keys of the first element.
```elixir
iex(1)> data = [%{key: "value", another_key: 123}, %{key: "test", another_key: :key}]
iex(2)> Scribe.print(data)
+----------------------------------------+--------------------------------+
| :another_key                           | :key                           |
+----------------------------------------+--------------------------------+
| 123                                    | "value"                        |
+----------------------------------------+--------------------------------+
| :key                                   | "test"                         |
+----------------------------------------+--------------------------------+

:ok
```

Useful for printing results of Ecto queries
```elixir
# %User{id: nil, email: nil}
User
|> limit(5)
|> Repo.all
|> Scribe.print

+----------------------+-----------------------------------+----------------+
| :__struct__          | :email                            | :id            |
+----------------------+-----------------------------------+----------------+
| User                 | "myles_fisher@beahan.com"         | 5171           |
+----------------------+-----------------------------------+----------------+
| User                 | "dawson_bartell@lynch.org"        | 4528           |
+----------------------+-----------------------------------+----------------+
| User                 | "hassan1972@langworth.com"        | 1480           |
+----------------------+-----------------------------------+----------------+
| User                 | "kiera.schulist@koch.com"         | 2084           |
+----------------------+-----------------------------------+----------------+
| User                 | "cynthia1970@mann.name"           | 6599           |
+----------------------+-----------------------------------+----------------+

:ok
```

## Pagination

Scribe uses [pane](https://github.com/codedge-llc/pane) to paginate large tables.
Use with `Scribe.console/2`.

```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}
User
|> limit(5)
|> Repo.all
|> Scribe.console

+-------------+------------------------+-------------+---------+------------+
| :__struct__ | :email                 | :first_name | :id     | :last_name |
+-------------+------------------------+-------------+---------+------------+
| User        | "celestine_satterfield | "Gene"      | 9061    | "Krajcik"  |
+-------------+------------------------+-------------+---------+------------+
| User        | "lynn1978@bednar.org"  | "Maeve"     | 9865    | "Gerlach"  |
+-------------+------------------------+-------------+---------+------------+
| User        | "melisa1975@hilll.biz" | "Theodora"  | 2262    | "Wunsch"   |
+-------------+------------------------+-------------+---------+------------+
| User        | "furman.grady@ryan.org | "Oswaldo"   | 4977    | "Simonis"  |
+-------------+------------------------+-------------+---------+------------+
| User        | "caesar_hirthe@reynold | "Arjun"     | 3907    | "Prohaska" |
+-------------+------------------------+-------------+---------+------------+


[1 of 1] (j)next (k)prev (q)quit
```

## Customizing Tables

`Scribe.print/2` takes a list of of columns on the `:data` options key to
customize output. You can use either the atom key or customize the header
with `{"Custom Title", :key}`.

```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}

User
|> limit(5)
|> Repo.all
|> Scribe.print(data: [{"ID", :id}, :first_name, :last_name])
 
+-------------------+---------------------------+--------------------------+
| "ID"              | :first_name               | :last_name               |
+-------------------+---------------------------+--------------------------+
| 9061              | "Gene"                    | "Krajcik"                |
+-------------------+---------------------------+--------------------------+
| 9865              | "Maeve"                   | "Gerlach"                |
+-------------------+---------------------------+--------------------------+
| 2262              | "Theodora"                | "Wunsch"                 |
+-------------------+---------------------------+--------------------------+
| 4977              | "Oswaldo"                 | "Simonis"                |
+-------------------+---------------------------+--------------------------+
| 3907              | "Arjun"                   | "Prohaska"               |
+-------------------+---------------------------+--------------------------+

:ok
```

### Custom Width

Pass a `:width` option to define the table width.

```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}

User
|> limit(5)
|> Repo.all
|> Scribe.print(data: [{"ID", :id}, :first_name, :last_name], width: 40)
 
+---------+------------+-----------+
| "ID"    | :first_nam | :last_nam |
+---------+------------+-----------+
| 9061    | "Gene"     | "Krajcik" |
+---------+------------+-----------+
| 9865    | "Maeve"    | "Gerlach" |
+---------+------------+-----------+
| 2262    | "Theodora" | "Wunsch"  |
+---------+------------+-----------+
| 4977    | "Oswaldo"  | "Simonis" |
+---------+------------+-----------+
| 3907    | "Arjun"    | "Prohaska |
+---------+------------+-----------+

:ok
```

### Function Columns

You can specify functions that take the given row's struct or map as its only argument.
```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}
results =
  User
  |> limit(5)
  |> Repo.all
  |> Scribe.print(u, [{"ID", :id}, {"Full Name", fn(x) -> "#{x.last_name}, #{x.first_name}" end}])

+--------------------------+----------------------------------------------+
| "ID"                     | "Full Name"                                  |
+--------------------------+----------------------------------------------+
| 9061                     | "Krajcik, Gene"                              |
+--------------------------+----------------------------------------------+
| 9865                     | "Gerlach, Maeve"                             |
+--------------------------+----------------------------------------------+
| 2262                     | "Wunsch, Theodora"                           |
+--------------------------+----------------------------------------------+
| 4977                     | "Simonis, Oswaldo"                           |
+--------------------------+----------------------------------------------+
| 3907                     | "Prohaska, Arjun"                            |
+--------------------------+----------------------------------------------+

:ok
```
