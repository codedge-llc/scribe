defmodule Scribe.ScribeTest do
  use ExUnit.Case
  doctest Scribe

  test "the truth" do
    t = %Scribe.TestStruct{}
    refute t.id
    assert t.value == 1234
  end
end
