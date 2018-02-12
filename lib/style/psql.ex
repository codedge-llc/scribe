defmodule Scribe.Style.Psql do
  @moduledoc false

  @behaviour Scribe.Style

  use Scribe.DefaultColors

  # Top left cell
  def border_at(0, 0, _, _) do
    %Scribe.Border{
      bottom_edge: "-",
      bottom_left_corner: "",
      bottom_right_corner: "+",
      top_edge: " ",
      top_left_corner: "",
      top_right_corner: " ",
      left_edge: "",
      right_edge: "|"
    }
  end

  # Top right cell
  def border_at(0, col, _, max) when col == max - 1 do
    %Scribe.Border{
      top_left_corner: " ",
      top_edge: " ",
      top_right_corner: "",
      right_edge: "",
      bottom_right_corner: "",
      bottom_edge: "-",
      bottom_left_corner: "+",
      left_edge: "|"
    }
  end

  # All other top-row cells
  def border_at(0, _, _, _) do
    %Scribe.Border{
      top_left_corner: " ",
      top_edge: " ",
      top_right_corner: " ",
      right_edge: "|",
      bottom_right_corner: "+",
      bottom_edge: "-",
      bottom_left_corner: "+",
      left_edge: "|"
    }
  end

  # First column cells
  def border_at(_, 0, _, _) do
    %Scribe.Border{
      top_left_corner: "",
      top_edge: "",
      top_right_corner: "",
      right_edge: "|",
      bottom_right_corner: "",
      bottom_edge: "",
      bottom_left_corner: "",
      left_edge: ""
    }
  end

  # Last column cells
  def border_at(_, col, _, max) when col == max - 1 do
    %Scribe.Border{
      top_left_corner: "",
      top_edge: "",
      top_right_corner: "",
      right_edge: "",
      bottom_right_corner: "",
      bottom_edge: "",
      bottom_left_corner: "",
      left_edge: "|"
    }
  end

  # All other cells
  def border_at(_, _, _, _) do
    %Scribe.Border{
      top_left_corner: "",
      top_edge: "",
      top_right_corner: "",
      right_edge: "|",
      bottom_right_corner: "",
      bottom_edge: "",
      bottom_left_corner: "",
      left_edge: "|"
    }
  end
end
