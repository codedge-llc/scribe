# defmodule Scribe.InspectOverridesTest do
#   defstruct id: nil, value: 1234
# 
#   use ExUnit.Case, async: false
# 
#   def set_compile_auto_inspect(enabled?) do
#     Application.put_env(:scribe, :compile_auto_inspect, enabled?)
#   end
# 
#   def set_config(enabled?) do
#     [:auto_inspect, :compile_auto_inspect]
#     |> Enum.each(&Application.put_env(:scribe, &1, enabled?))
#   end
# 
#   setup do
#     set_config(true)
#   end
# 
#   test "empty list inspects correctly" do
#     assert inspect([]) == "[]"
#   end
# 
#   test "normal lists inspect correctly" do
#     assert inspect([1, 2, 3]) == "[1, 2, 3]"
#   end
# 
#   test "single map formats correctly" do
#     t = %{test: 1234, key: "testing"}
# 
#     expected = """
#     \e[39m+---------------+---------+
#     |\e[36m :key          \e[0m|\e[36m :test   \e[0m|
#     +---------------+---------+
#     |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
#     +---------------+---------+
#     """
# 
#     assert inspect(t) == expected
#   end
# 
#   test "list of maps format correctly" do
#     t = %{test: 1234, key: "testing"}
# 
#     expected = """
#     \e[39m+---------------+---------+
#     |\e[36m :key          \e[0m|\e[36m :test   \e[0m|
#     +---------------+---------+
#     |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
#     |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
#     |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
#     +---------------+---------+
#     """
# 
#     assert inspect([t, t, t]) == expected
#   end
# 
#   test "struct formats correctly" do
#     t = %Scribe.InspectOverridesTest{}
# 
#     expected = """
#     \e[39m+-------------------------------+-------+----------+
#     |\e[36m :__struct__                   \e[0m|\e[36m :id   \e[0m|\e[36m :value   \e[0m|
#     +-------------------------------+-------+----------+
#     |\e[36m Scribe.InspectOverridesTest   \e[0m|\e[35m nil   \e[0m|\e[33m 1234     \e[0m|
#     +-------------------------------+-------+----------+
#     """
# 
#     assert inspect(t) == expected
#   end
# 
#   test "list of structs format correctly" do
#     t = %Scribe.InspectOverridesTest{}
# 
#     expected = """
#     \e[39m+-------------------------------+-------+----------+
#     |\e[36m :__struct__                   \e[0m|\e[36m :id   \e[0m|\e[36m :value   \e[0m|
#     +-------------------------------+-------+----------+
#     |\e[36m Scribe.InspectOverridesTest   \e[0m|\e[35m nil   \e[0m|\e[33m 1234     \e[0m|
#     |\e[36m Scribe.InspectOverridesTest   \e[0m|\e[35m nil   \e[0m|\e[33m 1234     \e[0m|
#     |\e[36m Scribe.InspectOverridesTest   \e[0m|\e[35m nil   \e[0m|\e[33m 1234     \e[0m|
#     +-------------------------------+-------+----------+
#     """
# 
#     assert inspect([t, t, t]) == expected
#   end
# 
#   test "Scribe.auto_inspect? returns correct status for config options" do
#     # {:compile_auto_inspect, :auto_inspect, Scribe.enabled?()}
#     [
#       {true, true, true},
#       {true, false, false},
#       {false, true, false},
#       {false, false, false}
#     ]
#     |> Enum.each(fn {compile?, enable?, result} ->
#       set_compile_auto_inspect(compile?)
#       Scribe.auto_inspect(enable?)
#       assert Scribe.auto_inspect?() == result
#     end)
# 
#     on_exit(fn -> set_config(true) end)
#   end
# 
#   test "formatting is used when Scribe.auto_inspect?()" do
#     set_config(false)
# 
#     t = %{test: 1234, key: "testing"}
# 
#     assert inspect(t) == "%{key: \"testing\", test: 1234}"
# 
#     set_config(true)
# 
#     expected = """
#     \e[39m+---------------+---------+
#     |\e[36m :key          \e[0m|\e[36m :test   \e[0m|
#     +---------------+---------+
#     |\e[32m \"testing\"     \e[0m|\e[33m 1234    \e[0m|
#     +---------------+---------+
#     """
# 
#     assert inspect(t) == expected
# 
#     on_exit(fn -> set_config(true) end)
#   end
# end
