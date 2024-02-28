defmodule Brot do

  def mandelbrot(c, m) do
    z0 = Complex.new(0,0)
    i = 0
    test(i, z0, c, m)
  end

  def test(m, _, _, m) do 0 end
  def test(i, zi, c, m) do
    znext = Complex.add(Complex.sqr(zi), c)
    cond do
      znext > 2 -> i
      znext <= 2 -> test(i+1, znext, c, m)
    end
  end

end
