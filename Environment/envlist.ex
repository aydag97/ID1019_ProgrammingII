defmodule EnvList do
  def new() do [] end

  def add([], key, value) do
    [{key,value}]
  end

  def add([{key,_}|tail], key, value) do
      [{key,value}|tail]
  end

  def add([head|tail], key, value) do
    [head|add(tail,key,value)]
  end

  def lookup([], _) do nil end

  def lookup([ret={key,_}|_], key) do
    ret
  end

  def lookup([_|tail], key) do
    lookup(tail,key)
  end

  def remove(_, []) do [] end

  def remove(key, [{key,_}|tail]) do tail end

  def remove(key, [head|tail]) do
    [head|remove(key,tail)]
  end

end

################ Benchmark ################

defmodule ListBench do

  def bench() do bench(1000) end

  def bench(n) do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("# benchmark lists with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
    Enum.each(ls, fn (i) ->
      {i, tl_add, tl_lookup, tl_remove} = bench(i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tl_add/n, tl_lookup/n, tl_remove/n])
    end)
  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq,  EnvList.new(), fn(e, list) -> EnvList.add(list, e, :foo) end)
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)
    {add, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvList.add(list, e, :foo) end) end)
    {lookup, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) ->  EnvList.lookup(list, e) end) end)
    {remove, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) ->  EnvList.remove(e, list) end) end)
    {i, add, lookup, remove}
  end

end
