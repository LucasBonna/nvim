-- Arquivo: lua/plugins.lua
return {
  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "┋",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = { add = " ", change = " ", delete = "" },
    },
  },

}

