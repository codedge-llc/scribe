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
end
