defmodule Scribe.Formatter.Index do
  @moduledoc false
  defstruct row: 0, row_max: 0, col: 0, col_max: 0
end

defmodule Scribe.Formatter.Line do
  @moduledoc false
  defstruct data: [], widths: [], style: nil, opts: [], index: nil

  alias Scribe.Formatter.{Index, Line}

  def format(%Line{index: %Index{row: 0}} = line) do
    top(line) <> data(line) <> bottom(line)
  end

  def format(%Line{} = line) do
    data(line) <> bottom(line)
  end

  def data(%Line{} = line) do
    %Line{
      data: row,
      widths: widths,
      style: style,
      opts: opts,
      index: index
    } = line

    border = style.border_at(index.row, 0, index.row_max, index.col_max)
    left_edge = border.left_edge

    line =
      Enum.reduce(0..(index.col_max - 1), "", fn x, acc ->
        b = style.border_at(index.row, x, index.row_max, index.col_max)
        width = Enum.at(widths, x)
        value = Enum.at(row, x)

        cell_value =
          case opts[:colorize] do
            false -> value |> cell(width)
            _ -> value |> cell(width) |> colorize(style.color(value))
          end

        acc <> cell_value <> b.right_edge
      end)

    left_edge <> line <> "\n"
  end

  def cell(x, width) do
    len = min(String.length(" #{inspect(x)} "), width)
    padding = String.duplicate(" ", width - len)
    truncate(" #{inspect(x)}#{padding}", width - 2) <> " "
  end

  def cell_value(x, padding, max_width) when padding >= 0 do
    truncate(" #{inspect(x)}#{String.duplicate(" ", padding)} ", max_width)
  end

  defp truncate(elem, width) do
    String.slice(elem, 0..width)
  end

  def colorize(string, color) do
    "#{color}#{string}#{IO.ANSI.reset()}"
  end

  def top(%Line{widths: widths, style: style, index: index, opts: opts}) do
    border = style.border_at(index.row, 0, index.row_max, index.col_max)
    top_left = border.top_left_corner

    line =
      Enum.reduce(0..(index.col_max - 1), "", fn x, acc ->
        b = style.border_at(index.row, x, index.row_max, index.col_max)
        width = Enum.at(widths, x)

        acc <> String.duplicate(b.top_edge, width) <> b.top_right_corner
      end)

    color_prefix =
      if Keyword.get(opts, :colorize, true) do
        style.default_color()
      else
        ""
      end

    color_prefix <> top_left <> add_newline(line)
  end

  def bottom(%Line{widths: widths, style: style, index: index}) do
    border = style.border_at(index.row, 0, index.row_max, index.col_max)
    bottom_left = border.bottom_left_corner

    line =
      Enum.reduce(0..(index.col_max - 1), "", fn x, acc ->
        b = style.border_at(index.row, x, index.row_max, index.col_max)
        width = Enum.at(widths, x)

        acc <> String.duplicate(b.bottom_edge, width) <> b.bottom_right_corner
      end)

    bottom_left <> add_newline(line)
  end

  def add_newline(""), do: ""
  def add_newline(line), do: line <> "\n"
end
