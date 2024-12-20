defmodule Scribe.Table do
  @moduledoc false

  alias Scribe.Style
  alias Scribe.Formatter.{Index, Line}

  def table_style(opts) do
    opts[:style] || Style.default()
  end

  def total_width do
    Application.get_env(:scribe, :width, :infinity)
  end

  def printable_width(opts) do
    case opts[:width] || total_width() do
      :infinity -> :infinity
      width -> width - 8
    end
  end

  def format(data, rows, cols, opts \\ []) do
    total_width = printable_width(opts)

    widths =
      data
      |> get_max_widths(rows, cols)
      |> distribute_widths(total_width)

    style = table_style(opts)

    index = %Index{
      row: 0,
      col: 0,
      row_max: Enum.count(data),
      col_max: data |> Enum.at(0) |> Enum.count()
    }

    Enum.reduce(0..(index.row_max - 1), "", fn x, acc ->
      row = Enum.at(data, x)
      i = %{index | row: x}

      line = %Line{
        data: row,
        widths: widths,
        style: style,
        index: i,
        opts: opts
      }

      acc <> Line.format(line)
    end)
  end

  defp get_max_widths(data, rows, cols) do
    for c <- 0..(cols - 1) do
      data
      |> get_column_widths(rows, c)
      |> Enum.max_by(&get_width(&1))
      |> get_width()
    end
  end

  defp get_width(value) do
    value
    |> inspect()
    |> Line.cell_value(0, 5000)
    |> String.length()
  end

  defp distribute_widths(widths, :infinity) do
    widths
  end

  defp distribute_widths(widths, max_size) do
    sum = Enum.sum(widths) + 3 * Enum.count(widths)

    Enum.map(widths, fn x ->
      round((x + 3) / sum * max_size)
    end)
  end

  defp get_column_widths(data, rows, col) do
    for row <- 0..(rows - 1) do
      data
      |> Enum.at(row)
      |> Enum.at(col)
    end
  end
end
