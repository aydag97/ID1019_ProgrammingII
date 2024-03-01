defmodule Test do

  def demo() do
    # large 1
    # large(-0.73, 0.12, 1.2)
    
    # large 2
    # large(-0.5577, -0.6099, -0.5)

    # large 3
    # large(-0.35, -0.4599, -2)

    # the complete mandelbrot
    small(-2.6, 1.2, 1.2)
  end

  def small(x0, y0, xn) do
    width = 960
    height = 540
    depth = 64
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
  end

  def large(x0, y0, xn) do
    width = 1920
    height = 1080
    depth = 50
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("large.ppm", image)
  end

end
