defmodule Ranges do

  def test() do
    case File.read("sample.txt") do
      {:ok, fileRead} -> {seeds, maps} = parse(fileRead)
                          Enum.min(transform(seeds, maps))
    end

  end

  def parse(text) do
   [seeds | maps] = String.split(text, "\n\n")
   [_|seeds] = String.split(seeds, " ")
   seeds = Enum.map(seeds, fn(x) -> {nr, _} = Integer.parse(x); nr end)

    maps = Enum.map(maps, fn(row) ->
    [_|eachMap] = String.split(row, "\n")
    eachMap = Enum.map(eachMap, fn(map) -> String.split(map, " ") end)
    eachMap = Enum.map(eachMap, fn(l) ->  Enum.map(l, fn(x) ->  {nr, _} = Integer.parse(x); nr end)end)
    end)
    {seeds, maps}
   end


  def transform(seeds, maps) do transformAllSeeds(seeds, maps, []) end

  def transformAllSeeds([], _, acc) do Enum.reverse(acc) end
  def transformAllSeeds([seed|seeds], maps, acc) do
    newAcc = transformOneSeed(seed, maps, acc)
    transformAllSeeds(seeds, maps, newAcc)
  end
  def transformOneSeed(seed, [], acc) do [seed|acc] end
   def transformOneSeed(seed, [map|maps], acc) do
    case search(seed, map) do
      {:ok, diff} ->
        newSeed = diff + seed
        transformOneSeed(newSeed, maps, acc)
      {:unchanged, seed} -> transformOneSeed(seed, maps, acc)
    end
   end

   def search(seed, []) do {:unchanged, seed} end
   def search(seed, [[to, from, len]|map]) do
    if (seed >= from and seed <= from+len) do
      diff = to - from
      {:ok, diff}
    else
      search(seed, map)
    end
   end

  end
