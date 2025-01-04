return {
  black = 0xff171e1f,
  white = 0xffe1eaef,
  red = 0xffff4658,
  green = 0xff499180,
  blue = 0xff498091,
  yellow = 0xfffdb11f,
  orange = 0xffe6db74,
  magenta = 0xff9bc0c8,
  grey = 0xff373c3d,
  transparent = 0x00000000,

  bar = {
    bg = 0xf0171e1f,
    border = 0xffc7c7a5,
  },
  popup = {
    bg = 0xc0171e1f,
    border = 0xffe3e3c8,
  },
  bg1 = 0xff252c2d,
  bg2 = 0xff373c3d,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
