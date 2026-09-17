-- nvim-treesitter-textobjects (branch `main`): os keymaps não são mais configurados
-- via `nvim-treesitter.configs`; agora cada um é um vim.keymap.set chamando o módulo.
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    local function map_select(lhs, query, desc)
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(query, "textobjects")
      end, { desc = desc })
    end

    local function map_move(lhs, fn, query, desc, group)
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        fn(query, group or "textobjects")
      end, { desc = desc })
    end

    local function map_swap(lhs, fn, query, desc)
      vim.keymap.set("n", lhs, function()
        fn(query)
      end, { desc = desc })
    end

    -- select
    map_select("a=", "@assignment.outer", "Select outer part of an assignment")
    map_select("i=", "@assignment.inner", "Select inner part of an assignment")
    map_select("l=", "@assignment.lhs", "Select left hand side of an assignment")
    map_select("r=", "@assignment.rhs", "Select right hand side of an assignment")
    map_select("a:", "@property.outer", "Select outer part of an object property")
    map_select("i:", "@property.inner", "Select inner part of an object property")
    map_select("l:", "@property.lhs", "Select left part of an object property")
    map_select("r:", "@property.rhs", "Select right part of an object property")
    map_select("aa", "@parameter.outer", "Select outer part of a parameter/argument")
    map_select("ia", "@parameter.inner", "Select inner part of a parameter/argument")
    map_select("ai", "@conditional.outer", "Select outer part of a conditional")
    map_select("ii", "@conditional.inner", "Select inner part of a conditional")
    map_select("al", "@loop.outer", "Select outer part of a loop")
    map_select("il", "@loop.inner", "Select inner part of a loop")
    map_select("af", "@call.outer", "Select outer part of a function call")
    map_select("if", "@call.inner", "Select inner part of a function call")
    map_select("am", "@function.outer", "Select outer part of a method/function definition")
    map_select("im", "@function.inner", "Select inner part of a method/function definition")
    map_select("ac", "@class.outer", "Select outer part of a class")
    map_select("ic", "@class.inner", "Select inner part of a class")

    -- swap
    map_swap("<leader>na", swap.swap_next, "@parameter.inner", "Swap parameter with next")
    map_swap("<leader>n:", swap.swap_next, "@property.outer", "Swap property with next")
    map_swap("<leader>nm", swap.swap_next, "@function.outer", "Swap function with next")
    map_swap("<leader>pa", swap.swap_previous, "@parameter.inner", "Swap parameter with previous")
    map_swap("<leader>p:", swap.swap_previous, "@property.outer", "Swap property with previous")
    map_swap("<leader>pm", swap.swap_previous, "@function.outer", "Swap function with previous")

    -- move: next start
    map_move("]f", move.goto_next_start, "@call.outer", "Next function call start")
    map_move("]m", move.goto_next_start, "@function.outer", "Next method/function def start")
    map_move("]c", move.goto_next_start, "@class.outer", "Next class start")
    map_move("]i", move.goto_next_start, "@conditional.outer", "Next conditional start")
    map_move("]l", move.goto_next_start, "@loop.outer", "Next loop start")
    map_move("]s", move.goto_next_start, "@local.scope", "Next scope", "locals")
    map_move("]z", move.goto_next_start, "@fold", "Next fold", "folds")
    -- move: next end
    map_move("]F", move.goto_next_end, "@call.outer", "Next function call end")
    map_move("]M", move.goto_next_end, "@function.outer", "Next method/function def end")
    map_move("]C", move.goto_next_end, "@class.outer", "Next class end")
    map_move("]I", move.goto_next_end, "@conditional.outer", "Next conditional end")
    map_move("]L", move.goto_next_end, "@loop.outer", "Next loop end")
    -- move: previous start
    map_move("[f", move.goto_previous_start, "@call.outer", "Prev function call start")
    map_move("[m", move.goto_previous_start, "@function.outer", "Prev method/function def start")
    map_move("[c", move.goto_previous_start, "@class.outer", "Prev class start")
    map_move("[i", move.goto_previous_start, "@conditional.outer", "Prev conditional start")
    map_move("[l", move.goto_previous_start, "@loop.outer", "Prev loop start")
    -- move: previous end
    map_move("[F", move.goto_previous_end, "@call.outer", "Prev function call end")
    map_move("[M", move.goto_previous_end, "@function.outer", "Prev method/function def end")
    map_move("[C", move.goto_previous_end, "@class.outer", "Prev class end")
    map_move("[I", move.goto_previous_end, "@conditional.outer", "Prev conditional end")
    map_move("[L", move.goto_previous_end, "@loop.outer", "Prev loop end")

    -- repeat last move with ; and , (and keep builtin f/F/t/T repeatable)
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
