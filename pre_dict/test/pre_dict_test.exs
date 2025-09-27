defmodule PreDictTest do
  use ExUnit.Case
  doctest PreDict
  alias PreDict
  use ExUnitProperties

  # -------------------
  # Обычные unit-тесты
  # -------------------

  test "put and get" do
    dict =
      PreDict.new()
      |> PreDict.put(1, "a")
      |> PreDict.put(2, "b")

    assert PreDict.get(dict, 1) == "a"
    assert PreDict.get(dict, 2) == "b"
    assert PreDict.get(dict, 3, :not_found) == :not_found
  end

  test "put overwrites value without changing size" do
    dict =
      PreDict.new()
      |> PreDict.put(1, "a")
      |> PreDict.put(1, "b")

    assert PreDict.size(dict) == 1
    assert PreDict.get(dict, 1) == "b"
  end

  test "map changes values" do
    dict =
      PreDict.new()
      |> PreDict.put(1, 10)
      |> PreDict.put(2, 20)

    mapped = PreDict.map(dict, fn v -> v * 2 end)

    assert PreDict.get(mapped, 1) == 20
    assert PreDict.get(mapped, 2) == 40
  end

  test "map does not change keys" do
    dict =
      PreDict.new()
      |> PreDict.put(1, 10)
      |> PreDict.put(2, 20)

    mapped = PreDict.map(dict, fn v -> v * 2 end)

    keys_orig = PreDict.foldl(dict, [], fn {k, _}, acc -> [k | acc] end) |> Enum.sort()
    keys_mapped = PreDict.foldl(mapped, [], fn {k, _}, acc -> [k | acc] end) |> Enum.sort()

    assert keys_orig == keys_mapped
  end

  test "filter keeps only matching" do
    dict =
      PreDict.new()
      |> PreDict.put(1, 10)
      |> PreDict.put(2, 20)
      |> PreDict.put(3, 30)

    filtered = PreDict.filter(dict, fn {_k, v} -> v > 15 end)

    assert PreDict.get(filtered, 1, :none) == :none
    assert PreDict.get(filtered, 2) == 20
    assert PreDict.get(filtered, 3) == 30
  end

  test "foldl sums values" do
    dict =
      PreDict.new()
      |> PreDict.put(1, 10)
      |> PreDict.put(2, 20)

    sum = PreDict.foldl(dict, 0, fn {_k, v}, acc -> v + acc end)
    assert sum == 30
  end

  test "foldr collects in reverse order of foldl" do
    dict =
      PreDict.new()
      |> PreDict.put(1, "a")
      |> PreDict.put(2, "b")
      |> PreDict.put(3, "c")

    left = PreDict.foldl(dict, [], fn {_, v}, acc -> [v | acc] end)
    right = PreDict.foldr(dict, [], fn {_, v}, acc -> [v | acc] end)

    assert left == Enum.reverse(right)
  end

  test "delete removes key" do
    dict =
      PreDict.new()
      |> PreDict.put(1, "a")
      |> PreDict.put(2, "b")

    dict2 = PreDict.delete(dict, 1)
    assert PreDict.get(dict2, 1, :none) == :none
    assert PreDict.get(dict2, 2) == "b"
  end

  test "delete node with two children" do
    dict =
      PreDict.new()
      |> PreDict.put(2, "root")
      |> PreDict.put(1, "left")
      |> PreDict.put(3, "right")

    dict2 = PreDict.delete(dict, 2)

    assert PreDict.get(dict2, 2, :none) == :none
    assert PreDict.get(dict2, 1) == "left"
    assert PreDict.get(dict2, 3) == "right"
  end
end
