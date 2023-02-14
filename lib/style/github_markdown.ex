defmodule Scribe.Style.GithubMarkdown do
  @moduledoc """
  github markdown style

  ## example
  iex>  t = %Scribe.StyleTest{}
  iex>  opts = [colorize: false, style: Scribe.Style.GithubMarkdown]
  iex>  Scribe.format([t, t, t], opts)
  "\""
                                           
  | :__struct__        | :id   | :value   |
  |--------------------|-------|----------|
  | Scribe.StyleTest   | nil   | 1234     |
  | Scribe.StyleTest   | nil   | 1234     |
  | Scribe.StyleTest   | nil   | 1234     |
  "\""
  """

  @behaviour Scribe.Style

  use Scribe.DefaultColors

  # Top row
  def border_at(0, _, _, _) do
    %Scribe.Border{
      bottom_edge: "-",
      bottom_left_corner: "|",
      bottom_right_corner: "|",
      top_edge: " ",
      top_left_corner: " ",
      top_right_corner: " ",
      left_edge: "|",
      right_edge: "|"
    }
  end

  # All other cells
  def border_at(_, _, _, _) do
    %Scribe.Border{
      top_left_corner: "",
      top_edge: "",
      top_right_corner: "",
      right_edge: "|",
      bottom_right_corner: "",
      bottom_edge: "",
      bottom_left_corner: "",
      left_edge: "|"
    }
  end
end
