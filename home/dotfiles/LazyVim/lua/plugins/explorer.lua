return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    -- dashboard = {
    --   enabled = true,
    -- },
    explorer = {
      layout = {
        preset = "right",
      },
    },
    picker = {
      sources = {
        explorer = {
          auto_close = true,
          layout = {
            preview = "preview",
            preset = "default",
          },
        },
      },
    },
  },
}
