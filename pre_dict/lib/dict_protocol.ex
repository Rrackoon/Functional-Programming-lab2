defprotocol DictProtocol do
  def put(dict, key, value)
  def get(dict, key, default \\ nil)
  def delete(dict, key)
  def combine(dict1, dict2)
  def map(dict, fun)
  def filter(dict, fun)
  def foldl(dict, acc, fun)
  def foldr(dict, acc, fun)
end

defimpl DictProtocol, for: PreDict do
  def put(dict, k, v), do: PreDict.put(dict, k, v)
  def get(dict, k, d), do: PreDict.get(dict, k, d)
  def delete(dict, k), do: PreDict.delete(dict, k)
  def combine(d1, d2), do: PreDict.combine(d1, d2)
  def map(dict, f), do: PreDict.map(dict, f)
  def filter(dict, f), do: PreDict.filter(dict, f)
  def foldl(dict, acc, f), do: PreDict.foldl(dict, acc, f)
  def foldr(dict, acc, f), do: PreDict.foldr(dict, acc, f)
end
