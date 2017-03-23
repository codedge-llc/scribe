defmodule Scribe.Table do
  @moduledoc """
    Handles all table formatting for pretty-printing.
  """

  alias Scribe.TableStyle
  alias Scribe.Table.Line

  def table_style(opts) do
    opts[:style]
    || Application.get_env(:scribe, :style)
    || TableStyle.default()
  end

  def total_width do
    case Application.get_env(:scribe, :width) do
      nil -> 120
      width -> width
    end
  end

  def format(data, rows, cols, opts \\ []) do
    total_max_width = opts[:width] || total_width()
    widths =
      data
      |> get_max_widths(rows, cols)
      |> distribute_widths(total_max_width - 8)

    style = table_style(opts)

    [headers | data] = data

    header =
      Line.frame_line(widths, style)
      <> header_line(headers, widths, style)
      <> Line.header_separator_line(widths, style)

    body =
      data
      |> Enum.map(& data_line(&1, widths, style))
      |> Enum.join(Line.data_separator_line(widths, style))

    header <> body <> Line.frame_line(widths, style)
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

  defp header_line(row, widths, style) do
    header_v = style.header_vertical_separator
    frame_v = style.frame_vertical

    segments =
      row
      |> Enum.zip(widths)
      |> Enum.map(fn({value, width}) ->
          cell(value, width)
         end)

    frame_v <> Enum.join(segments, header_v) <> frame_v <> "\n"
  end

  defp data_line(row, widths, style) do
    data_v = style.data_vertical_separator
    frame_v = style.frame_vertical

    segments =
      row
      |> Enum.zip(widths)
      |> Enum.map(fn({value, width}) ->
          cell(value, width)
         end)

    frame_v <> Enum.join(segments, data_v) <> frame_v <> "\n"
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
