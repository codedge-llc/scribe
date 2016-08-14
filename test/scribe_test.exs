defmodule Scribe.ScribeTest do
  defstruct id: nil, value: 1234
  use ExUnit.Case
  doctest Scribe

  describe "format/2" do
    test "does not include __meta__ or __struct__ attributes" do
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
  end
end
