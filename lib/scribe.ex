defmodule Scribe do
  def mapper(%{__struct__: _struct} = x), do: Map.from_struct(x)
  def mapper(%{} = map), do: map

  def print(_results, opts \\ nil)
  def print([], _opts), do: :ok
  def print(results, opts) do
    structs = Enum.map(results, fn(x) -> mapper(x) end)
    keys = fetch_keys(structs, opts)
    [keys] ++ Enum.map(structs, fn(row) ->
      Enum.map(keys, fn(key) ->
        row[key]
      end)
    end)
    |> Scribe.Table.format(Enum.count(results), Enum.count(keys))
    |> IO.puts
  end

  defp fetch_keys([first|_rest], opts) do
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
