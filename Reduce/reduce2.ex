defmodule Reduce2 do

  def map([], _) do [] end
  def map([head|tail], function) do
    [function.(head) | map(tail, function)]
  end

  # tail recursive
  def reducel([], acc, _) do acc end
  def reducel([head|tail], acc, function) do
    reducel(tail, function.(head, acc), function)
  end
  # body recursive
  def reducer([], acc, _) do acc end
  def reducer([head|tail], acc, function) do
    function.(head, reducer(tail, acc, function))
  end

  # right append (filter) (keeps the order)
  # ++ is used for list concatation, since head itself is not a list then we have to create one
  def filterr([], _) do [] end
  def filterr(list, function) do filterr(list, function, []) end
  def filterr([], _, acc) do acc end
  def filterr([head|tail], function, acc) do
    case function.(head) do
      true -> filterr(tail, function, acc++[head])
      _ -> filterr(tail, function, acc)
    end
  end

  # left filter (keeps the order)
  def filterl([], _) do [] end
  def filterl([head|tail], function) do
    case function.(head) do
      true -> [head|filterl(tail, function)]
      _ -> filterl(tail, function)
    end
  end

  # not keeping the original order
  def filter([], _) do [] end
  def filter(list, function) do filter(list, function, []) end

  def filter([], _, acc) do acc end
  def filter([head|tail], function, acc) do
    case function.(head) do
      true -> filter(tail, function, [head|acc])
      _ -> filter(tail, function, acc)
    end
  end

end
