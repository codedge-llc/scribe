defmodule Scribe.Formatter.LineTest do
  use ExUnit.Case

  alias Scribe.Formatter.Line

  describe "cell/3" do
    test "left-aligns by default" do
      result = Line.cell("hello", 15)
      assert result == " \"hello\"       "
    end

    test "right-aligns with :right" do
      result = Line.cell("hello", 15, :right)
      assert result == "       \"hello\" "
    end

    test "center-aligns with :center" do
      result = Line.cell("hello", 15, :center)
      assert result =~ "\"hello\""
    end
  end

  describe "cell_value/3" do
    test "returns padded cell string" do
      result = Line.cell_value("test", 5, 100)
      assert result == " \"test\"      "
    end

    test "truncates to max_width" do
      result = Line.cell_value("test", 0, 5)
      assert String.length(result) <= 6
    end
  end

  describe "colorize/2" do
    test "wraps string with color and reset" do
      result = Line.colorize("hello", IO.ANSI.red())
      assert result == "#{IO.ANSI.red()}hello#{IO.ANSI.reset()}"
    end
  end

  describe "add_newline/1" do
    test "returns empty string for empty input" do
      assert Line.add_newline("") == ""
    end

    test "appends newline to non-empty string" do
      assert Line.add_newline("test") == "test\n"
    end
  end
end
