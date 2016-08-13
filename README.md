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

Print an array of maps as a table. Header columns are taken from the map keys of the first element.
```
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
```
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
