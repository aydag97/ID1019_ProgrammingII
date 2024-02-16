defmodule Springs2 do

  def test(n) do
    case File.read("sample.txt") do
      {:ok, fileRead} ->
                results = Enum.map(String.split(fileRead, "\n"), fn line ->
                  {types, numbers} = parse(line, n)
                  {ans, _} = cacheSearch(types, numbers, Map.new())
                  ans
                end)

                sum_results(results)
    end
  end

  def sum_results(results) do
    Enum.sum(results)
  end
  # slower implementation of extend (kernel++)
  # def extend({springList, numberList}, 1) do {springList, numberList} end
  # def extend({springList, numberList}, n) when n > 0 do
  #   springList = springList ++ [:unk] ++ springList
  #   numberList = numberList ++ numberList
  #   extend({springList, numberList}, n-1)
  # end

  # def parse(row, n) do
  #   [descr, seq] = String.split(row, " ")
  #   seq = String.split(seq, ",")
  #   seq = Enum.map(seq, fn(x) -> {nr, _} = Integer.parse(x); nr end)
  #   springs = String.to_charlist(descr)
  #   springs = Enum.map(springs, fn(x) -> transform_char(x) end)
  #   extend({springs, seq}, n)
  # end

   # fast implementation of extend (List.duplicate)
  def extend(list, n) do
    list = List.duplicate(list, n)
    list
  end

  def parse(row, n) do
    [descr, seq] = String.split(row, " ")
    descr = extend(descr, n) |> Enum.join("?")
    seq = extend(seq, n) |> Enum.join(",")
    seq = String.split(seq, ",")
    seq = Enum.map(seq, fn(x) -> {nr, _} = Integer.parse(x); nr end)
    springs = String.to_charlist(descr)
    springs = Enum.map(springs, fn(x) -> transform_char(x) end)
    {springs, seq}
  end

  def transform_char(char) when char == 46 do :op end
  def transform_char(char) when char == 35 do :dam end
  def transform_char(char) when char == 63 do :unk end


  def cacheSearch(springs, numbers, mem) do
    case Map.get(mem, {springs, numbers}) do
      :nil ->
        {answer, updatedMem} = count_combos(springs, numbers, mem)
        {answer, Map.put(updatedMem, {springs, numbers}, answer)}
      answer -> {answer, mem}
    end
  end


  def count_combos([], [], mem) do {1, mem} end
  def count_combos([], _, mem)  do {0, mem} end
  def count_combos([:dam|_], [], mem)  do {0, mem} end
  def count_combos([:dam|rest], [nr|numbers], mem) do
    case check_next(rest, nr-1) do
      {:ok, rest} -> cacheSearch(rest, numbers, mem)
      :nil -> {0, mem}
    end
  end
  def count_combos([:op|rest], numbers, mem) do cacheSearch(rest, numbers, mem) end
  def count_combos([:unk | rest], numbers, mem) do
    {ans1, mem} = cacheSearch([:dam | rest], numbers, mem)
    {ans2, mem} = cacheSearch([:op | rest], numbers, mem)
    {ans1+ans2, mem}
  end
  def count_combos(_,_, mem) do {0, mem} end

  def check_next([], 0) do {:ok, []} end
  def check_next([:op|rest], 0) do {:ok, rest} end
  def check_next([:dam|rest], nr) do check_next(rest, nr-1) end
  def check_next([:unk|rest], 0) do {:ok, [:op|rest]} end
  def check_next([:unk | rest], nr)  when nr > 0 do check_next(rest, nr - 1) end
  def check_next(_,_) do :nil end

end
