defmodule PreDictTest do
  use ExUnit.Case
  doctest PreDict
  alias PreDict
  use ExUnitProperties


  test "put and get" do
    dict = PreDict.new()
           |> PreDict.put(1, "a")
           |> PreDict.put(2, "b")

    assert PreDict.get(dict, 1) == "a"
    assert PreDict.get(dict, 2) == "b"
    assert PreDict.get(dict, 3, :not_found) == :not_found
  end


  test "map changes values" do
  dict = PreDict.new()
         |> PreDict.put(1, 10)
         |> PreDict.put(2, 20)

  mapped = PreDict.map(dict, fn v -> v * 2 end)

  assert PreDict.get(mapped, 1) == 20
  assert PreDict.get(mapped, 2) == 40
end


test "filter keeps only matching" do
  dict = PreDict.new()
         |> PreDict.put(1, 10)
         |> PreDict.put(2, 20)
         |> PreDict.put(3, 30)

  filtered = PreDict.filter(dict, fn {_k, v} -> v > 15 end)

  assert PreDict.get(filtered, 1, :none) == :none
  assert PreDict.get(filtered, 2) == 20
  assert PreDict.get(filtered, 3) == 30
end


test "foldl sums values" do
  dict = PreDict.new()
         |> PreDict.put(1, 10)
         |> PreDict.put(2, 20)

  sum = PreDict.foldl(dict, 0, fn {_k, v}, acc -> v + acc end)
  assert sum == 30
end


test "delete removes key" do
  dict = PreDict.new()
         |> PreDict.put(1, "a")
         |> PreDict.put(2, "b")

  dict2 = PreDict.delete(dict, 1)
  assert PreDict.get(dict2, 1, :none) == :none
  assert PreDict.get(dict2, 2) == "b"
end

test "combine merges two dicts" do
  d1 = PreDict.new() |> PreDict.put(1, "a")
  d2 = PreDict.new() |> PreDict.put(2, "b")

  combined = PreDict.combine(d1, d2)

  assert PreDict.get(combined, 1) == "a"
  assert PreDict.get(combined, 2) == "b"
end

property "combine with empty is identity" do
  check all kvs <- list_of({integer(), integer()}) do
    dict = Enum.reduce(kvs, PreDict.new(), fn {k,v}, acc -> PreDict.put(acc, k, v) end)

    assert normalize(dict) == normalize(PreDict.combine(dict, PreDict.empty()))
    assert normalize(dict) == normalize(PreDict.combine(PreDict.empty(), dict))
  end
end

defp normalize(dict) do
  PreDict.foldl(dict, [], fn {k,v}, acc -> [{k,v} | acc] end)
  |> Enum.sort()
end



end
