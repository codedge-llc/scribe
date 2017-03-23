defmodule Scribe.TableStyle do
  @moduledoc """
  Defines Scribe.Table styling callbacks.
  """

  def default, do: Scribe.TableStyle.Default

  @callback display_frame? :: boolean
  @callback separate_header_line? :: boolean
  @callback separate_data_line? :: boolean

  @callback frame_corner :: String.t
  @callback frame_horizontal :: String.t
  @callback frame_vertical :: String.t

  @callback header_horizontal_separator :: String.t
  @callback header_vertical_separator :: String.t
  @callback header_intersection :: String.t

  @callback data_horizontal_separator :: String.t
  @callback data_vertical_separator :: String.t
  @callback data_intersection :: String.t
end
