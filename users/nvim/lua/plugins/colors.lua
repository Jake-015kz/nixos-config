return {
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        highlighters = {
          -- Подсветка HEX цветов: #FFFFFF, #000, и т.д.
          hex_color = hi.gen_highlighter.hex_color(),

          -- Дополнительные паттерны (опционально, для удобства)
          fixme = { pattern = "%f[%w]FIXME%f[%W]", group = "MiniHypatternsFixme" },
          todo = { pattern = "%f[%w]TODO%f[%W]", group = "MiniHypatternsTodo" },
          hack = { pattern = "%f[%w]HACK%f[%W]", group = "MiniHypatternsHack" },
          note = { pattern = "%f[%w]NOTE%f[%W]", group = "MiniHypatternsNote" },
        },
      }
    end,
  },
}
