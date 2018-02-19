defmodule Scribe.Style.Pseudo do
  @moduledoc false

  @behaviour Scribe.Style

  @empty_border %Scribe.Border{
    bottom_edge: "",
    bottom_left_corner: "",
    bottom_right_corner: "",
    top_edge: "",
    top_left_corner: "",
    top_right_corner: "",
    left_edge: "│",
    right_edge: "│"
  }

  @header_border %Scribe.Border{
    bottom_edge: "─",
    bottom_left_corner: "└",
    bottom_right_corner: "┘",
    top_edge: "─",
    top_left_corner: "┌",
    top_right_corner: "┐",
    left_edge: "│",
    right_edge: "│"
  }

  def border_at(0, col, _max_rows, max_cols) when col < max_cols - 1 do
    %Scribe.Border{
      @header_border
      | bottom_left_corner: "├",
        bottom_right_corner: "┼",
        top_right_corner: "┬"
    }
  end

  def border_at(0, _col, _max_rows, _max_cols) do
    %Scribe.Border{
      @header_border
      | bottom_left_corner: "├",
        bottom_right_corner: "┤"
    }
  end

  def border_at(row, col, max_rows, max_cols)
      when row == max_rows - 1 and col < max_cols - 1 do
    %Scribe.Border{
      @header_border
      | top_left_corner: "",
        top_right_corner: "",
        bottom_right_corner: "┴"
    }
  end

  def border_at(row, _col, max_rows, _max_cols) when row == max_rows - 1 do
    %Scribe.Border{@header_border | top_left_corner: "", top_right_corner: ""}
  end

  def border_at(_row, _col, _max_rows, _max_cols) do
    @empty_border
  end

  use Scribe.DefaultColors
end
