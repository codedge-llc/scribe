defmodule Scribe.Style.GithubMarkdown do
  @moduledoc ~S"""
  GitHub markdown style.

  ## Examples

      iex> Scribe.print(data, style: Scribe.Style.GithubMarkdown)

      | :id   | :inserted_at                      | :key                   |
      |-------|-----------------------------------|------------------------|
      | 457   | "2017-03-27 14:42:34.095202Z"     | "CEB0E055ECDF6028"     |
      | 326   | "2017-03-27 14:42:34.097519Z"     | "CF67027F7235B88D"     |
      | 756   | "2017-03-27 14:42:34.097553Z"     | "DE016DFF477BEDDB"     |
      | 484   | "2017-03-27 14:42:34.097572Z"     | "9194A82EF4BB0123"     |
      | 780   | "2017-03-27 14:42:34.097591Z"     | "BF92748B4AAAF14A"     |
  """

  @behaviour Scribe.Style

  use Scribe.DefaultColors

  # Top row
  @impl true
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
