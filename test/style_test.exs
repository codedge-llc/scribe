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

  describe "double" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}
      refute t.id
      assert t.value == 1234

      # Whitespace stripping breaks docstrings
      expected =
        "╔════════════════════╦═══════╦══════════╗\n" <>
          "║ :__struct__        ║ :id   ║ :value   ║\n" <>
          "╠════════════════════╬═══════╬══════════╣\n" <>
          "║ Scribe.StyleTest   ║ nil   ║ 1234     ║\n" <>
          "║ Scribe.StyleTest   ║ nil   ║ 1234     ║\n" <>
          "║ Scribe.StyleTest   ║ nil   ║ 1234     ║\n" <>
          "╚════════════════════╩═══════╩══════════╝\n"

      opts = [colorize: false, style: Scribe.Style.Double]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "html" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}
      refute t.id
      assert t.value == 1234

      # Whitespace stripping breaks docstrings
      expected =
        "<table><tr><th> :__struct__        </th><th> :id   </th><th> :value   </th></tr>\n" <>
          "<tr><td> Scribe.StyleTest   </td><td> nil   </td><td> 1234     </td></tr>\n" <>
          "<tr><td> Scribe.StyleTest   </td><td> nil   </td><td> 1234     </td></tr>\n" <>
          "<tr><td> Scribe.StyleTest   </td><td> nil   </td><td> 1234     \n</td></tr></table>\n"

      opts = [colorize: false, style: Scribe.Style.Html]
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
end
