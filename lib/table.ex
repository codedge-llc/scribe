defmodule Scribe.Table do
  @moduledoc """
    Handles all table formatting for pretty-printing.
  """

  def total_width do
    case Application.get_env(:scribe, :width) do
      nil -> 80
      width -> width
    end
  end

  def format(data, rows, cols) do
    widths =
      data
      |> get_max_widths(rows, cols)
      |> distribute_widths(total_width - 8)
    result = separator_line(widths) <> "\n"
    Enum.reduce(data, result, fn(row, acc) ->
      acc
      <> data_line(row, widths) <> "\n"
      <> separator_line(widths) <> "\n"
    end)
  end

  defp get_max_widths(data, rows, cols) do
    for c <- 0..cols - 1 do
      data
      |> get_column_widths(rows, c)
      |> Enum.max_by(&get_width(&1))
      |> get_width
    end
  end

  defp get_width(value) do
    value
    |> cell_value(0, 1000)
    |> String.length
  end

  defp distribute_widths(widths, max_size) do
    sum = Enum.sum(widths) + (3 * Enum.count(widths))
    Enum.map(widths, fn(x) ->
      round(((x + 3) / sum) * max_size)
    end)
  end

  defp get_column_widths(data, rows, col) do
    for row <- 0..rows - 1 do
      data
      |> Enum.at(row)
      |> Enum.at(col)
    end
  end

  defp separator_line(widths) do
    Enum.reduce(widths, "+", fn(width, acc) ->
      acc <> String.duplicate("-", width) <> "+"
    end)
  end

  defp data_line(row, widths) do
    row
    |> Enum.zip(widths)
    |> Enum.reduce("|", fn({value, width}, acc) ->
      diff = width - String.length(cell_value(value, 0, width))
      acc <> cell(value, width) <> "|"
    end)
  end

  defp cell(x, width) do
    len = min(String.length(" #{x} "), width)
    padding = String.duplicate(" ", width - len)
    truncate(" #{x}#{padding}", width - 2) <> " "
  end

  defp cell_value(x, padding, max_width) when padding >= 0 do
    truncate(" #{colorize(x)}#{String.duplicate(" ", padding)} ", max_width)
  end
  defp cell_value(x, _padding, max_width), do: " #{truncate(colorize(x), max_width)} "

  defp truncate(elem, width) do
    String.slice(elem, 0..width)
  end

  def colorize(item) when is_binary(item), do: colorize(item, IO.ANSI.green)
  def colorize(item) when is_atom(item), do: colorize(item, IO.ANSI.cyan)
  def colorize(item), do: colorize(item, IO.ANSI.default_color)

  def colorize(item, color), do: "#{color}#{item}#{IO.ANSI.reset}"
end
