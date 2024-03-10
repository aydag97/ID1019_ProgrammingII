defmodule Huffman do

  def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    frq = freq(sample)
    {tree, _f} = huffman(frq)
    etable = encode_table(tree)
    encoded = encode(sample, etable)
    decoded = decode(encoded, tree)
    # tar första 10 chars
    Enum.take(decoded, 10)
  end


  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end


  def freq(sample) do
    freq(sample, %{})
  end
 # return as a list of tuples (tuples consisting of the character and its frequency)
  def freq([], freq) do Map.to_list(freq) end

  def freq([char | rest], freq) do
    updatedFreq =
      case Map.get(freq, char) do
        nil -> Map.put(freq, char, 1)
        _ -> Map.update!(freq, char, fn updatedValue -> updatedValue+1 end)
      end
    freq(rest, updatedFreq)
  end


def huffman(freq) do
  # sortedFreq = Enum.sort(freq, fn({_, val1}, {_, val2}) -> val1 <= val2  end)
  sortedFreq = Enum.sort(freq, fn(a,b) -> elem(a,1) < elem(b,1) end)
  huffman_tree(sortedFreq)
end

# om det finns en enda sak, returnera den
def huffman_tree([node]) do node end
# node 1 och node 2 nu har den lägsta frekvensen så slå ihop dem
def huffman_tree([{char1, val1}, {char2, val2} | freq]) do
  # bygger en tuple med bokstäverna char1 och char2 och frekvensen blir val1+val2. listan är fortfarande sorterad
  huffman_tree(combine({{char1, char2}, val1 + val2}, freq))
end

def combine(node, []) do [node] end
def combine(node1, [node2 | freq] = sorted)do
  # elem(node1, 1) tar andra elementet i tuple {char, val} dvs val
  if (elem(node1, 1) <= elem(node2, 1)) do
    [node1|sorted]
  else
    [node2|combine(node1, freq)]
  end
end



  def encode_table(tree) do encode_table(tree, [], %{}) end
  # vi har tagit bort frekvensen..nu är det antingen en tuple eller en char
  def encode_table({zero, one}, path, table) do
    table = encode_table(zero, [0|path], table)
    encode_table(one, [1|path], table)
  end
  def encode_table(char, path, table) do Map.put(table, char, Enum.reverse(path)) end


  def encode([], _) do [] end
  def encode([char|rest], table) do
    case Map.get(table, char) do
      nil ->
        :io.format("failed to encode ~w\n", [char])
        encode(rest, table)
      seq ->
        seq ++ encode(rest, table)
    end
  end

  def codes({a, b}, current_position) do
    as = codes(a, [0 | current_position])
    bs = codes(b, [1 | current_position])
    as ++ bs
  end

  def codes(a, code) do
    [{a, Enum.reverse(code)}]
  end

  def decode_table(tree), do: codes(tree, [])
  # dummy solution to decode
  def decodeDum([], _)  do [] end
  def decodeDum(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decodeDum(rest, table)]
  end
  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} -> {char, rest}
      nil -> decode_char(seq, n+1, table)
    end
  end

  # smart solution to decode
  def decode(encoded, tree) do decode(encoded, tree, tree) end

  def decode([], char, _) do [char] end
  def decode([0|rest], {zero, _one}, tree) do decode(rest, zero, tree) end
  def decode([1|rest], {_zero, one}, tree) do decode(rest, one, tree) end
  def decode(encoded, char, tree) do
    [char|decode(encoded, tree, tree)]
  end

  def read(file) do
    # binär sträng
    str = File.read!(file)
    chars = String.to_charlist(str)
    {:ok, chars, length(chars), Kernel.byte_size(str)}
  end

  def bench() do
    {:ok, text, n, b} = read("kallocain.txt")
    :io.format("char = ~w\nbytes = ~w\n\n", [n, b])
    freq = freq(text)
    :io.format("chars in alphabet ~w\n", [length(freq)])

    t0 = :erlang.timestamp()
    tree = tree(text)
    t1 = :erlang.timestamp()
    IO.puts("Building tree in #{div(:timer.now_diff(t1,t0), 1000)} ms")

    t2 = :erlang.timestamp()
    encode = encode_table(tree)
    seq = encode(text, encode)
    t3 = :erlang.timestamp()
    IO.puts("encode in #{div(:timer.now_diff(t3,t2), 1000)} ms")

    t4 = :erlang.timestamp()
    # decoded = decode_table(tree)
    # decodeDum(seq, decoded)
    decode(seq, tree)
    t5 = :erlang.timestamp()

    IO.puts("decode in #{div(:timer.now_diff(t5,t4), 1000)} ms")
  end

end
