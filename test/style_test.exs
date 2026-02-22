defmodule Scribe.StyleTest do
  defstruct id: nil, value: 1234
  use ExUnit.Case

  describe "default" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}
      refute t.id
      assert t.value == 1234

      # Whitespace stripping breaks docstrings
      expected =
        "+--------------------+-------+----------+\n" <>
          "| :__struct__        | :id   | :value   |\n" <>
          "+--------------------+-------+----------+\n" <>
          "| Scribe.StyleTest   | nil   | 1234     |\n" <>
          "| Scribe.StyleTest   | nil   | 1234     |\n" <>
          "| Scribe.StyleTest   | nil   | 1234     |\n" <>
          "+--------------------+-------+----------+\n"

      opts = [colorize: false, style: Scribe.Style.Default]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "psql" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}
      refute t.id
      assert t.value == 1234

      # Whitespace stripping breaks docstrings
      expected =
        "                                       \n" <>
          " :__struct__        | :id   | :value   \n" <>
          "--------------------+-------+----------\n" <>
          " Scribe.StyleTest   | nil   | 1234     \n" <>
          " Scribe.StyleTest   | nil   | 1234     \n" <>
          " Scribe.StyleTest   | nil   | 1234     \n"

      opts = [colorize: false, style: Scribe.Style.Psql]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "github_markdown" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}
      refute t.id
      assert t.value == 1234

      # Whitespace stripping breaks docstrings
      expected =
        "                                         \n" <>
          "| :__struct__        | :id   | :value   |\n" <>
          "|--------------------|-------|----------|\n" <>
          "| Scribe.StyleTest   | nil   | 1234     |\n" <>
          "| Scribe.StyleTest   | nil   | 1234     |\n" <>
          "| Scribe.StyleTest   | nil   | 1234     |\n"

      opts = [colorize: false, style: Scribe.Style.GithubMarkdown]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "pseudo" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}
      refute t.id
      assert t.value == 1234

      # Whitespace stripping breaks docstrings
      expected =
        "┌────────────────────┬───────┬──────────┐\n" <>
          "│ :__struct__        │ :id   │ :value   │\n" <>
          "├────────────────────┼───────┼──────────┤\n" <>
          "│ Scribe.StyleTest   │ nil   │ 1234     │\n" <>
          "│ Scribe.StyleTest   │ nil   │ 1234     │\n" <>
          "│ Scribe.StyleTest   │ nil   │ 1234     │\n" <>
          "└────────────────────┴───────┴──────────┘\n"

      opts = [colorize: false, style: Scribe.Style.Pseudo]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "no_border" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}
      refute t.id
      assert t.value == 1234

      # Whitespace stripping breaks docstrings
      expected =
        " :__struct__         :id    :value   \n" <>
          " Scribe.StyleTest    nil    1234     \n" <>
          " Scribe.StyleTest    nil    1234     \n" <>
          " Scribe.StyleTest    nil    1234     \n"

      opts = [colorize: false, style: Scribe.Style.NoBorder]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "colorized output" do
    @color_data [
      %{a: true, b: nil, c: 42, d: "hello", e: :ok, f: {1, 2}}
    ]

    test "default style with colors" do
      result = Scribe.format(@color_data, style: Scribe.Style.Default)
      assert is_binary(result)
      assert result =~ IO.ANSI.reset()
    end

    test "psql style with colors" do
      result = Scribe.format(@color_data, style: Scribe.Style.Psql)
      assert is_binary(result)
      assert result =~ IO.ANSI.reset()
    end

    test "github_markdown style with colors" do
      result = Scribe.format(@color_data, style: Scribe.Style.GithubMarkdown)
      assert is_binary(result)
      assert result =~ IO.ANSI.reset()
    end

    test "pseudo style with colors" do
      result = Scribe.format(@color_data, style: Scribe.Style.Pseudo)
      assert is_binary(result)
      assert result =~ IO.ANSI.reset()
    end

    test "no_border style with colors" do
      result = Scribe.format(@color_data, style: Scribe.Style.NoBorder)
      assert is_binary(result)
      assert result =~ IO.ANSI.reset()
    end
  end
end
