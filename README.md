[![Build Status](https://travis-ci.org/codedge-llc/scribe.svg?branch=master)](https://travis-ci.org/codedge-llc/scribe)
[![Hex.pm](http://img.shields.io/hexpm/v/scribe.svg)](https://hex.pm/packages/scribe)
# Scribe

Pretty-print tables of Elixir structs and maps. Inspired by [hirb](https://github.com/cldwalker/hirb).

## Installation

  1. Add `scribe` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:scribe, "~> 0.1.0"}]
    end
    ```

## Usage

Print a list of maps as a table. Header columns are taken from the map keys of the first element.
```elixir
iex(1)> data = [%{key: "value", another_key: 123}, %{key: "test", another_key: :key}]
iex(2)> Scribe.print(data)
+--------------+---------+
| :another_key | :key    |
+--------------+---------+
| 123          | "value" |
+--------------+---------+
| :key         | "test"  |
+--------------+---------+

:ok
```

Useful for printing results of Ecto queries
```elixir
# %User{id: nil, email: nil}
results =
  User
  |> limit(5)
  |> Repo.all
  |> Scribe.print

+------+----------------------------------+
| :id  | :email                           |
+------+----------------------------------+
| 1240 | "keanu2045@predovic.name"        |
+------+----------------------------------+
| 1241 | "rosetta1994@kiehn.name"         |
+------+----------------------------------+
| 1242 | "concepcion.fahey@schiller.name" |
+------+----------------------------------+
| 1243 | "madge1915@towne.biz"            |
+------+----------------------------------+
| 1244 | "casimir1935@smith.net"          |
+------+----------------------------------+

:ok
```

## Customizing Tables

`Scribe.print/2` takes a list of of columns to customize output. You can use either the atom key or customize the header with `{"Custom Title", :key}`.

```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}
results =
  User
  |> limit(5)
  |> Repo.all
  |> Scribe.print(u, [{"ID", :id}, :first_name, :last_name])
 
+------+-------------+------------+
| "ID" | :first_name | :last_name |
+------+-------------+------------+
| 1240 | "Danielle"  | "Spencer"  |
+------+-------------+------------+
| 1241 | "Dovie"     | "Prosacco" |
+------+-------------+------------+
| 1242 | "Elyse"     | "Tromp"    |
+------+-------------+------------+
| 1243 | "Jalen"     | "Gutmann"  |
+------+-------------+------------+
| 1244 | "Broderick" | "Rice"     |
+------+-------------+------------+

:ok
```

## Function Columns

You can specify functions that take the given row's struct or map as its only argument.
```elixir
# %User{id: nil, email: nil, first_name: nil, last_name: nil}
results =
  User
  |> limit(5)
  |> Repo.all
  |> Scribe.print(u, [{"ID", :id}, {"Full Name", fn(x) -> "#{x.last_name}, #{x.first_name}" end}])
  
+------+---------------------+
| "ID" | "Full Name"         |
+------+---------------------+
| 1240 | "Spencer, Danielle" |
+------+---------------------+
| 1241 | "Prosacco, Dovie"   |
+------+---------------------+
| 1242 | "Tromp, Elyse"      |
+------+---------------------+
| 1243 | "Gutmann, Jalen"    |
+------+---------------------+
| 1244 | "Rice, Broderick"   |
+------+---------------------+

:ok
```
