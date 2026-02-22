defmodule Scribe.TableTest do
  use ExUnit.Case

  alias Scribe.Table

  test "format/3 returns formatted table string" do
    data = [
      [~s("test"), ~s(1234), ~s("longer string")],
      [~s(0), ~s(nil), ~s(:whatever)]
    ]

    expected = """
    +--------------------+------------+-----------------------------+
    | \"\\\"test\\\"\"         | \"1234\"     | \"\\\"longer string\\\"\"         |
    +--------------------+------------+-----------------------------+
    | \"0\"                | \"nil\"      | \":whatever\"                 |
    +--------------------+------------+-----------------------------+
    """

    assert Table.format(data, 2, 3, colorize: false) == expected
  end

  describe "table_style/1" do
    test "returns default style when no style option" do
      assert Table.table_style([]) == Scribe.Style.Default
    end

    test "returns specified style" do
      assert Table.table_style(style: Scribe.Style.Psql) == Scribe.Style.Psql
    end
  end

  describe "total_width/0" do
    test "defaults to :infinity" do
      assert Table.total_width() == :infinity
    end
  end

  describe "printable_width/1" do
    test "returns :infinity when no width specified" do
      assert Table.printable_width([]) == :infinity
    end

    test "subtracts 8 from specified width" do
      assert Table.printable_width(width: 80) == 72
    end
  end
end
