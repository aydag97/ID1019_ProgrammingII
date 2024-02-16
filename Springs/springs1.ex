defmodule Spring1 do

  def test(n) do
    case File.read("sample.txt") do
      {:ok, fileRead} ->
                results = Enum.map(String.split(fileRead, "\n"), fn line ->
                  {types, numbers} = parse(line,n)
                  count_combos(types, numbers)
                end)
                sum_results(results)
    end
  end

  def sum_results(results) do
    Enum.sum(results)
  end

  def parse(row) do
    [descr, seq] = String.split(row, " ")
    seq = String.split(seq, ",")
    seq = Enum.map(seq, fn(x) -> {nr, _} = Integer.parse(x); nr end)
    springs = String.to_charlist(descr)
    springs = Enum.map(springs, fn(x) -> transform_char(x) end)
    {springs, seq}
  end

  def transform_char(char) do
    case char do
      46 -> :op
      35 -> :dam
      63 -> :unk
    end
  end

 # if description and number lists are empty: number of #s matches the number list => a complete match
  def count_combos([], []) do 1 end
  # if description becomes empty while there are still numbers then it's a unsuccessful match so return 0
  def count_combos([], _)  do 0 end
  # if there is :dam in description but numbers are empty => again unsuccessful match so return 0
  def count_combos([:dam|_], [])  do 0 end
  # otherwise:
  def count_combos([:dam|rest], [nr|numbers]) do
    # check if there are several #s in row (without . in between), in this case check other #s and decrement nr
    # (cause we already checked the first # so we have to decrement the nr)
    case check_next(rest, nr-1) do
      # if we get an okay (i.e the number of #s in a row matches the nr) so check the rest of description
      {:ok, rest} -> count_combos(rest, numbers)
      # otherwise it's an unsuccessful match
      :nil -> 0

    end
  end
  # :op ?? keep searching with rest of description
  def count_combos([:op|rest], numbers) do
    count_combos(rest, numbers)
  end
  # :unk? we have to check 2 alternatives: 1. is there a solution if we replace the ? with .
  #                                        2. is there a solution if we replace ? with #
  #                                        3. sum the results from both cases (think of OR operation!)
  def count_combos([:unk | rest], numbers) do
    count_combos([:dam | rest], numbers) + count_combos([:op | rest], numbers)
  end
  # in all other cases it's an unsuccessful
  def count_combos(_,_) do 0 end

 # check_next is for checking a sequence of same description in the list (like ###....##..?..# the number of #s in
 # first sequence is 3). it gets easier if you write down on paper to see what happens in each case!
  # if the description list becomes empty and nr reaches 0, it means we have a match!
  def check_next([], 0) do {:ok, []} end
  # if it's a :op and nr is 0 => match (think of "#. 1" we have checked # already in count_combos and decremented 1
  # with 1 so the sequence looks like . 0)
  def check_next([:op|rest], 0) do {:ok, rest} end
  # sequence of #s continues? just check the rest of sequence and decrement nr with 1
  def check_next([:dam|rest], nr) do check_next(rest, nr-1) end
  # intressting part!! think like we have ?.. 0 this means that it can't be  a # cause the nr is 0 so
  # we consider the ? as a . and return ok!
  def check_next([:unk|rest], 0) do {:ok, [:op|rest]} end
  # if we have ? and there is still a nr greater than 0 we just assume it is a # and keeps searching the rest of seq
  def check_next([:unk | rest], nr) do check_next(rest, nr - 1) end
  # none of them above? return nil
  def check_next(_,_) do :nil end

end
