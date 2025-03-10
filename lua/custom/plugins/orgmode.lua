return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup {
      org_agenda_files = '~/org/**/*',
      org_default_notes_file = '~/org/refile.org',
      org_startup_folded = 'showeverything',
    }

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
    --

    -- Create a new .org file in ~/org/ and open it in a new tab
    local function create_org_file()
      local org_dir = vim.fn.expand '~/org/' -- The org directory
      local input = vim.fn.input 'Enter filename: ' -- Prompt for filename

      -- Validate the input
      if input == nil or input == '' then
        print 'Invalid filename.'
        return
      end

      -- Ensure the filename has the .org extension
      local filename = input:match '.*%.org$' and input or input .. '.org'
      local filepath = org_dir .. filename

      -- Create the file and open it in a new tab
      vim.cmd('tabnew ' .. filepath)
      print('Created new org file in a new tab: ' .. filepath)
    end

    -- Keymap to create a new org file in a new tab
    vim.keymap.set('n', '<leader>of', create_org_file, { desc = '[C]reate new [O]rg file in a tab' })
  end,
}
