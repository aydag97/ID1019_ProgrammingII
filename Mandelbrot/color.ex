defmodule Color do
# {r, g, b}
  def convert(depth, max) do
    fraction = depth/max
    floating = 4*fraction
    integer = trunc(floating)
    offset = trunc(255 * (floating - integer)) # between 0-255

    # red palette
    # case integer do
    #   0 -> {:rgb, offset, 0, 0} # black -> red
    #   1 -> {:rgb, 255, offset, 0} # red -> yellow
    #   2 -> {:rgb, 255 - offset, 255, 0} # yellow -> green
    #   3 -> {:rgb, 0, 255, offset} # green -> cyan
    #   4 -> {:rgb, 0, 255 - offset, 255} # cyan -> blue
    # end

    # blue palette
    case integer do
      0 -> {:rgb, 0, 0, offset}
      1 -> {:rgb, 0, offset, 255}
      2 -> {:rgb, 0, 255, 255 - offset}
      3 -> {:rgb, offset, 255, 0}
      4 -> {:rgb, 255, 255 - offset, 0}
    end
  end

end
