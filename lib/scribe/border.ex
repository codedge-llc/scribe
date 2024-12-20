defmodule Scribe.Border do
  @moduledoc ~S"""
  Defines border and edge symbols for a table cell.

  ## Example Usage

  When printed, a cell with a border of `Scribe.Border.new("+", "|", "-")`
  would look like:

  ```
  +--------+
  | "test" |
  +--------+
  ```
  """
  defstruct top_left_corner: "",
            top_edge: "",
            top_right_corner: "",
            right_edge: "",
            bottom_right_corner: "",
            bottom_edge: "",
            bottom_left_corner: "",
            left_edge: ""

  @type t :: %__MODULE__{
          top_left_corner: String.t(),
          top_edge: String.t(),
          top_right_corner: String.t(),
          right_edge: String.t(),
          bottom_right_corner: String.t(),
          bottom_edge: String.t(),
          bottom_left_corner: String.t(),
          left_edge: String.t()
        }

  @doc ~S"""
  Defines a new `Border.t` with given corner and edges.

  ## Examples

      iex> new("+", "|", "-")
      %Scribe.Border{
        top_left_corner: "+",
        top_edge: "-",
        top_right_corner: "+",
        right_edge: "|",
        bottom_right_corner: "+",
        bottom_edge: "-",
        bottom_left_corner: "+",
        left_edge: "|"
      }
  """
  @spec new(String.t(), String.t(), String.t()) :: t
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
