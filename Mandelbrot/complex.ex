defmodule Complex do

  def new(r, i) do
    {r, i}
  end

  def add(a, b) do
    {r1, i1} = a
    {r2, i2} = b
    {r1+r2, i1+i2}
  end
  def sqr(a) do
    {r, i} = a
    {(r*r) - (i*i), 2 * r * i}
  end

  def abs(a) do
    {r, i} = a
    :math.sqrt((r*r) + (i*i))
  end
end
