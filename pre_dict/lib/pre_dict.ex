defmodule PreDict do
  alias PreDict.Node

  defstruct root: nil, size: 0
  # {key, value, left, right}

  def new(), do: %PreDict{}

  def put(%PreDict{root: root, size: size} = dict, key, value) do
    {new_root, added?} = Node.put(root, key, value)
    %PreDict{dict | root: new_root, size: if(added?, do: size + 1, else: size)}
  end

  def get(%PreDict{root: root, size: size}, key, default \\ nil) do
    Node.get(root, key, default)
  end

  def map(%PreDict{root: root} = dict, fun) do
    new_root = Node.map(root, fun)
    %PreDict{dict | root: new_root}
  end

  def size(%PreDict{size: size} = dict), do: size

  def filter(%PreDict{root: root}, fun) do
    Node.filter(root, fun, PreDict.new())
  end

  def foldl(%PreDict{root: root}, acc, fun) do
    PreDict.Node.foldl(root, acc, fun)
  end

  def foldr(%PreDict{root: root}, acc, fun) do
    PreDict.Node.foldr(root, acc, fun)
  end

  def delete(%PreDict{root: root, size: size} = dict, key) do
    new_root = Node.delete(root, key)
    %PreDict{dict | root: new_root, size: max(size - 1, 0)}
  end

  def empty(), do: %PreDict{}

  def combine(%PreDict{} = dict1, %PreDict{} = dict2) do
    foldl(dict2, dict1, fn {k, v}, acc -> put(acc, k, v) end)
  end

  def equal?(%PreDict{size: s1} = d1, %PreDict{size: s2} = d2) when s1 != s2, do: false

  def equal?(d1, d2) do
    PreDict.foldl(d1, true, fn {k, v}, acc ->
      acc and PreDict.get(d2, k, :__not_found__) == v
    end)
  end
end
