return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Optional
    {
      "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        anthropic = require("codecompanion.adapters").use("anthropic", {
          schema = {
            model = {
              default = "claude-3-sonnet-20240229",
            },
          },
          env = {
            api_key = "ANTHROPIC_API_KEY"
          },
        }),
      },
      strategies = {
        chat = "anthropic",
        inline = "anthropic",
        agent = "anthropic"
      },
      prompts = {
        ["Full Context Rewriter"] = {
          opts = {
            mapping = "<leader>cf",
            modes = { "v" },
            shortcut = "full_context",
            auto_submit = true,
            user_prompt = false,
          },
          strategy = "inline",
          description = "Prompt against the context of you code",
          prompts = {
            {
              role = "system",
              content = function (context)
                return "I want you to act as an expert and senior developer in the " .. context.filetype .. " developer. "
                  .. "You are to return raw code only (no codeblocks and no explanations). "
                  .. "Match the indentation of the contexted code provided. "
                  .. "If you can't respond with code, respond with nothing. \n\n"
                  .. "Here is the context for the request being made:\n"
                  .. "```" .. context.filetype .. "\n"
                  .. table.concat(vim.api.nvim_buf_get_lines(context.bufnr, 0, -1, false), "\n")
                  .. "```"
              end,
            },
            {
              role = "user",
              content = function (context)
                return "Your goal are to replace the following code following the user's instructions embeded in the following code block as comments: (Do not forget to match the indentation)\n"
                  .. "```" .. context.filetype .. "\n"
                  .. require("codecompanion.helpers.code").get_code(context.start_line, context.end_line) .. "\n"
                  .. "```"
              end,
            }
          }
        }
      }
    })
  end,

}

