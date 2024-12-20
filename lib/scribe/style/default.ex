defmodule Scribe.Style.Default do
  @moduledoc """
  Default style.

  ## Examples

      iex> Scribe.print(data, style: Scribe.Style.Default)

      +-------+-----------------------------------+------------------------+
      | :id   | :inserted_at                      | :key                   |
      +-------+-----------------------------------+------------------------+
      | 457   | "2017-03-27 14:42:34.095202Z"     | "CEB0E055ECDF6028"     |
      | 326   | "2017-03-27 14:42:34.097519Z"     | "CF67027F7235B88D"     |
      | 756   | "2017-03-27 14:42:34.097553Z"     | "DE016DFF477BEDDB"     |
      | 484   | "2017-03-27 14:42:34.097572Z"     | "9194A82EF4BB0123"     |
      | 780   | "2017-03-27 14:42:34.097591Z"     | "BF92748B4AAAF14A"     |
      +-------+-----------------------------------+------------------------+
  """

  alias Scribe.Border

  @behaviour Scribe.Style

  @impl true
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
