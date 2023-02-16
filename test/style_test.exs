defmodule Scribe.StyleTest do
  defstruct id: nil, value: 1234
  use ExUnit.Case
  doctest Scribe.Style.Default
  doctest Scribe.Style.Double
  doctest Scribe.Style.Fancy
  doctest Scribe.Style.Full
  doctest Scribe.Style.Html
  doctest Scribe.Style.NoBorder
  doctest Scribe.Style.Pseudo
  doctest Scribe.Style.Psql
  doctest Scribe.Style.GithubMarkdown
end
