defmodule Scribe do

  def yeah(%{__struct__: struct}) do
    IO.puts "I'm a #{inspect(struct)}"
  end

  def yeah(%{}) do
    IO.puts "I'm a map!"
  end

  def pretty(results, opts \\ nil) do
    structs = Enum.map(results, fn(x) -> Map.from_struct(x) end)
    [first|_rest] = structs
    keys =
      case opts do
        nil -> 
          first
          |> Map.delete(:__meta__)
          |> Map.delete(:__struct__)
          |> Map.keys()
        opts -> opts
      end
    line = ~s(#{Enum.reduce(keys, "|", fn(x, acc) -> acc <> format_cell(first, x, :header) end)})
    IO.puts "\n"
    IO.puts String.duplicate("-", String.length(line))
    IO.puts line
    IO.puts String.duplicate("-", String.length(line))
    for model <- results do
      line = ~s(#{Enum.reduce(keys, "|", fn(x, acc) -> acc <> format_cell(Map.from_struct(model), x, :value) end)})
      IO.puts line
      IO.puts String.duplicate("-", String.length(line))
    end
    :ok
  end

  def format_cell(map, key, type) do
    v = ~s(#{inspect(map[key])})
    h = ~s(#{key})
    diff = String.length(v) - String.length(h)
    r = String.duplicate(" ", abs(diff))
    cond do
      diff >= 0 && type == :header -> " #{h}#{r} |"
      diff >= 0 && type == :value -> " #{v} |"
      diff < 0 && type == :header -> " #{h} |"
      diff < 0 && type == :value -> " #{v}#{r} |"
    end
  end

  def max_width(elems, key) do
  end
end
