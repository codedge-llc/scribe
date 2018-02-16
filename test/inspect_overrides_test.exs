defmodule Scribe.InspectOverridesTest do
  defstruct id: nil, value: 1234

  use ExUnit.Case

  test "empty list inspects correctly" do
    assert inspect([]) == "[]"
  end

  test "normal lists inspect correctly" do
    assert inspect([1, 2, 3]) == "[1, 2, 3]"
  end

  test "single map formats correctly" do
    t = %{test: 1234, key: "testing"}

    expected = """
    \e[39m+---------------+---------+
    |\e[36m :key          \e[0m|\e[36m :test   \e[0m|
    +---------------+---------+
    |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
    +---------------+---------+
    """

    assert inspect(t) == expected
  end

  test "list of maps format correctly" do
    t = %{test: 1234, key: "testing"}

    expected = """
    \e[39m+---------------+---------+
    |\e[36m :key          \e[0m|\e[36m :test   \e[0m|
    +---------------+---------+
    |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
    |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
    |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
    +---------------+---------+
    """

    assert inspect([t, t, t]) == expected
  end

  test "struct formats correctly" do
    t = %Scribe.InspectOverridesTest{}

    expected = """
    \e[39m+-------------------------------+-------+----------+
    |\e[36m :__struct__                   \e[0m|\e[36m :id   \e[0m|\e[36m :value   \e[0m|
    +-------------------------------+-------+----------+
    |\e[36m Scribe.InspectOverridesTest   \e[0m|\e[35m nil   \e[0m|\e[33m 1234     \e[0m|
    +-------------------------------+-------+----------+
    """

    assert inspect(t) == expected
  end

  test "list of structs format correctly" do
    t = %Scribe.InspectOverridesTest{}

    expected = """
    \e[39m+-------------------------------+-------+----------+
    |\e[36m :__struct__                   \e[0m|\e[36m :id   \e[0m|\e[36m :value   \e[0m|
    +-------------------------------+-------+----------+
    |\e[36m Scribe.InspectOverridesTest   \e[0m|\e[35m nil   \e[0m|\e[33m 1234     \e[0m|
    |\e[36m Scribe.InspectOverridesTest   \e[0m|\e[35m nil   \e[0m|\e[33m 1234     \e[0m|
    |\e[36m Scribe.InspectOverridesTest   \e[0m|\e[35m nil   \e[0m|\e[33m 1234     \e[0m|
    +-------------------------------+-------+----------+
    """

    assert inspect([t, t, t]) == expected
  end

  test "Scribe.disable turns off formatting" do
    Scribe.disable()

    t = %{test: 1234, key: "testing"}

    expected = "%{key: \"testing\", test: 1234}"

    assert inspect(t) == expected

    Scribe.enable()
  end
end
