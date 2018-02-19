defmodule Scribe.Style.Pseudo do
  @moduledoc false

  @behaviour Scribe.Style

  @default_border %Scribe.Border{
    bottom_edge: "─",
    bottom_left_corner: "└",
    bottom_right_corner: "┘",
    top_edge: "─",
    top_left_corner: "┌",
    top_right_corner: "┐",
    left_edge: "│",
    right_edge: "│"
  }

  def border_at(row, col, max_rows, max_cols)
      when row > 0 and col > 0 and row < max_rows - 1 and col < max_cols - 1 do
    %Scribe.Border{@default_border |
      top_left_corner: "┼", top_right_corner: "┼",
      bottom_left_corner: "┼", bottom_right_corner: "┼"
    }
  end

  def border_at(0, 0, _max_rows, 1) do
    %Scribe.Border{@default_border |
      bottom_left_corner: "├", bottom_right_corner: "┤"}
  end

  def border_at(0, col, _max_rows, max_cols) when col < max_cols - 1 do
    %Scribe.Border{@default_border |
      top_right_corner: "┬",
      bottom_left_corner: "├", bottom_right_corner: "┼"}
  end

  def border_at(row, col, max_rows, max_cols) when col == max_cols - 1 and row < max_rows - 1 do
    %Scribe.Border{@default_border | bottom_right_corner: "┤"}
  end

  def border_at(row, col, max_rows, max_cols) when row == max_rows - 1 and col < max_cols - 1 do
    %Scribe.Border{@default_border | bottom_right_corner: "┴"}
  end

  def border_at(row, 0, max_rows, _max_cols) when row < max_rows - 1 do
    %Scribe.Border{@default_border |
      bottom_left_corner: "├", bottom_right_corner: "┼"}
  end

  def border_at(_row, _col, _max_rows, _max_cols) do
    @default_border
  end

  use Scribe.DefaultColors
end
