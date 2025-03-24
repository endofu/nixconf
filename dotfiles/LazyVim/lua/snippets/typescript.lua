local ls = require("luasnip")
local s = ls.snippet
-- local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("typescript", {
  s(
    "egen",
    fmt(
      [[
  Effect.gen(function*() {{
    const value = yield* {};
  }})
  ]],
      { i(1) }
    )
  ),
  s(
    "etyp",
    fmt(
      [[
  Effect.Effect<{}, {}, {}>
  ]],
      { i(1), i(2), i(3) }
    )
  ),
  s(
    "epro",
    fmt(
      [[
          yield* Effect.tryPromise(() =>
{}
      ).pipe(
      Effect.mapError(
        (e) => new ParsedError({{ tag: "PrismaError", message: e.message }})
      )
    );
      ]],
      { i(1) }
    )
  ),
})
