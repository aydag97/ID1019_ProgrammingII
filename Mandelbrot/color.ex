defmodule Color do
# {r, g, b}
  def convert(depth, max) do
    fraction = depth/max
    floating = fraction*4
    integer = trunc(floating)
    offset = trunc(255 * (floating - integer))
    case integer do
      0 -> {offset, 0, 0}
      1 -> {255, offset, 0}
      2 -> {255 - offset, 255, 0}
      3 -> {0, 255, offset}
      4 -> {0, 255 - offset, 255}
    end
  end

end
