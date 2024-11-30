local luasnip = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("asciidoc", {
  s(
    "video",
    fmt(
      [[
      video::{}[youtube,width={},height={}]
      ]],
      {
        i(1, "dQw4w9WgXcQ"),
        i(2, "640"),
        i(3, "480"),
      }
    )
  ),
})
