defmodule Scribe.Style.NoBorder do
  @moduledoc false

  alias Scribe.Border

  @behaviour Scribe.Style

  def border_at(_row, _col, _max_rows, _max_cols), do: %Border{}

  use Scribe.DefaultColors
end
