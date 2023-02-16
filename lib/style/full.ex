defmodule Scribe.Style.Full do
  @moduledoc """
  default style

  ## example
  iex>  t = %Scribe.StyleTest{}
  iex>  opts = [colorize: false, style: Scribe.Style.Full]
  iex>  Scribe.format([t, t, t], opts)
  "\""
  =========================================
  | :__struct__        | :id   | :value   |
  =========================================
  | Scribe.StyleTest   | nil   | 1234     |
  +--------------------+-------+----------+
  | Scribe.StyleTest   | nil   | 1234     |
  +--------------------+-------+----------+
  | Scribe.StyleTest   | nil   | 1234     |
  +--------------------+-------+----------+
  "\""
  """

  @behaviour Scribe.Style
  use Scribe.DefaultColors

  def border_at(0, _, _, _) do
    %Scribe.Border{
      bottom_edge: "=",
      bottom_left_corner: "=",
      bottom_right_corner: "=",
      top_edge: "=",
      top_left_corner: "=",
      top_right_corner: "=",
      left_edge: "|",
      right_edge: "|"
    }
  end
  def border_at(_, _, _, _) do
    %Scribe.Border{
      bottom_edge: "-",
      bottom_left_corner: "+",
      bottom_right_corner: "+",
      top_edge: "-",
      top_left_corner: "+",
      top_right_corner: "+",
      left_edge: "|",
      right_edge: "|"
    }
  end
end
