defmodule OP do

  def lengthz(list) do
    func = fn(_, a) -> a+1  end
    Reduce2.reducer(list, 0, func)
  end

  def even(list) do
    func = fn(a) -> rem(a,2) == 0 end
     Reduce2.filterr(list, func)
  end

  def odd(list) do
    func = fn(a) -> rem(a,2) != 0 end
     Reduce2.filterr(list, func)
  end

  def inc(list, number) do
    func = fn(a) -> a+number end
    Reduce2.map(list, func)
  end

  def dec(list, number) do
    func = fn(a) -> a-number end
    Reduce2.map(list, func)
  end

  def sum(list) do
    func = fn(a, b) -> a+b end
    Reduce2.reducel(list, 0, func)
  end

  def mul(list, number) do
    func = fn(a) -> a*number end
    Reduce2.map(list, func)
  end

  def remz(list, number) do
    func = fn(a) -> rem(a, number) end
    Reduce2.map(list, func)
  end

  def prod(list) do
    func = fn(a, b) -> a*b end
    Reduce2.reducel(list, 1, func)
  end

  def divz(list, number) do
    func = fn(a) -> rem(a, number) == 0 end
    Reduce2.filterl(list, func)
  end

  def less_square(list, number) do
    func = fn(x) -> (if x < number do x*x else 0 end) end
    sum(Reduce2.map(list, func))
  end

  def test() do
    lst = [1,2,3,4,5,6]
    lengthz(lst)
    even(lst)
    odd(lst)
    inc(lst, 3)
    dec(lst, 3)
    sum(lst)
    mul(lst,2)
    remz(lst,2)
    prod(lst)
    divz(lst, 3)
    less_square(lst, 4)
  end

  def testPipe(list, x, y) do
   # lst = [1,2,3,4,5,6, 7, 8, 9, 10]
   # divz(3) -> [3,6,9]
   # inc(2) -> [5,8,11]
    list |>
      divz(x) |>
        inc(y) |>
          lengthz()
  end

end
