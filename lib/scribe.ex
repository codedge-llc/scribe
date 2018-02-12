defmodule Scribe do
  @moduledoc """
  Pretty-print tables of structs and maps
  """

  def print(_results, opts \\ nil)
  def print([], _opts), do: :ok

  def print(results, opts) do
    results
    |> format(opts)
    |> IO.puts()
  end

  def console(results, opts \\ nil) do
    results
    |> format(opts)
    |> Pane.console()
  end

  def inspect(results, opts \\ nil) do
    print(results, opts)
    results
  end

  def format(_results, opts \\ nil)
  def format([], _opts), do: :ok

  def format(results, opts) when not is_list(results) do
    format([results], opts)
  end

  def format(results, opts) do
    keys = fetch_keys(results, opts[:data])

    headers = map_string_values(keys)
    data = Enum.map(results, &map_string_values(&1, keys))

    table = [headers | data]
    Scribe.Table.format(table, Enum.count(table), Enum.count(keys), opts)
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
    |> Map.keys()
    |> process_headers
  end
end
