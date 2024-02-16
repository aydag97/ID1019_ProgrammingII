defmodule EnvTree do

  def new() do :nil end

  def add(:nil, key, value) do {:node, key, value, :nil, :nil} end

  # if key already exists, update the value
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end
  # go to the left if new key is less than the current key; else go to right
  def add({:node, k, value, left, right}, key, value) do
    if key < k do
      {:node, k, value, add(left, key, value), right}
    else
      {:node, k, value, left, add(right, key, value)}
    end
  end

  # searching in an empty tree
  def lookup(:nil, _) do :nil end
  # if the key is in the current node just return it
  def lookup({:node, key, value, _, _}, key) do
    {:key, key, :value, value}
  end
  # is key less than current k? go to left; otherwise go to the right
  def lookup({:node, k, value, left, right}, key) do
    if key < k do
      {:node, k, value, lookup(left, key), right}
    else
      {:node, k, value, left, lookup(right, key)}
    end
  end
  
  # removing from an empty tree
  def remove(:nil, _) do :nil end
  # no left branch => return right branch
  def remove({:node, key, _, :nil, right}, key) do right end
  # no right branch => return left branch
  def remove({:node, key, _, left, :nil}, key) do left end
  # removing current node while having left and right branches
  # find the leftmost node in the right branch and replace it with current node
  def remove({:node, key, _, left, right}, key) do
   {leftMostKey, leftMostValue, leftMostRight} = leftmost(right)
   # left branch is still the same but we have a new right branch
   {:node, leftMostKey, leftMostValue, left, leftMostRight}
  end
  # recursive calls to find the node we want to delete
  def remove({:node, k , value, left, right}, key) do
    if key < k do
      {:node, k, value, remove(left, key), right}
    else
      {:node, k, value, left, remove(right, key)}
    end
  end
  # have we reached the leftmost node? return the node with its right branch
  def leftmost({:node, key, value, :nil, right}) do {key, value, right} end
  # otherwise call leftmost recursively to find the leftmost, and return the node
  def leftmost({:node, k, v, left, right}) do
   {leftMostKey, leftMostValue, leftMostRight} = leftmost(left)
   {leftMostKey, leftMostValue, {:node, k, v, leftMostRight, right}}
  end

end
################ Benchmark ################
defmodule TreeBench do

  def bench() do bench(1000) end

  def bench(n) do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("# benchmark trees with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
    Enum.each(ls, fn (i) -> {i, tl_add, tl_lookup, tl_remove} = bench(i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tl_add/n, tl_lookup/n, tl_remove/n])
    end)
  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq,  EnvTree.new(), fn(e, list) -> EnvTree.add(list, e, :foo) end)
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)
    {add, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvTree.add(list, e, :foo) end) end)
    {lookup, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvTree.lookup(list, e) end) end)
    {remove, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvTree.remove(list, e) end) end)
    {i, add, lookup, remove}
  end

end
