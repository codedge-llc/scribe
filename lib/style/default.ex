defmodule Scribe.TableStyle.Default do
  @moduledoc ~S"""
  Default Scribe.Table style.
  """
  @behaviour Scribe.TableStyle

  def display_frame? do
    frame_corner() != ""
    || frame_horizontal() != ""
    || frame_vertical() != ""
    || frame_intersection() != ""
  end

  def separate_header_line? do
    header_horizontal_separator() != ""
    || header_intersection() != ""
  end

  def separate_data_line? do
    data_horizontal_separator() != ""
    || data_intersection() != ""
  end

  def frame_corner, do: "+"
  def frame_horizontal, do: "-"
  def frame_vertical, do: "|"
  def frame_intersection, do: "+"

  def header_horizontal_separator, do: "-"
  def header_vertical_separator, do: "|"
  def header_intersection, do: "+"

  def data_horizontal_separator, do: "-"
  def data_vertical_separator, do: "|"
  def data_intersection, do: "+"
end
