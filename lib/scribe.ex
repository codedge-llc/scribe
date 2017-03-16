defmodule Scribe do
  @moduledoc """
    Pretty-print tables of structs and maps
  """

  @colors [syntax_colors: [atom: :cyan, string: :green]]

  def print(_results, opts \\ nil)
  def print([], _opts), do: :ok
  def print(results, opts) do
    results
    |> format(opts)
    |> IO.puts
  end

  def inspect(results, opts \\ nil) do
    print(results, opts)
    results
  end

  def format(_results, opts \\ nil)
  def format([], _opts), do: :ok
  def format(results, opts) when not is_list(results), do: format([results], opts)
  def format(results, opts) do
    structs = Enum.map(results, fn(x) -> mapper(x) end)
    keys = fetch_keys(structs, opts[:data])

    headers = map_string_values(keys)
    data = Enum.map(structs, &map_string_values(&1, keys))

    [headers | data]
    |> Scribe.Table.format(Enum.count(results) + 1, Enum.count(keys), opts)
  end

  defp map_string_values(keys), do: Enum.map(keys, &string_value(&1))
  defp map_string_values(row, keys), do: Enum.map(keys, &string_value(row, &1))

  defp string_value(%{name: name, key: _key}),
    do: Kernel.inspect(name)
  defp string_value(map, %{name: _name, key: key}) when is_function(key),
    do: Kernel.inspect(key.(map))
  defp string_value(map, %{name: _name, key: key}),
    do: Kernel.inspect(map[key])

  defp mapper(%{__struct__: _struct} = x), do: Map.from_struct(x)
  defp mapper(%{} = map), do: map

  defp fetch_keys([first | _rest], opts) do
    case opts do
      nil -> fetch_keys(first)
      opts -> process_headers(opts)
    end
  end

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
    |> Map.keys
    |> process_headers
  end
end
