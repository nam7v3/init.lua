local keymap = vim.keymap
local api = vim.api
local opt = vim.opt
local fn = vim.fn

vim.cmd.colorscheme("retrobox")

vim.g.mapleader = " "

-- Searching
vim.opt.selection = "exclusive"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wildignore:append("*.o,*.obj,*.dll,*.exe,*.pdb")
vim.opt.wildignore:append("*/.git/*,*/build/*")

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.breakindent = true
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.formatoptions = "tq2c"

-- Completion
vim.opt.completeopt = "menuone,preview,popup"
vim.opt.pumheight = 5

-- Visual setting
vim.opt.number = true
vim.opt.showmode = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
-- vim.opt.showmatch = true
-- vim.opt.matchtime = 3
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.redrawtime = 1500
vim.opt.inccommand = "split"
vim.opt.timeoutlen = 3000
vim.opt.jumpoptions = "stack,view"
vim.opt.ruler = true
vim.o.background = "dark"

-- Behaviours
vim.opt.wrap = false
vim.opt.virtualedit = "all,onemore"
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.hidden = true
vim.opt.path:append("**")
vim.opt.mouse = 'a'
vim.o.background = "dark"

-- Netrw
vim.g.netrw_banner = 0

vim.opt.shellpipe = ">"

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank() end,
	desc = "Briefly highlight yanked text",
})

vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
  pattern = { "*.c", "*.h", "*.cc", "*.cpp", "*.hpp" },
  callback = function(ev)
    vim.cmd[[let c_no_curly_error=1]]
    vim.cmd[[set cindent]]
    vim.opt.makeprg = table.concat(detect_build_cmd(), " ")
    vim.opt.path = {".", "**"}
  end,
})

api.nvim_create_autocmd("DirChanged", {
  callback = function()
    vim.opt.path = { ".", "**" }
  end,
})
-- Utils function
function toggle_quickfix()
  local quickfix_open = false;
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      quickfix_open = true
    end
  end
  if quickfix_open then
    vim.cmd('cclose')
  else
    vim.cmd[[copen | horizontal resize 15]]
  end
end

local opts = {silent = true}

keymap.set("i", "<C-c>", "<C-[>")
keymap.set("n", "<C-c>", "<C-[><cmd>nohlsearch<CR>")

keymap.set("n", "<leader>d", ":Ex<CR>",{desc = "Open netrw"})

-- Buffer management
keymap.set("n", "]b", ":bnext<CR>", {desc = "Next buffer"})
keymap.set("n", "[b", ":bprevious<CR>", {desc = "Prev buffer"})
keymap.set("n", "[B", ":bfirst<CR>", {desc = "First buffer"})
keymap.set("n", "]B", ":blast<CR>", {desc = "Last buffer"})

function pick_buffer()
  local buffers = {}
  local cwd = fn.getcwd(0, 0)
  cwd = cwd:gsub("/$", "")

  for _, id in ipairs(api.nvim_list_bufs()) do
    local name = api.nvim_buf_get_name(id)
    local relative_path = name:gsub("^" .. cwd .. "/", "")
    local cursor = api.nvim_buf_get_mark(id, '"')
    local buftype = api.nvim_get_option_value("buftype", {buf = id})
    local filetype = api.nvim_get_option_value("filetype", {buf = id})

    if name ~= "" and buftype == "" and filetype ~= "netrw" then
      table.insert(buffers, {
        bufnr = id,
        filename = relative_path,
        lnum = cursor[1],
        col = cursor[2],
        text = string.format("#%d", id)
      })
    end
  end
  table.sort(buffers, function(a, b)
    return a.filename > b.filename
  end)
  fn.setqflist({}, " ", { title = "Buffers" })
  fn.setqflist(buffers, "a")
  toggle_quickfix()
end

keymap.set("n", "<leader>b", pick_buffer, {desc = "Interactively pick buffer"});

-- Tab navigation
keymap.set("n", "]t", ":tabnext<CR>", {desc = "Next tab"})
keymap.set("n", "[t", ":tabprevious<CR>", {desc = "Prev tab"})
keymap.set("n", "[T", ":tabfirst<CR>", {desc = "First tab"})
keymap.set("n", "]T", ":tablast<CR>", {desc = "Last tab"})
keymap.set("n", "<leader>t", ":tabnew<CR>", {desc = "Create a new tab"})

-- Quickfix navigation
keymap.set("n", "]c", ":cnext<CR>", {desc = "Next quickfix"})
keymap.set("n", "[c", ":cprevious<CR>", {desc = "Prev quickfix"})
keymap.set("n", "[C", ":cfirst<CR>", {desc = "First quickfix"})
keymap.set("n", "]C", ":clast<CR>", {desc = "Last quickfix"})

-- Error navigation
keymap.set("n", "[e", function() vim.diagnostic.goto_prev() end, opts)
keymap.set("n", "]e", function() vim.diagnostic.goto_next() end, opts)

-- Scroll
keymap.set('n', '<C-d>', '<C-d>zz')
keymap.set('n', '<C-u>', '<C-u>zz')

-- keymap.set("t", "<C-\\>", "<C-\\><C-n>", {desc = "Escape da terminal"})

-- Window navigation
keymap.set("n", "<C-J>", "<C-W>j")
keymap.set("n", "<C-K>", "<C-W>k")
keymap.set("n", "<C-L>", "<C-W>l")
keymap.set("n", "<C-H>", "<C-W>h")
keymap.set("n", "<C-Left>", ":vertical resize-3<CR>", {silent = true})
keymap.set("n", "<C-Right>", ":vertical resize+3<CR>", {silent = true})
keymap.set("n", "<C-Up>", ":horizontal resize-3<CR>", {silent = true})
keymap.set("n", "<C-Down>", ":horizontal resize+3<CR>", {silent = true})

-- Visual mode
keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Shift region down"})
keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Shift region up"})
keymap.set("v", ">", ">gv", {desc = "Continue to select shift region"})
keymap.set("v", "<", "<gv", {desc = "Continue to select shift region"})

-- quick
keymap.set("v", "(", "<Esc>`<i(<Esc>`>a)<Esc>`<v`>f)")
keymap.set("v", "[", "<Esc>`<i[<Esc>`>a]<Esc>`<v`>f]")
keymap.set("v", "{", "<Esc>`<i{<Esc>`>a}<Esc>`<v`>f}")
keymap.set("v", ")", "<Esc>`<i(<Esc>`>a)<Esc>`<v`>f)")
keymap.set("v", "]", "<Esc>`<i[<Esc>`>a]<Esc>`<v`>f]")
keymap.set("v", "}", "<Esc>`<i{<Esc>`>a}<Esc>`<v`>f}")
keymap.set("v", "g>", "<Esc>`<i<<Esc>`>a><Esc>`<v`>f>")
keymap.set("v", "g<", "<Esc>`<i<<Esc>`>a><Esc>`<v`>f>")
keymap.set("v", 'g"', '<Esc>`<i"<Esc>`>a"<Esc>`<v`>f"')
keymap.set("v", "g'", "<Esc>`<i'<Esc>`>a'<Esc>`<v`>f'")

-- Navigation
keymap.set({'n', 'o', 'v'}, 'L', '$')
keymap.set({'n', 'o', 'v'}, 'H', '^')

-- Building

function detect_build_cmd()
  local make_files = {
    ["build.sh"] = {"./build.sh"},
    ["build.ps1"] = {"powershell", "-NoProfile", "-NoExit", ".\\build.ps1"},
    ["build.bat"] = {"build.bat"},
    ["Makefile"] = {"make"},
    ["CMakeList.txt"] = {"cmake"},
    ["meson.build"] = {"meson"},
    ["premake5.lua"] = {"premake5"},
  }
  local cwd = fn.getcwd(0, 0)
  for file, cmd in pairs(make_files) do
    local filepath = cwd .. "/" .. file
    if fn.filereadable(filepath) == 1 then
      return cmd
    end
  end
  return nil
end

function async_make(args)
  local winnr = vim.fn.win_getid()
  local bufnr = api.nvim_win_get_buf(winnr)

  local makeprg = api.nvim_get_option_value("makeprg", {scope = "global"})
  local errorformat = api.nvim_get_option_value("errorformat", {scope = "global"})

  local make_cmd = detect_build_cmd()
  if not make_cmd then
    error("Build: failed to detect build command");
    return
  end

  local make_str = table.concat(make_cmd, " ")

  if args ~= nil then
    for _, arg in ipairs(args) do
      table.insert(make_cmd, arg)
    end
  end

  vim.cmd("wall")
  vim.print("Build: " .. make_str)

  local start_time = vim.uv.hrtime()
  local function on_exit(result)
    local end_time = vim.uv.hrtime()
    local duration = (end_time - start_time) / 1e9
    local err_start, err_end = string.find(result.stderr, '%d+ errors?')
    local err_count = err_start and string.sub(result.stderr, err_start, err_end) or ""

    if string.len(err_count) > 0 then
      print(string.format("Build: failed with %s", err_count))
    else
      print(string.format("Build: succeed in %.2f s.", duration))
    end

    local output = vim.split(result.stdout .. result.stderr, "\n", { plain = false })
    vim.schedule(function ()
      vim.g.make_is_building = false
      vim.fn.setqflist({}, " ", {
        title = make_str .. err_count,
        lines = output,
        efm = errorformat,
      })
      if #result.stderr > 0 then
        vim.cmd("doautocmd QuickFixCmdPost")
        vim.cmd[[copen | horizontal resize 15]]
      end
    end)
  end
  vim.g.make_is_building = true
  if vim.g.make_is_building then
    vim.system(make_cmd, { text = true }, on_exit)
  end
end

api.nvim_create_user_command("Build", function(opts)
  async_make(opts.fargs)
end, {
  nargs = "*",
  complete = "file", -- optional completion
})

keymap.set('n', '<C-p>', function () toggle_quickfix() end, { desc = 'Toggle Quickfix' })
keymap.set('n', '<C-b>', function () async_make() end, { desc = 'Building the project' })

keymap.set({"n", "o", "v"}, "L", "$")
keymap.set({"n", "o", "v"}, "H", "^")

-- Editting
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "U", "<C-r>", {desc = "Redo"})

-- Searching

-- Diagnostic
-- keymap.set("n", "<leader>e", function() vim.diagnostic.open_float() end, opts)
-- keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Fast clipboard
keymap.set({"n", "v"}, "<leader>y", '"+y')
keymap.set({"n", "v"}, "<leader>Y", '"+Y')
keymap.set({"n", "v"}, "<leader>p", '"+p')
keymap.set({"n", "v"}, "<leader>P", '"+P')

keymap.set({'n', 'v'}, '<leader>f', ':find ', {desc = 'Find file'})
keymap.set({'n', 'v'}, '<leader>/', ':grep ', {desc = 'Find file'})
-- keymap.set({'n', 'v'}, '<leader>f', '<cmd>Telescope find_files<cr>', {desc = 'Find file'})
-- keymap.set({'n', 'v'}, '<leader>/', '<cmd>Telescope live_grep<cr>', {desc = 'Grep'})
-- keymap.set({'n', 'v'}, '<leader>b', '<cmd>Telescope buffers<cr>', {desc = 'Find buffer'})
-- keymap.set({'n', 'v'}, '<leader>gc', '<cmd>Telescope git_commits<cr>', {desc = 'Git commits'})
-- keymap.set({'n', 'v'}, '<leader>gb', '<cmd>Telescope git_branches<cr>', {desc = 'Git branches'})
-- keymap.set({'n', 'v'}, '<leader>gs', '<cmd>Telescope git_status<cr>', {desc = 'Git status'})

if vim.g.neovide then
  vim.o.guifont= "Hack:h12"
  vim.g.neovide_opacity = 1.0
  vim.g.neovide_cursor_animation_length = 0.0
  keymap.set({'n', 'i'}, '<F11>', function ()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, {})
end

-- Folding
-- api.nvim_create_augroup("Fold", { clear = true })
--
-- api.nvim_create_autocmd("BufWinLeave", {
--   group = "Fold",
--   pattern = "*.c",
--   command = "mkview"
-- })
--
-- api.nvim_create_autocmd("BufWinEnter", {
--   group = "Fold",
--   pattern = "*.c",
--   command = "silent! loadview"
-- })


vim.cmd [[ highlight cTodo ctermfg=Red cterm=bold,underline guifg=#fb4934 gui=bold,underline ]]
vim.cmd [[ highlight myNote ctermfg=Blue cterm=bold,underline guifg=#458588 gui=bold,underline ]]
vim.cmd [[
  filetype plugin indent on
  syntax enable
]]

vim.api.nvim_create_autocmd("Syntax", {
  pattern = "*",
  command = "syntax match myNote /NOTE/ containedin=ALL",
})
