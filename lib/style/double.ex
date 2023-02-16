defmodule Scribe.Style.Double do
  @moduledoc """
  double style

  ## example
  iex>  t = %Scribe.StyleTest{}
  iex>  opts = [colorize: false, style: Scribe.Style.Double]
  iex>  Scribe.format([t, t, t], opts)
  "\""
  ╔════════════════════╦═══════╦══════════╗
  ║ :__struct__        ║ :id   ║ :value   ║
  ╠════════════════════╬═══════╬══════════╣
  ║ Scribe.StyleTest   ║ nil   ║ 1234     ║
  ║ Scribe.StyleTest   ║ nil   ║ 1234     ║
  ║ Scribe.StyleTest   ║ nil   ║ 1234     ║
  ╚════════════════════╩═══════╩══════════╝
  "\""
  """

  @behaviour Scribe.Style
  use Scribe.DefaultColors

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
end
