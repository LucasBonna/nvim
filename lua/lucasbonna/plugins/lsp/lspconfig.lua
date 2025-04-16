return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
    {"antosha417/nvim-lsp-file-operations", config= true },
    { "folke/neodev.nvim", opts = {} },
    -- "catppuccin/nvim", -- Adicionando dependência do Catppuccin
  },
  config = function()
    local lspconfig = require("lspconfig")

    local mason_lspconfig = require("mason-lspconfig")

    local keymap = vim.keymap

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function (ev)

        local opts = { buffer = ev.buffer, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end
    })

    vim.lsp.buf.hover = function()
      return
    end

    vim.api.nvim_create_autocmd("CompleteDone", {
      callback = function()
        -- Disable hover temporarily
        vim.lsp.buf.hover = function() end

        -- Restore hover after a short delay
        vim.defer_fn(function()
          vim.lsp.buf.hover = vim.lsp.buf.hover  -- Restore original function
        end, 100)
      end
    })

    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local server_configs = {
      -- Python configuration with pyright
      pyright = {
        settings = {
          pyright = {
            disableOrganizeImports = false,
          },
          python = {
            analysis = {
              diagnosticSeverityOverrides = {
                reportUnknownMemberType = "none",
                reportUnknownParameterType = "none",
                reportUnknownVariableType = "none",
              },
              typeCheckingMode = "basic",
            },
          },
        },
      },

      -- TypeScript/JavaScript configuration with tsserver
      tsserver = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      },

      -- Go configuration with gopls
      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
            },
          },
        },
      },

      jdtls = {
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-17",
                  path = "/usr/lib/jvm/java-17-openjdk",
                },
                {
                  name = "JavaSE-21",
                  path = "/usr/lib/jvm/java-21-openjdk",
                },
              }
            },
            eclipse = {
              downloadSources = true,
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
          },
        },
      },
      
      -- Rust configuration with rust-analyzer
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = true,
              experimental = {
                enable = true,
              },
            },
            inlayHints = {
              enable = true,
              showParameterNames = true,
              parameterHintsPrefix = "<- ",
              otherHintsPrefix = "=> ",
            },
            cargo = {
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },

      -- Lua configuration with lua-language-server
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$HOME/.config/nvim/lua")] = true,
              },
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            telemetry = {
              enable = false,
            },
          },
        },
      },
      
      -- ESLint configuration (para ESLint v9 com flat config)
      eslint = {
        settings = {
          -- Configurações para ESLint v9
          useESLintClass = true,
          experimental = {
            useFlatConfig = true
          },
          -- Configurações adicionais
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = "separateLine"
            },
            showDocumentation = {
              enable = true
            }
          },
          codeActionOnSave = {
            enable = false,
            mode = "all"
          },
          format = true,
          nodePath = "",
          onIgnoredFiles = "off",
          packageManager = "pnpm",
          quiet = false,
          rulesCustomizations = {},
          run = "onType",
          workingDirectory = {
            mode = "location"
          }
        },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
          "svelte"
        },
        -- Definição personalizada de root_dir para encontrar o arquivo de configuração
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.find_git_ancestor(fname) or
                 util.root_pattern("eslint.config.js", "eslint.config.mjs", "eslint.config.cjs")(fname) or
                 util.root_pattern(".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs", ".eslintrc")(fname) or
                 vim.fn.getcwd()
        end,
      },
    }

    mason_lspconfig.setup_handlers({
      function(server_name)
        local server_config = server_configs[server_name] or {}
        server_config.capabilities = capabilities

        lspconfig[server_name].setup(server_config)
      end
    })
  end
}
