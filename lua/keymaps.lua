-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Eval a line
vim.keymap.set('n', '<space>x', ':.lua<CR>', { desc = 'Eval the current lua line' })
vim.keymap.set('v', '<space>x', ':.lua<CR>', { desc = 'Eval the current lua line' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local function open_project_org_file()
  -- Check if the floating buffer is already open
  local buf_name = 'project_file'
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == buf_name and vim.api.nvim_buf_is_loaded(buf) then
      vim.cmd('buffer ' .. buf)
      return
    end
  end

  -- Get the name of the current working directory
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

  -- Generate the potential file names
  local formatted_cwd_hyphen = string.lower(cwd):gsub('_', '-')
  local formatted_cwd_underscore = string.lower(cwd):gsub('-', '_')

  -- Construct the full paths to the potential .org files
  local org_file_hyphen = '~/org/' .. formatted_cwd_hyphen .. '.org'
  local org_file_underscore = '~/org/' .. formatted_cwd_underscore .. '.org'

  -- Check if either file exists
  local target_file = nil
  if vim.fn.filereadable(vim.fn.expand(org_file_hyphen)) == 1 then
    target_file = org_file_hyphen
  elseif vim.fn.filereadable(vim.fn.expand(org_file_underscore)) == 1 then
    target_file = org_file_underscore
  else
    vim.notify('No project org file found for ' .. cwd, vim.log.levels.WARN)
    return
  end

  -- Create a floating window and open the project file
  local width = math.ceil(vim.o.columns * 0.8)
  local height = math.ceil(vim.o.lines * 0.8)
  local row = math.ceil((vim.o.lines - height) / 2)
  local col = math.ceil((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }

  -- Create a new buffer and set its name
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, buf_name)
  vim.api.nvim_open_win(buf, true, opts)

  -- Open the target file in the buffer
  vim.cmd('edit ' .. target_file)
end

-- Create a keymap for the custom function
vim.keymap.set('n', '<leader>op', open_project_org_file, { desc = '[O]pen [P]roject org file' })

-- vim: ts=2 sts=2 sw=2 et
