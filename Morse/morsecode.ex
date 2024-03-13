defmodule MorseCode do

  def test1() do
    tree = tree()
    signal = rolled()
    decoded = decode(signal, tree)
    IO.inspect(decoded)
  end

  def test2() do
    tree = tree()
    text = 'ayda ghalkhanbaz'
    map = encode_table(tree)
    encoded = encode(text, map)
    :io.format("\nEncoded:\n")
    IO.inspect(encoded)
    decoded = decode(encoded, tree)
    :io.format("\nDecoded:\n")
    IO.inspect(decoded)
  end

def decode(signal, tree) do decode(signal, tree, tree) end

def decode([], {:node, char, _, _}, _) do [char] end
def decode([?.|rest], {:node, _char, _long, short}, tree) do decode(rest, short, tree) end
def decode([?-|rest], {:node, _char, long, _short}, tree) do decode(rest, long, tree) end
def decode([?\s|rest], {:node, :na, _, _}, tree) do decode(rest, tree, tree) end
def decode([?\s |rest], {:node, char, _, _}, tree) do [char|decode(rest, tree, tree)] end
def decode([_|rest], {:node, _, _, _}, tree) do decode(rest, tree, tree) end


def encode_table(tree) do encode_table(tree, [], %{}) end

def encode_table(nil, _, table) do table end

def encode_table({:node, :na, long, short}, path, table) do
  table = encode_table(long, [?-|path], table)
  encode_table(short, [?.|path], table)
end

def encode_table({:node, char, long, short}, path, table) do
  table = Map.put(table, char, Enum.reverse(path))
  table = encode_table(long, [?-|path], table)
  encode_table(short, [?.|path], table)
end


def encode([], _) do '' end

def encode([char], map) do
  case Map.get(map, char) do
    nil ->
      :io.format("failed to encode ~w\n", [char])
    seq -> seq
  end
 end

def encode([char|rest], map) do
  case Map.get(map, char) do
    nil ->
      :io.format("failed to encode ~w\n", [char])
      encode(rest, map)
    seq ->
      seq ++ ' ' ++ encode(rest, map)
  end
end

# The codes that you should decode:

def base, do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'
def corrupted, do: '.-  4.-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'
def rolled, do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----'

# The decoding tree.

# The tree has the structure  {:node, char, long, short} | :nil

def tree do
  {:node, :na,
    {:node, 116,
      {:node, 109,
        {:node, 111,
          {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
          {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
        {:node, 103,
          {:node, 113, nil, nil},
          {:node, 122,
            {:node, :na, {:node, 44, nil, nil}, nil},
            {:node, 55, nil, nil}}}},
      {:node, 110,
        {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
        {:node, 100,
          {:node, 120, nil, nil},
          {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
    {:node, 101,
      {:node, 97,
        {:node, 119,
          {:node, 106,
            {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
            nil},
          {:node, 112,
            {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
            nil}},
        {:node, 114,
          {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
          {:node, 108, nil, nil}}},
      {:node, 105,
        {:node, 117,
          {:node, 32,
            {:node, 50, nil, nil},
            {:node, :na, nil, {:node, 63, nil, nil}}},
          {:node, 102, nil, nil}},
        {:node, 115,
          {:node, 118, {:node, 51, nil, nil}, nil},
          {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
end

end
