defmodule Scribe.TableTest do
  use ExUnit.Case

  alias Scribe.Table

  test "format/4 returns formatted table string" do
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

  test "format/3 works with default opts" do
    data = [
      [~s("a"), ~s("b")],
      [~s(1), ~s(2)]
    ]

    result = Table.format(data, 2, 2)
    assert is_binary(result)
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

    test "returns configured width" do
      Application.put_env(:scribe, :width, 120)
      assert Table.total_width() == 120
    after
      Application.delete_env(:scribe, :width)
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
