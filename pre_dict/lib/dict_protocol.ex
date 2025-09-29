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
