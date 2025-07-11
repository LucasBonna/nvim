return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  dependencies = 'rafamadriz/friendly-snippets',
  version = 'v0.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'select_and_accept', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-n>'] = { 'scroll_documentation_down', 'fallback' },
      ['<S-K>'] = { 'show', 'show_documentation', 'hide_documentation'},
    },
    completion = {
      menu = {
        border = 'single',
        auto_show = function (ctx)
          return ctx.mode ~= 'cmdline'
        end
      },
      documentation = {
        auto_show = false,
        auto_show_delay_ms = 20000,
        window = {
          border = 'single'
        }
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },
    -- sources = {
    --   default = { 'lsp', 'path', 'snippets', 'buffer' },
    --   providers = {
    --     lsp = { "sources.completion.enabled_providers" }
    --   }
    -- },
  }
}
