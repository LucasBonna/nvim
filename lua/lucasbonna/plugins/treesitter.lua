-- nvim-treesitter (branch `main`): a API antiga (`nvim-treesitter.configs`) não existe mais.
-- Highlight/indent/folds agora são ativados via `vim.treesitter.start()` num autocmd FileType.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- o plugin não suporta lazy-loading
    build = ":TSUpdate",
    config = function()
      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })

      -- parser customizado (blade) precisa ser registrado antes do :TSUpdate
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").blade = {
            install_info = {
              url = "https://github.com/EmranMR/tree-sitter-blade",
              branch = "main",
            },
          }
        end,
      })

      require("nvim-treesitter").setup({})

      local languages = {
        "blade",
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "python",
        "go",
      }

      require("nvim-treesitter").install(languages)

      -- Ativa highlight + indent para qualquer filetype que tenha parser instalado.
      -- Se o parser ainda não existe, tenta instalar (equivalente ao antigo `auto_install`).
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end
          if not vim.treesitter.language.add(lang) then
            if vim.list_contains(require("nvim-treesitter").get_available(), lang) then
              require("nvim-treesitter").install(lang)
            end
            return
          end
          pcall(vim.treesitter.start, ev.buf, lang)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
