defmodule Scribe.StyleTest do
  defstruct id: nil, value: 1234
  use ExUnit.Case
  doctest Scribe.Style.Default
  doctest Scribe.Style.Double
  doctest Scribe.Style.Fancy
  doctest Scribe.Style.Full
  doctest Scribe.Style.Html
  doctest Scribe.Style.NoBorder
  doctest Scribe.Style.Pseudo
  doctest Scribe.Style.Psql
  doctest Scribe.Style.GithubMarkdown

  describe "default" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}

      expected = """
      +--------------------+-------+----------+
      | :__struct__        | :id   | :value   |
      +--------------------+-------+----------+
      | Scribe.StyleTest   | nil   | 1234     |
      | Scribe.StyleTest   | nil   | 1234     |
      | Scribe.StyleTest   | nil   | 1234     |
      +--------------------+-------+----------+
      """

      opts = [colorize: false, style: Scribe.Style.Default]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "psql" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}

      expected = """
       :__struct__        | :id   | :value   
      --------------------+-------+----------
       Scribe.StyleTest   | nil   | 1234     
       Scribe.StyleTest   | nil   | 1234     
       Scribe.StyleTest   | nil   | 1234     
      """

      opts = [colorize: false, style: Scribe.Style.Psql]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "github_markdown" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}

      expected = """
      | :__struct__        | :id   | :value   |
      |--------------------|-------|----------|
      | Scribe.StyleTest   | nil   | 1234     |
      | Scribe.StyleTest   | nil   | 1234     |
      | Scribe.StyleTest   | nil   | 1234     |
      """

      opts = [colorize: false, style: Scribe.Style.GithubMarkdown]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "pseudo" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}

      expected = """
      ┌────────────────────┬───────┬──────────┐
      │ :__struct__        │ :id   │ :value   │
      ├────────────────────┼───────┼──────────┤
      │ Scribe.StyleTest   │ nil   │ 1234     │
      │ Scribe.StyleTest   │ nil   │ 1234     │
      │ Scribe.StyleTest   │ nil   │ 1234     │
      └────────────────────┴───────┴──────────┘
      """

      opts = [colorize: false, style: Scribe.Style.Pseudo]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "double" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}

      expected = """
      ╔════════════════════╦═══════╦══════════╗
      ║ :__struct__        ║ :id   ║ :value   ║
      ╠════════════════════╬═══════╬══════════╣
      ║ Scribe.StyleTest   ║ nil   ║ 1234     ║
      ║ Scribe.StyleTest   ║ nil   ║ 1234     ║
      ║ Scribe.StyleTest   ║ nil   ║ 1234     ║
      ╚════════════════════╩═══════╩══════════╝
      """

      opts = [colorize: false, style: Scribe.Style.Double]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "fancy" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}

      expected = """
      ╒════════════════════╤═══════╤══════════╕
      │ :__struct__        │ :id   │ :value   │
      ╞════════════════════╪═══════╪══════════╡
      │ Scribe.StyleTest   │ nil   │ 1234     │
      │ Scribe.StyleTest   │ nil   │ 1234     │
      │ Scribe.StyleTest   │ nil   │ 1234     │
      ╘════════════════════╧═══════╧══════════╛
      """

      opts = [colorize: false, style: Scribe.Style.Fancy]

      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "html" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}

      expected = """
      <table><tr><th> :__struct__        </th><th> :id   </th><th> :value   </th></tr>
      <tr><td> Scribe.StyleTest   </td><td> nil   </td><td> 1234     </td></tr>
      <tr><td> Scribe.StyleTest   </td><td> nil   </td><td> 1234     </td></tr>
      <tr><td> Scribe.StyleTest   </td><td> nil   </td><td> 1234     
      </td></tr></table>
      """

      opts = [colorize: false, style: Scribe.Style.Html]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end

  describe "no_border" do
    test "outputs correct format" do
      t = %Scribe.StyleTest{}

      expected = """
       :__struct__         :id    :value   
       Scribe.StyleTest    nil    1234     
       Scribe.StyleTest    nil    1234     
       Scribe.StyleTest    nil    1234     
      """

      opts = [colorize: false, style: Scribe.Style.NoBorder]
      actual = Scribe.format([t, t, t], opts)
      assert actual == expected
    end
  end
end
