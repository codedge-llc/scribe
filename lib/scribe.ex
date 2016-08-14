defmodule Scribe do
  @moduledoc """
    Pretty-print tables of structs and maps
  """

  def print(_results, opts \\ nil)
  def print([], _opts), do: :ok
  def print(results, opts) do
    results
    |> format(opts)
    |> IO.puts
  end

  def format(_results, opts \\ nil)
  def format([], _opts), do: :ok
  def format(results, opts) when not is_list(results), do: format([results], opts)
  def format(results, opts) do
    structs = Enum.map(results, fn(x) -> mapper(x) end)
    keys = fetch_keys(structs, opts)

    headers = map_string_values(keys)
    data = Enum.map(structs, fn(row) -> map_string_values(row, keys) end)

    [headers | data]
    |> Scribe.Table.format(Enum.count(results) + 1, Enum.count(keys))
  end

  defp map_string_values(keys), do: Enum.map(keys, fn(x) -> string_value(x) end)
  defp map_string_values(row, keys), do: Enum.map(keys, fn(key) -> string_value(row, key) end)

  defp string_value(x), do: inspect(x)
  defp string_value(map, x) when is_function(x), do: inspect(x.(map))
  defp string_value(map, x), do: inspect(map[x])

  defp mapper(%{__struct__: _struct} = x), do: Map.from_struct(x)
  defp mapper(%{} = map), do: map

  defp fetch_keys([first | _rest], opts) do
    case opts do
      nil -> fetch_keys(first)
      opts -> opts
    end
  end

  defp fetch_keys(map) do
    map
    |> Map.delete(:__meta__)
    |> Map.delete(:__struct__)
    |> Map.keys()
  end
end
