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
  defstruct bottom_edge: "",
            bottom_left_corner: "",
            bottom_right_corner: "",
            left_edge: "",
            right_edge: "",
            top_edge: "",
            top_left_corner: "",
            top_right_corner: ""

  @type t :: %__MODULE__{
          bottom_edge: String.t(),
          bottom_left_corner: String.t(),
          bottom_right_corner: String.t(),
          left_edge: String.t(),
          right_edge: String.t(),
          top_edge: String.t(),
          top_left_corner: String.t(),
          top_right_corner: String.t()
        }

  @doc ~S"""
  Defines a new `Border.t` with given corner and edges.

  ## Examples

      iex> new("+", "|", "-")
      %Scribe.Border{
        bottom_edge: "-",
        bottom_left_corner: "+",
        bottom_right_corner: "+",
        left_edge: "|",
        right_edge: "|",
        top_edge: "-",
        top_left_corner: "+",
        top_right_corner: "+"
      }
  """
  @spec new(String.t(), String.t(), String.t()) :: t()
  def new(corner, v_edge, h_edge) do
    %__MODULE__{
      bottom_edge: h_edge,
      bottom_left_corner: corner,
      bottom_right_corner: corner,
      left_edge: v_edge,
      right_edge: v_edge,
      top_edge: h_edge,
      top_left_corner: corner,
      top_right_corner: corner
    }
  end
end
