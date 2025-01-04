local M = {}

M.base = {
  base00 = 0xff1f1f28,
  base01 = 0xff16161d,
  base02 = 0xff223249,
  base03 = 0xff54546d,
  base04 = 0xff727169,
  base05 = 0xffdcd7ba,
  base06 = 0xffc8c093,
  base07 = 0xff717c7c,
  base08 = 0xffc34043,
  base09 = 0xffffa066,
  base0A = 0xffc0a36e,
  base0B = 0xff76946a,
  base0C = 0xff6a9589,
  base0D = 0xff7e9cd8,
  base0E = 0xff957fb8,
  base0F = 0xffd27e99,
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
  border = M.named_base.fg_default
}

M.with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then return color end
  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

return M
