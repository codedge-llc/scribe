defmodule Scribe.Style.Pseudo do
  @moduledoc ~S"""
  Pseudo style.

  ## Examples

      iex> Scribe.print(data, style: Scribe.Style.Pseudo)

      ┌───────┬───────────────────────────────────┬────────────────────────┐
      │ :id   │ :inserted_at                      │ :key                   │
      ├───────┼───────────────────────────────────┼────────────────────────┤
      │ 457   │ "2017-03-27 14:42:34.095202Z"     │ "CEB0E055ECDF6028"     │
      │ 326   │ "2017-03-27 14:42:34.097519Z"     │ "CF67027F7235B88D"     │
      │ 756   │ "2017-03-27 14:42:34.097553Z"     │ "DE016DFF477BEDDB"     │
      │ 484   │ "2017-03-27 14:42:34.097572Z"     │ "9194A82EF4BB0123"     │
      │ 780   │ "2017-03-27 14:42:34.097591Z"     │ "BF92748B4AAAF14A"     │
      └───────┴───────────────────────────────────┴────────────────────────┘
  """

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

  @impl true
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
