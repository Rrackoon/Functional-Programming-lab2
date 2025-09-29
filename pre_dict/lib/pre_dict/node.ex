defmodule PreDict.Node do
  def new(key, value), do: {key, value, nil, nil}

  def put(nil, key, value), do: {{key, value, nil, nil}, true}

  def put({k, v, l, r}, key, value) do
    cond do
      key < k ->
        {new_l, added?} = put(l, key, value)
        {{k, v, new_l, r}, added?}

      key > k ->
        {new_r, added?} = put(r, key, value)
        {{k, v, l, new_r}, added?}

      true ->
        {{key, value, l, r}, false}
    end
  end

  def get(nil, _key, default), do: default
  def get({k, v, l, r}, key, default) do
    cond do
      key < k -> get(l, key, default)
      key > k -> get(r, key, default)
      true -> v
    end
  end

  def map(nil, _fun), do: nil
  def map({k, v, l, r}, fun) do
    {k, fun.(v), map(l, fun), map(r, fun)}
  end

  def filter(nil, _fun, acc), do: acc
  def filter({k, v, l, r}, fun, acc) do
    acc1 = filter(l, fun, acc)
    acc2 = filter(r, fun, acc1)
    if fun.({k, v}), do: PreDict.put(acc2, k, v), else: acc2
  end

  def foldl(nil, acc, _fun), do: acc
  def foldl({k, v, l, r}, acc, fun) do
    acc1 = foldl(l, acc, fun)
    acc2 = fun.({k, v}, acc1)
    foldl(r, acc2, fun)
  end

  def foldr(nil, acc, _fun), do: acc
  def foldr({k, v, l, r}, acc, fun) do
    acc1 = foldr(r, acc, fun)
    acc2 = fun.({k, v}, acc1)
    foldr(l, acc2, fun)
  end

  def delete(nil, _key), do: nil
  def delete({k, v, l, r}, key) do
    cond do
      key < k -> {k, v, delete(l, key), r}
      key > k -> {k, v, l, delete(r, key), r}
      true ->
        case {l, r} do
          {nil, nil} -> nil
          {nil, _} -> r
          {_, nil} -> l
          _ ->
            {min_k, min_v, new_r} = extract_min(r)
            {min_k, min_v, l, new_r}
        end
    end
  end

  defp extract_min({k, v, nil, r}), do: {k, v, r}
  defp extract_min({k, v, l, r}) do
    {min_k, min_v, new_l} = extract_min(l)
    {min_k, min_v, {k, v, new_l, r}}
  end
end
