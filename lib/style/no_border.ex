defmodule Scribe.Style.NoBorder do
  @moduledoc """
  no border style

  ## example
  iex>  t = %Scribe.StyleTest{}
  iex>  opts = [colorize: false, style: Scribe.Style.NoBorder]
  iex>  Scribe.format([t, t, t], opts)
  "\""
   :__struct__         :id    :value   
   Scribe.StyleTest    nil    1234     
   Scribe.StyleTest    nil    1234     
   Scribe.StyleTest    nil    1234     
  "\""
  """
  alias Scribe.Border

  @behaviour Scribe.Style

  def border_at(_row, _col, _max_rows, _max_cols), do: %Border{}

  use Scribe.DefaultColors
end
