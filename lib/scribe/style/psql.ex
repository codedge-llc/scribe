defmodule Scribe.Style.Psql do
  @moduledoc ~S"""
  Psql style.

  ## Examples

      iex> Scribe.print(data, style: Scribe.Style.Psql)

       :id   | :inserted_at                      | :key
      -------+-----------------------------------+------------------------
       700   | "2017-03-27 14:41:33.411442Z"     | "A2FA80D0F6DF9388"
       890   | "2017-03-27 14:41:33.412955Z"     | "F95094328A91D950"
       684   | "2017-03-27 14:41:33.412991Z"     | "1EAC6B28045ED644"
       531   | "2017-03-27 14:41:33.413015Z"     | "DC2377B696355642"
       648   | "2017-03-27 14:41:33.413037Z"     | "EA9311B4683A52B3"
  """

  @behaviour Scribe.Style

  use Scribe.DefaultColors

  # Top left cell
  @impl true
  def border_at(0, 0, _, _) do
    %Scribe.Border{
      bottom_edge: "-",
      bottom_left_corner: "",
      bottom_right_corner: "+",
      top_edge: " ",
      top_left_corner: "",
      top_right_corner: " ",
      left_edge: "",
      right_edge: "|"
    }
  end

  # Top right cell
  def border_at(0, col, _, max) when col == max - 1 do
    %Scribe.Border{
      top_left_corner: " ",
      top_edge: " ",
      top_right_corner: "",
      right_edge: "",
      bottom_right_corner: "",
      bottom_edge: "-",
      bottom_left_corner: "+",
      left_edge: "|"
    }
  end

  # All other top-row cells
  def border_at(0, _, _, _) do
    %Scribe.Border{
      top_left_corner: " ",
      top_edge: " ",
      top_right_corner: " ",
      right_edge: "|",
      bottom_right_corner: "+",
      bottom_edge: "-",
      bottom_left_corner: "+",
      left_edge: "|"
    }
  end

  # First column cells
  def border_at(_, 0, _, _) do
    %Scribe.Border{
      top_left_corner: "",
      top_edge: "",
      top_right_corner: "",
      right_edge: "|",
      bottom_right_corner: "",
      bottom_edge: "",
      bottom_left_corner: "",
      left_edge: ""
    }
  end

  # Last column cells
  def border_at(_, col, _, max) when col == max - 1 do
    %Scribe.Border{
      top_left_corner: "",
      top_edge: "",
      top_right_corner: "",
      right_edge: "",
      bottom_right_corner: "",
      bottom_edge: "",
      bottom_left_corner: "",
      left_edge: "|"
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
