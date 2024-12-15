return {
  {
    url = "git@git.corp.stripe.com:dbalatero/stripe-luasnips.nvim.git",
    dependencies = { "L3MON4D3/LuaSnip" },
    cond = require("custom.config").stripe.utils.is_stripe_machine,
    config = function()
      require("stripe-luasnips")

      local snipConfig = require("stripe-luasnips.config")
      snipConfig.payfile.opus_project = "payment_pages"
      snipConfig.todo.jira_project = "RUN_CPL"
    end,
  },
}
