defmodule Scribe.Border do
  @moduledoc ~S"""
  Encapsulates border and edge symbols for a table cell.
  """
  defstruct top_left_corner: "",
            top_edge: "",
            top_right_corner: "",
            right_edge: "",
            bottom_right_corner: "",
            bottom_edge: "",
            bottom_left_corner: "",
            left_edge: ""

  def new(corner, v_edge, h_edge) do
    %__MODULE__{
      top_left_corner: corner,
      top_edge: h_edge,
      top_right_corner: corner,
      right_edge: v_edge,
      bottom_right_corner: corner,
      bottom_edge: h_edge,
      bottom_left_corner: corner,
      left_edge: v_edge
    }
  end
end
