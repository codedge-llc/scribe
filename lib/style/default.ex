defmodule Scribe.Style.Default do
  @moduledoc ~S"""
  Default styling for tables.
  """
  alias Scribe.Border

  @behaviour Scribe.Style

  def border_at(_row, _columns, _max_rows, _max_cols) do
    Border.new("+", "|", "-")
  end

  use Scribe.DefaultColors
end
