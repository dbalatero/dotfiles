--  ╭──────────────────────────────────────────────────────────╮
--  │   Testing                                                │
--  ╰──────────────────────────────────────────────────────────╯
return {
  {
    "janko-m/vim-test",
    dependencies = {
      "benmills/vimux",
    },
    config = function()
      vim.cmd([[
        nmap <silent> <leader>T :TestNearest<CR>
        nmap <silent> <leader>t :TestFile<CR>

        let g:test#preserve_screen = 1
        let test#neovim#term_position = "vert"
        let test#vim#term_position = "vert"

        let g:test#javascript#mocha#file_pattern = '\v.*_test\.(js|jsx|ts|tsx)$'

        if exists('$TMUX')
          " Use tmux to kick off tests if we are in tmux currently
          let test#strategy = 'vimux'
        else
          " Fallback to using terminal split
          let test#strategy = "neovim"
        endif

        let test#enabled_runners = ["lua#busted", "ruby#rspec", "javascript#jest"]

        let test#custom_runners = {}
        let test#custom_runners['ruby'] = ['rspec']
        let test#custom_runners['lua'] = ['busted']

        let test#custom_runners['javascript'] = ['jest']
        let test#custom_runners['typescript'] = ['jest']
      ]])
    end,
  },
}
