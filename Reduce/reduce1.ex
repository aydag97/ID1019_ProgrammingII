defmodule Reduce1 do
# length - sum - prod
  def length([]) do 0 end
  def length(list) do length(list, 0) end
  def length([], len) do len end
  def length([_| tail], len) do
    len = len + 1
    length(tail, len)
  end
# odd - even
  def even([]) do [] end
  def even(list) do Enum.reverse(even(list, [])) end

  def even([], evenList) do evenList end
  def even([head|tail], evenList) do
    if rem(head,2) == 0 do
      even(tail, [head|evenList])
    else
      even(tail, evenList)
    end
  end
# inc - dec - mul - rem - divz
  def inc([], _) do [] end
  def inc(list, 0) do list end
  def inc(list, number) do Enum.reverse(inc(list, number, [])) end
  def inc([], _, incrList) do incrList end
  def inc([head|tail], number, incrList) do
    inc(tail, number, [head+number | incrList])
  end

  def sum([]) do 0 end
  def sum(list) do sum(list, 0) end

  def sum([], sums) do sums end
  def sum([head| tail], sums) do
    sums = sums + head
    sum(tail, sums)
  end


  def dec([], _) do [] end
  def dec(list, 0) do list end
  def dec(list, number) do Enum.reverse(dec(list, number, [])) end
  def dec([], _, decrList) do decrList end
  def dec([head|tail], number, decrList) do
    dec(tail, number, [head-number | decrList])
  end

  def mul([], _) do [] end
  def mul(list, 1) do list end
  def mul(list, number) do Enum.reverse(mul(list, number, [])) end
  def mul([], _, mulList) do mulList end
  def mul([head|tail], number, mulList) do
    mul(tail, number, [head*number | mulList])
  end


  def odd([]) do [] end
  def odd(list) do Enum.reverse(odd(list, [])) end
  def odd([], oddList) do oddList end
  def odd([head|tail], oddList) do
    if rem(head,2) == 0 do
      odd(tail, oddList)
    else
      odd(tail, [head|oddList])
    end
  end

  def reminder([], _) do [] end
  def reminder(_, 0) do IO.puts("Error: Division with zero") end
  def reminder(list, number) do Enum.reverse(reminder(list, number, [])) end
  def reminder([], _, remList) do remList end
  def reminder([head|tail], number, remList) do
    reminder(tail, number, [rem(head,number) | remList])
  end


  def prod([]) do 1 end
  def prod(list) do prod(list, 1) end
  def prod([], res) do res end
  def prod([head| tail], res) do
    res = head * res
    prod(tail, res)
  end

  def divz([], _) do [] end
  def divz(_, 0) do IO.puts("Error: Division with zero") end
  def divz(list, number) do Enum.reverse(divz(list, number, [])) end
  def divz([], _, divList) do divList end
  def divz([head|tail], number, divList) do
    if rem(head,number) == 0 do
      divz(tail, number, [head | divList])
    else
      divz(tail, number, divList)
    end
  end

  def test() do
    myList = [1,2,3,4,5,6]

    IO.write("\nThe List: #{inspect(myList)}\n")

    IO.write("\n-------- Product ----------\n")
    IO.write("The Product of Elements in the list: #{prod(myList)}\n")

    IO.write("\n-------- Division ----------\n")
    IO.write("The Division of Elements in the list with 3: #{inspect(divz(myList, 3))}\n")

    IO.write("\n-------- Incremention ----------\n")
    IO.write("The Incremention of Elements in the list with 2: #{inspect(inc(myList, 2))}\n")
  end

end
