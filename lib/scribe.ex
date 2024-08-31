defmodule Scribe do
  @moduledoc ~S"""
  Pretty-print tables of structs and maps

  ## Usage

  A common use case is printing results from an Ecto query.

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

  ## Pagination

  Scribe uses [pane](https://github.com/codedge-llc/pane) to paginate large tables.
  Use with `Scribe.console/2`.

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

  ## Printing Custom Tables

  `Scribe.print/2` takes a list of of columns on the `:data` options key to
  customize output. You can use either the atom key or customize the header
  with `{"Custom Title", :key}`.

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

  ### Function Columns

  You can specify functions that take the given row's struct or map as its only argument.

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

  ## Styling Options

  ### Width

  Pass a `width` option to define table width.

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

  ### Disable Colors

      iex> Scribe.print(data, colorize: false)

  ### Styles

  Scribe supports five styling formats natively, with support for custom adapters.
  See more in `Scribe.Style`.
  """

  alias Scribe.Table

  @typedoc ~S"""
  Printable data. Can be either a struct, map, or list of structs/maps.
  """
  @type data :: [map] | [struct] | map | struct

  @typedoc ~S"""
  Options for configuring table output.

  - `:alignment` - Define text alignment in cells. Defaults to `:left`.
  - `:colorize` - When `false`, disables colored output. Defaults to `true`
  - `:data` - Defines table headers
  - `:device` - Where to print (defaults to STDOUT)
  - `:style` - Style callback module. Defaults to `Scribe.Style.Default`
  - `:width` - Defines table width. Defaults to `:infinite`
  """
  @type format_opts :: [
          alignment: atom,
          colorize: boolean,
          data: [...],
          style: module,
          width: integer
        ]

  @doc ~S"""
  Prints a table from given data.

  ## Examples

      iex> print([])
      :ok

      iex> Scribe.print(%{key: :value, test: 1234}, colorize: false)
      +----------+---------+
      | :key     | :test   |
      +----------+---------+
      | :value   | 1234    |
      +----------+---------+
      :ok
  """
  @spec print(data, format_opts) :: :ok
  def print(_results, opts \\ [])

  def print([], _opts), do: :ok

  def print(results, opts) do
    dev = opts |> Keyword.get(:device, :stdio)
    results = results |> format(opts)
    dev |> IO.puts(results)
  end

  @doc ~S"""
  Paginates data and starts a pseudo-interactive console.
  """
  @spec console(data, format_opts) :: no_return
  def console(results, opts \\ []) do
    results
    |> format(opts)
    |> Pane.console()
  end

  @doc ~S"""
  Prints a table from given data and returns the data.

  Useful for inspecting pipe chains.

  ## Examples

      iex> Scribe.inspect([])
      []

      iex> Scribe.inspect(%{key: :value, test: 1234}, colorize: false)
      +----------+---------+
      | :key     | :test   |
      +----------+---------+
      | :value   | 1234    |
      +----------+---------+
      %{test: 1234, key: :value}
  """
  @spec inspect(data, format_opts) :: data
  def inspect(results, opts \\ []) do
    print(results, opts)
    results
  end

  @doc ~S"""
  Formats data into a printable table string.

  ## Examples

      iex> format([])
      :ok

      iex> format(%{test: 1234}, colorize: false)
      "+---------+\n| :test   |\n+---------+\n| 1234    |\n+---------+\n"
  """
  @spec format(data) :: String.t() | :ok
  def format(_results, opts \\ [])
  def format([], _opts), do: :ok

  def format(results, opts) when not is_list(results) do
    format([results], opts)
  end

  def format(results, opts) do
    keys = fetch_keys(results, opts[:data])

    headers = map_string_values(keys)
    data = Enum.map(results, &map_string_values(&1, keys))

    table = [headers | data]
    Table.format(table, Enum.count(table), Enum.count(keys), opts)
  end

  defp map_string_values(keys), do: Enum.map(keys, &string_value(&1))
  defp map_string_values(row, keys), do: Enum.map(keys, &string_value(row, &1))

  defp string_value(%{name: name, key: _key}) do
    name
  end

  defp string_value(map, %{name: _name, key: key}) when is_function(key) do
    map |> key.()
  end

  defp string_value(map, %{name: _name, key: key}) do
    map |> Map.get(key)
  end

  defp fetch_keys([first | _rest], nil), do: fetch_keys(first)
  defp fetch_keys(_list, opts), do: process_headers(opts)

  defp process_headers(opts) do
    for opt <- opts do
      case opt do
        {name, key} -> %{name: name, key: key}
        key -> %{name: key, key: key}
      end
    end
  end

  defp fetch_keys(map) do
    map
    |> Map.keys()
    |> Enum.sort()
    |> process_headers()
  end
end
