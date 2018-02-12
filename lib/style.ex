defmodule Scribe.Style do
  @moduledoc """
  Defines styling callbacks for table printing.
  """

  @doc ~S"""
  Returns default configured style.

  Configure in your `mix.exs`
  ```elixir
  config :scribe, style: Scribe.Style.Psql
  ```

  Defaults to `Scribe.Style.Default` if not specified.
  """
  def default do
    Application.get_env(:scribe, :style, Scribe.Style.Default)
  end

  @callback border_at(
              row :: integer,
              column :: integer,
              row_max :: integer,
              column_max :: integer
            ) :: Scribe.Border.t()

  @callback color(value :: term) :: IO.ANSI.ansidata()
end
