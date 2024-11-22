return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/playground'
  },
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        "lua", "javascript", "typescript", "python", "html", "css", "bash", "json", "yaml"
      }, -- Lista de linguagens a serem instaladas
      highlight = {
        enable = true, -- Ativa o highlight
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true, -- Ativa a indentação baseada na árvore de sintaxe
      },
      playground = {
        enable = true,
        updatetime = 25, -- Tempo de atualização em milissegundos para o playground
        persist_queries = false, -- Não salva as queries entre sessões
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Ativa a busca adiantada para encontrar o próximo objeto de texto
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- Adiciona movimentos ao locallist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    }
  end
}

