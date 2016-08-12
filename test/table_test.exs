defmodule Scribe.TableTest do
  use ExUnit.Case

  test "format/3 returns formatted table string" do
    data = [["test", 1234, "longer string"], [0, nil, :whatever]]

    expected = """
    +--------+------+-----------------+
    | "test" | 1234 | "longer string" |
    +--------+------+-----------------+
    | 0      | nil  | :whatever       |
    +--------+------+-----------------+
    """

    assert Scribe.Table.format(data, 2, 3) == expected
  end
end
