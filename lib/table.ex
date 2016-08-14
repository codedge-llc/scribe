defmodule Scribe.Table do
  @moduledoc """
    Handles all table formatting for pretty-printing.
  """

  def format(data, rows, cols) do
    widths = get_max_widths(data, rows, cols)
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
      |> Enum.max_by(fn(x) -> get_width(x) end)
      |> get_width()
    end
  end

  defp get_column_widths(data, rows, col) do
    for row <- 0..rows - 1 do
      data
      |> Enum.at(row)
      |> Enum.at(col)
    end
  end

  defp get_width(value) do
    value
    |> cell_value(0)
    |> String.length()
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
      diff = width - String.length(cell_value(value, 0))
      acc <> cell_value(value, diff) <> "|"
    end)
  end

  defp cell_value(x, padding) when padding >= 0 do
    " #{x}#{String.duplicate(" ", padding)} "
  end
  defp cell_value(x, _padding), do: " #{inspect(x)} "
end
