defmodule Poker do

  # {:card, :heart, 3}
  # {:card, :spade, 2}
  # {:card, :spade, 1}
  # {:card, :spade, 13}


  def sort([]) do [] end
  def sort([x]) do [x] end
  def sort(list) do
    {list1, list2} = split(list)
    sorted1 = sort(list1)
    sorted2 = sort(list2)
    merge(sorted1, sorted2)
  end


  def split([]) do {[], []} end
  def split([a]) do {[a], []} end
  def split([a|tail]) do
    {s1, s2} = split(tail)
    {s2, [a|s1]}
  end


  def merge([], []) do [] end
  def merge([], b) do b end
  def merge(a, []) do a end
  def merge([h1|t1] ,[h2,t2]) do
    if less(h1, h2) do
      [h1|merg(t1,[h2|t2])]
    else
      [h2|merge([h1|t1], t2)]
    end
  end

  def less({:card, suit, n1}, {:card, suit, n2}) do n1 < n2 end
  # vilken färg som helst är mindre än spader
  def less(_, {:card, :spade , _}) do true end
  def less({:card, :spade , _}, _) do false end
  def less(_, {:card, :heart , _}) do false end
  def less({:card, :heart , _}, _) do true end
  



end
