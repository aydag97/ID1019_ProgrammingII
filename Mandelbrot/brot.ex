defmodule Brot do

  def mandelbrot(c, m) do
    z0 = Complex.new(0,0)
    i = 0
    test(i, z0, c, m)
  end

  def test(m, _, _, m) do 0 end
  def test(i, zi, c, m) do
    # den håller på att ständigt bygga på tuppler och sära dem för att tillslut representera en komplex tal
    # dethär tar tid förstås
    z = Complex.abs(zi)
    cond do
      z > 2 -> i
      z <= 2 ->
        znext = Complex.add(Complex.sqr(zi), c)
        test(i+1, znext, c, m)
    end
  end

end
