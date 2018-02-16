defmodule Scribe.ScribeTest do
  defstruct id: nil, value: 1234

  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "format/2" do
    test "includes __struct__ attributes" do
      t = %Scribe.ScribeTest{}
      refute t.id
      assert t.value == 1234

      expected = """
      +---------------------+-------+----------+
      | :__struct__         | :id   | :value   |
      +---------------------+-------+----------+
      | Scribe.ScribeTest   | nil   | 1234     |
      +---------------------+-------+----------+
      """

      actual = Scribe.format([t], colorize: false)
      assert actual == expected
    end

    test "accepts single element as data" do
      t = %Scribe.ScribeTest{}
      refute t.id
      assert t.value == 1234

      expected = """
      +---------------------+-------+----------+
      | :__struct__         | :id   | :value   |
      +---------------------+-------+----------+
      | Scribe.ScribeTest   | nil   | 1234     |
      +---------------------+-------+----------+
      """

      actual = Scribe.format(t, colorize: false)
      assert actual == expected
    end

    test "formats multiple rows of data" do
      t = %Scribe.ScribeTest{}
      refute t.id
      assert t.value == 1234

      expected = """
      +---------------------+-------+----------+
      | :__struct__         | :id   | :value   |
      +---------------------+-------+----------+
      | Scribe.ScribeTest   | nil   | 1234     |
      | Scribe.ScribeTest   | nil   | 1234     |
      | Scribe.ScribeTest   | nil   | 1234     |
      +---------------------+-------+----------+
      """

      actual = Scribe.format([t, t, t], colorize: false)
      assert actual == expected
    end

    test "maps as data source" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +---------------+---------+
      | :key          | :test   |
      +---------------+---------+
      | "testing"     | 1234    |
      +---------------+---------+
      """

      actual = Scribe.format([t], colorize: false)
      assert actual == expected
    end

    test "displays only specified keys" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +---------------+
      | :key          |
      +---------------+
      | "testing"     |
      +---------------+
      """

      actual = Scribe.format([t], data: [:key], colorize: false)
      assert actual == expected
    end

    test "displays specified keys with given titles" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +---------------+
      | :title        |
      +---------------+
      | "testing"     |
      +---------------+
      """

      actual = Scribe.format([t], data: [title: :key], colorize: false)
      assert actual == expected
    end

    test "displays specified keys with given titles, some untitled" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +---------------+---------+
      | :title        | :test   |
      +---------------+---------+
      | "testing"     | 1234    |
      +---------------+---------+
      """

      actual =
        Scribe.format(
          [t],
          data: [{:title, :key}, :test],
          colorize: false
        )

      assert actual == expected
    end

    test "does function with given title" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +---------------+
      | "Caps"        |
      +---------------+
      | "TESTING"     |
      +---------------+
      """

      actual =
        Scribe.format(
          [t],
          data: [{"Caps", fn x -> String.upcase(x.key) end}],
          colorize: false
        )

      assert actual == expected
    end

    test "respects width option" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +-------------------------+-----------------+
      | :title                  | :test           |
      +-------------------------+-----------------+
      | "testing"               | 1234            |
      +-------------------------+-----------------+
      """

      actual =
        Scribe.format(
          [t],
          data: [{:title, :key}, :test],
          colorize: false,
          width: 50
        )

      assert actual == expected
    end
  end

  test "print/2 outputs proper IO" do
    fun = fn -> Scribe.print(%{test: 1234}, colorize: false) end
    exp = "+---------+\n| :test   |\n+---------+\n| 1234    |\n+---------+\n\n"
    assert capture_io(fun) == exp
  end
end
