defmodule PreDict do
  defstruct root: nil, size: 0
  alias PreDict.Node

  def new(), do: %PreDict{}

  def empty(), do: %PreDict{}

  def put(%PreDict{root: root, size: size} = dict, key, value) do
    {new_root, added?} = Node.put(root, key, value)
    new_size = if added?, do: size + 1, else: size
    %PreDict{dict | root: new_root, size: new_size}
  end

  def get(%PreDict{root: root}, key, default \\ nil) do
    Node.get(root, key, default)
  end

  def delete(%PreDict{root: root, size: size} = dict, key) do
    new_root = Node.delete(root, key)
    new_size = if root == new_root, do: size, else: size - 1
    %PreDict{dict | root: new_root, size: new_size}
  end

  def map(%PreDict{root: root} = dict, fun) do
    %PreDict{dict | root: Node.map(root, fun)}
  end

  def filter(%PreDict{root: root}, fun) do
    Node.filter(root, fun, new())
  end

  def foldl(%PreDict{root: root}, acc, fun), do: Node.foldl(root, acc, fun)
  def foldr(%PreDict{root: root}, acc, fun), do: Node.foldr(root, acc, fun)

  def combine(d1, d2) do
    foldl(d2, d1, fn {k, v}, acc -> put(acc, k, v) end)
  end

  def equal?(%PreDict{size: s1}, %PreDict{size: s2}) when s1 != s2, do: false

  def equal?(d1, d2) do
    foldl(d1, true, fn {k, v}, acc ->
      acc and get(d2, k, :__not_found__) == v
    end)
  end

  def size(%PreDict{size: size}), do: size
end
