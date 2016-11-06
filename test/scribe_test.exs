defmodule Scribe.ScribeTest do
  defstruct id: nil, value: 1234
  use ExUnit.Case
  doctest Scribe

  describe "format/2" do
    test "includes __meta__ and __struct__ attributes" do
      t = %Scribe.ScribeTest{}
      refute t.id
      assert t.value == 1234

      expected = """
      +-----+--------+
      | :id | :value |
      +-----+--------+
      | nil | 1234   |
      +-----+--------+
      """

      assert Scribe.format([t]) == expected
      IO.puts Scribe.format([t])
    end

    test "accepts single element as data" do
      t = %Scribe.ScribeTest{}
      refute t.id
      assert t.value == 1234

      expected = """
      +-----+--------+
      | :id | :value |
      +-----+--------+
      | nil | 1234   |
      +-----+--------+
      """

      assert Scribe.format(t) == expected
    end

    test "formats multiple rows of data" do
      t = %Scribe.ScribeTest{}
      refute t.id
      assert t.value == 1234

      expected = """
      +-----+--------+
      | :id | :value |
      +-----+--------+
      | nil | 1234   |
      +-----+--------+
      | nil | 1234   |
      +-----+--------+
      | nil | 1234   |
      +-----+--------+
      """

      assert Scribe.format([t, t, t]) == expected
    end

    test "maps as data source" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +-----------+-------+
      | :key      | :test |
      +-----------+-------+
      | "testing" | 1234  |
      +-----------+-------+
      """

      assert Scribe.format([t]) == expected
    end

    test "displays only specified keys" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +-----------+
      | :key      |
      +-----------+
      | "testing" |
      +-----------+
      """

      assert Scribe.format([t], [:key]) == expected
    end

    test "displays specified keys with given titles" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +-----------+
      | :title    |
      +-----------+
      | "testing" |
      +-----------+
      """

      assert Scribe.format([t], [title: :key]) == expected
    end

    test "displays specified keys with given titles, some untitled" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +-----------+-------+
      | :title    | :test |
      +-----------+-------+
      | "testing" | 1234  |
      +-----------+-------+
      """

      assert Scribe.format([t], [{:title, :key}, :test]) == expected
    end

    test "does function with given title" do
      t = %{test: 1234, key: "testing"}

      expected = """
      +-----------+
      | "Caps"    |
      +-----------+
      | "TESTING" |
      +-----------+
      """

      assert Scribe.format([t], [{"Caps", fn(x) -> String.upcase(x.key) end}]) == expected
    end
  end
end
