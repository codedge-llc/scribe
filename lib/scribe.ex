defmodule Scribe do
  @moduledoc """
  Pretty-print tables of structs and maps
  """

  alias Scribe.Table

  @type data ::
          []
          | [...]
          | term

  @typedoc ~S"""
  Options for configuring table output.

  - `:colorize` - When `false`, disables colored output. Defaults to `true`
  - `:data` - Defines table headers
  - `:device` - Where to print (defaults to STDOUT)
  - `:style` - Style callback module. Defaults to `Scribe.Style.Default`
  - `:width` - Defines table width. Defaults to `:infinite`
  """
  @type format_opts :: [
          colorize: boolean,
          data: [...],
          style: module,
          width: integer
        ]

  @doc ~S"""
  Enables/disables auto-inspect override.

  If true, Scribe will override `inspect/2` for maps and structs, printing
  them as tables.

  ## Examples

      iex> Scribe.auto_inspect(true)
      :ok
  """
  @spec auto_inspect(boolean) :: :ok
  def auto_inspect(inspect?) do
    Application.put_env(:scribe, :auto_inspect, inspect?)
  end

  @doc ~S"""
  Returns true if Scribe is overriding `Inspect`.

  ## Examples

      iex> Scribe.auto_inspect?
      true
  """
  def auto_inspect? do
    compile_auto_inspect?() and
      Application.get_env(:scribe, :auto_inspect, false)
  end

  @doc false
  def compile_auto_inspect? do
    Application.get_env(:scribe, :compile_auto_inspect, false)
  end

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
  @spec inspect(term, format_opts) :: term
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
  @spec format([] | [...] | term) :: String.t() | :ok
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
    |> process_headers()
  end
end
