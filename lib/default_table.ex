defmodule Scribe.DefaultTable do
  @moduledoc """

     1234
    a╔═╦╗
    b║ ║║
    c╠═╬╣
    d║ ║║
    e╚═╩╝
  
    use Scribe.DefaultTable,
      a1: "╔",
      a2: "═",
      a3: "╦",
      a4: "╗",
      b1: "║",
      b2: " ",
      b3: "║",
      b4: "║",
      c1: "╠",
      c2: "═",
      c3: "╬",
      c4: "╣",
      d1: "║",
      d2: " ",
      d3: "║",
      d4: "║",
      e1: "╚",
      e2: "═",
      e3: "╩",
      e4: "╝"
    """

  defmacro __using__(table) do

    quote do
      @header_border %Scribe.Border{
        bottom_edge: unquote(table[:e2]),
        bottom_left_corner: unquote(table[:e1]),
        bottom_right_corner: unquote(table[:e4]),
        top_edge: unquote(table[:a2]),
        top_left_corner: unquote(table[:a1]),
        top_right_corner: unquote(table[:a4]),
        left_edge: unquote(table[:b1]),
        right_edge: unquote(table[:b4])
      }
      @empty_border %Scribe.Border{
        bottom_edge: "",
        bottom_left_corner: "",
        bottom_right_corner: "",
        top_edge: "",
        top_left_corner: "",
        top_right_corner: "",
        left_edge: unquote(table[:d1]),
        right_edge: unquote(table[:d4])
      }

      def border_at(0, col, _max_rows, max_cols) when col < max_cols - 1 do
        %Scribe.Border{
          @header_border
          | bottom_left_corner: unquote(table[:c1]),
            bottom_right_corner: unquote(table[:c3]),
            top_right_corner: unquote(table[:a3])
        }
      end

      def border_at(0, _col, _max_rows, _max_cols) do
        %Scribe.Border{
          @header_border
          | bottom_left_corner: unquote(table[:c1]),
            bottom_right_corner: unquote(table[:c4])
        }
      end

      def border_at(row, col, max_rows, max_cols)
          when row == max_rows - 1 and col < max_cols - 1 do
        %Scribe.Border{
          @header_border
          | top_left_corner: "",
            top_right_corner: "",
            bottom_right_corner: unquote(table[:e3])
        }
      end

      def border_at(row, _col, max_rows, _max_cols) when row == max_rows - 1 do
        %Scribe.Border{
          @header_border
          | top_left_corner: "",
            top_right_corner: ""
        }
      end

      def border_at(_row, _col, _max_rows, _max_cols) do
        @empty_border
      end
    end
  end
end
