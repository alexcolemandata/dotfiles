return {
  black = 0xff22273d,
  white = 0xffffffff,
  red = 0xfffa7883,
  green = 0xff98c379,
  blue = 0xff6bb8ff,
  yellow = 0xffff9470,
  orange = 0xffffc387,
  magenta = 0xffe799ff,
  grey = 0xff525866,
  transparent = 0x00000000,

  bar = {
    bg = 0xf022273d,
    border = 0xffffffff,
  },
  popup = {
    bg = 0xc022273d,
    border = 0xffffffff,
  },
  bg1 = 0xff374059,
  bg2 = 0xff525866,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
