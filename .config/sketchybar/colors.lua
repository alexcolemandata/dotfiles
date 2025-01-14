local M = {}

M.base = {
  base00 = 0xd0171e1f,
  base01 = 0xd0252c2d,
  base02 = 0xff373c3d,
  base03 = 0xff555e5f,
  base04 = 0xff818f80,
  base05 = 0xffc7c7a5,
  base06 = 0xffe3e3c8,
  base07 = 0xffe1eaef,
  base08 = 0xffff4658,
  base09 = 0xffe6db74,
  base0A = 0xfffdb11f,
  base0B = 0xff499180,
  base0C = 0xff66d9ef,
  base0D = 0xff498091,
  base0E = 0xff9bc0c8,
  base0F = 0xffd27b53,
}

M.named_base = {
  bg_default = M.base.base00,
  bg_lighter = M.base.base01,
  bg_select = M.base.base02,
  comments = M.base.base03,
  fg_dark = M.base.base04,
  fg_default = M.base.base05,
  fg_light = M.base.base06,
  bg_light = M.base.base07,
  variables = M.base.base08,
  integers = M.base.base09,
  classes = M.base.base0A,
  strings = M.base.base0B,
  regex = M.base.base0C,
  functions = M.base.base0D,
  keywords = M.base.base0E,
  deprecated = M.base.base0F,
}

M.black = 0xff000000
M.white = 0xffffffff
M.transparent = 0x000000

M.bar = {
  bg = M.named_base.bg_default,
  border = M.named_base.fg_dark
}

M.popup = {
  bg = M.named_base.bg_lighter,
  border = M.named_base.strings,
}

M.with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then return color end
  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

return M
