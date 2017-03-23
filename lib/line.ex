defmodule Scribe.Table.Line do

  def frame_line(widths, style) do
    if style.display_frame? do
      frame_h = style.frame_horizontal
      frame_c = style.frame_corner
      frame_i = style.frame_intersection

      segments =
        Enum.map(widths, fn(width) ->
          String.duplicate(frame_h, width)
        end)

      frame_c <> Enum.join(segments, frame_i) <> frame_c <> "\n"
    else
      ""
    end
  end

  def header_separator_line(widths, style) do
    if style.separate_header_line? do
      header_h = style.header_horizontal_separator
      header_i = style.header_intersection
      frame_i = style.frame_intersection

      segments =
        Enum.map(widths, fn(width) ->
          String.duplicate(header_h, width)
        end)

      frame_i <> Enum.join(segments, header_i) <> frame_i <> "\n"
    else
      ""
    end
  end

  def data_separator_line(widths, style) do
    if style.separate_data_line? do
      data_h = style.data_horizontal_separator
      data_i = style.data_intersection
      frame_i = style.frame_intersection

      segments =
        Enum.map(widths, fn(width) ->
          String.duplicate(data_h, width)
        end)

      frame_i <> Enum.join(segments, data_i) <> frame_i <> "\n"
    else
      ""
    end
  end
end
