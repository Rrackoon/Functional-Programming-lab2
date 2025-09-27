defmodule PreDictPropertiesTest do
  use ExUnit.Case
  use ExUnitProperties
  alias PreDict

  property "combine with empty is identity" do
    check all(kvs <- list_of({integer(), integer()})) do
      dict = Enum.reduce(kvs, PreDict.new(), fn {k, v}, acc -> PreDict.put(acc, k, v) end)

      assert PreDict.equal?(dict, PreDict.combine(dict, PreDict.empty()))
      assert PreDict.equal?(dict, PreDict.combine(PreDict.empty(), dict))
    end
  end

  property "combine is associative" do
    check all(
            kvs1 <- list_of({integer(), integer()}),
            kvs2 <- list_of({integer(), integer()}),
            kvs3 <- list_of({integer(), integer()})
          ) do
      d1 = Enum.reduce(kvs1, PreDict.new(), fn {k, v}, acc -> PreDict.put(acc, k, v) end)
      d2 = Enum.reduce(kvs2, PreDict.new(), fn {k, v}, acc -> PreDict.put(acc, k, v) end)
      d3 = Enum.reduce(kvs3, PreDict.new(), fn {k, v}, acc -> PreDict.put(acc, k, v) end)

      left = PreDict.combine(PreDict.combine(d1, d2), d3)
      right = PreDict.combine(d1, PreDict.combine(d2, d3))

      assert PreDict.equal?(left, right)
    end
  end

  property "combine is commutative (for disjoint keys)" do
    check all(
            kvs1 <-
              uniq_list_of({integer(-1_000_000..-1), integer()}, uniq_fun: fn {k, _} -> k end),
            kvs2 <- uniq_list_of({integer(1..1_000_000), integer()}, uniq_fun: fn {k, _} -> k end)
          ) do
      d1 = Enum.reduce(kvs1, PreDict.new(), fn {k, v}, acc -> PreDict.put(acc, k, v) end)
      d2 = Enum.reduce(kvs2, PreDict.new(), fn {k, v}, acc -> PreDict.put(acc, k, v) end)

      assert PreDict.equal?(PreDict.combine(d1, d2), PreDict.combine(d2, d1))
    end
  end
end
