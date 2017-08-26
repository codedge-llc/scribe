defmodule Scribe.Style.Default do
  @moduledoc false

  alias Scribe.Border

  @behaviour Scribe.Style

  def border_at(0, _columns, _max_rows, _max_cols) do
    Border.new("+", "|", "-")
  end

  def border_at(row, _col, max_rows, _max_cols) when row == max_rows - 1 do
    Border.new("+", "|", "-")
  end

  def border_at(_row, _col, _max_rows, _max_cols) do
    %Border{
      left_edge: "|",
      right_edge: "|"
    }
  end

  use Scribe.DefaultColors
end
