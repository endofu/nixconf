-- stable version
return {
  "OlegGulevskyy/better-ts-errors.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = {
    keymaps = {
      toggle = "<leader>ce", -- default '<leader>ce'
      go_to_definition = "<leader>cE", -- default '<leader>cE'
    },
  },
}
