defmodule Scribe.Style do
  @moduledoc """
  Defines Scribe.Table styling callbacks.
  """

  def default do
    Application.get_env(:scribe, :style, Scribe.Style.Default)
  end

  @callback border_at(row :: integer,
                      column :: integer,
                      row_max :: integer,
                      column_max:: integer) :: Scribe.Border.t

  @callback color(value :: term) :: IO.ANSI.ansidata()
end
