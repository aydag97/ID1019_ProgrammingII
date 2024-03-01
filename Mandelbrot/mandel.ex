defmodule Mandel do

  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Complex.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, depth, [])
  end

  defp rows(_, 0, _, _, rowsList) do rowsList end
  defp rows(width, height, operation, depth, rowsList) do
    row = row(width, height, operation, depth, [])
    rows(width, height - 1, operation, depth, [row|rowsList])
  end

  defp row(0, _, _, _, rowList) do rowList end
  defp row(width, height, operation, depth, rowList) do
    complexNumber = operation.(width, height)
    dep = Brot.mandelbrot(complexNumber, depth)
    converted = Color.convert(dep, depth)
    row(width - 1, height, operation, depth, [converted|rowList])
  end

end
