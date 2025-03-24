return {
  "tekumara/typos-lsp",
  config = function()
    require("lspconfig").typos_lsp.setup({
      -- Logging level of the language server. Logs appear in :LspLog. Defaults to error.
      cmd_env = { RUST_LOG = "error" },
      init_options = {
        -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
        -- Defaults to error.
        diagnosticSeverity = "Hint",
      },
    })
  end,
}
