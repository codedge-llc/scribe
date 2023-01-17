defmodule Scribe.Style.Html do
  @moduledoc false

  alias Scribe.Border

  @behaviour Scribe.Style

  def border_at(0, col, _max_rows, max_cols) when col == max_cols - 1 do
    %Scribe.Border{
      right_edge: "</th></tr>",
      left_edge: "<th>"
    }
  end

  def border_at(0, _columns, _max_rows, _max_cols) do
    %Scribe.Border{
      top_left_corner: "<table><tr>",
      right_edge: "</th><th>",
      bottom_left_corner: "<tr>",
      left_edge: "<th>"
    }
  end

  def border_at(row, col, max_rows, max_cols)
      when row == max_rows - 1 and col == max_cols - 1 do
    %Scribe.Border{
      bottom_right_corner: "</tr></table>"
    }
  end

  def border_at(row, _col, max_rows, _max_cols) when row == max_rows - 1 do
    %Scribe.Border{
      right_edge: "</td><td>",
      bottom_left_corner: "</td>",
      left_edge: "<td>"
    }
  end

  def border_at(_row, col, _max_rows, max_cols) when col == max_cols - 1 do
    %Scribe.Border{
      right_edge: "</td></tr>"
    }
  end

  def border_at(_row, _col, _max_rows, _max_cols) do
    %Scribe.Border{
      right_edge: "</td><td>",
      bottom_left_corner: "<tr>",
      left_edge: "<td>"
    }
  end

  use Scribe.DefaultColors
end
