local keymap = vim.keymap
local api = vim.api
local opt = vim.opt
local fn = vim.fn
local g = vim.g

-- GUI
vim.cmd.colorscheme("retrobox")

opt.guifont= "Hack Nerd Font Mono:h12"
opt.background = "dark"
opt.number = true
opt.showmode = true
opt.title = false
opt.cursorline = true

g.neovide_cursor_animation_length = 0.0

-- Editor
opt.scrolloff = 10
opt.splitbelow = true
opt.splitright = true
opt.wrap = true
opt.virtualedit = "onemore"
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.hidden = true
opt.mouse = 'a'
opt.clipboard:append("unnamedplus")
opt.autoread = true
opt.inccommand = "split"
opt.timeoutlen = 3000
opt.ruler = false
opt.wildmenu = true
opt.wildoptions:remove("pum")

-- Completion
opt.completeopt = "menuone,popup"
opt.pumheight = 8

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.breakindent = true
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Searching
opt.selection = "exclusive"
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.wildmenu = true

-- Netrw
g.netrw_banner = 0
g.netrw_altv = 1

vim.cmd [[ highlight link @comment.note Todo ]]
vim.cmd [[ highlight link @comment.todo Todo ]]
vim.cmd [[ highlight link @comment.error Todo ]]

api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function() vim.highlight.on_yank() end,
	desc = "Briefly highlight yanked text",
})

api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

api.nvim_create_autocmd({ "FileType" },  {
  desc = "Setting some common c stuff",
  pattern = {"c", "cpp", "h", "hpp"},
  callback = function(args)
    vim.treesitter.start(args.buf, "c")
    vim.bo.omnifunc = 'v:lua.vim.treesitter.query.omnifunc'
  end,
})

-- Utils function

g.mapleader = " "

keymap.set("i", "<C-c>", "<C-[>")
keymap.set("n", "<C-c>", "<C-[><cmd>nohlsearch<CR>")

keymap.set("n", "<leader>d", ":Ex<CR>",{desc = "Open netrw"})

-- Buffer management
keymap.set("n", "]b", ":bnext<CR>", {desc = "Next buffer"})
keymap.set("n", "[b", ":bprevious<CR>", {desc = "Prev buffer"})
keymap.set("n", "[B", ":bfirst<CR>", {desc = "First buffer"})
keymap.set("n", "]B", ":blast<CR>", {desc = "Last buffer"})

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

keymap.set('n', '<C-p>', function () toggle_quickfix() end, { desc = 'Toggle Quickfix' })
keymap.set('n', '<C-b>', function () async_build(detect_build_cmd()) end, { desc = 'Building the project' })

keymap.set({"n", "o", "v"}, "L", "$")
keymap.set({"n", "o", "v"}, "H", "^")

-- Editting
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "U", "<C-r>", {desc = "Redo"})

-- Searching
keymap.set("n", "n", "nzz", {desc = "Center next search"})
keymap.set("n", "N", "Nzz", {desc = "Center prev search"})

-- Fast clipboard
keymap.set({"n", "v"}, "<leader>y", '"+y')
keymap.set({"n", "v"}, "<leader>Y", '"+Y')
keymap.set({"n", "v"}, "<leader>p", '"+p')
keymap.set({"n", "v"}, "<leader>P", '"+P')

keymap.set({'n', 'v'}, '<leader>f', '<cmd>Telescope find_files<cr>', {desc = 'Find file'})
keymap.set({'n', 'v'}, '<leader>/', '<cmd>Telescope live_grep<cr>', {desc = 'Grep'})
keymap.set({'n', 'v'}, '<leader>b', '<cmd>Telescope buffers<cr>', {desc = 'Find buffer'})

if vim.g.neovide then
  keymap.set({'n','v' ,'o', 'i'}, '<F11>', function ()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, {})
end

-- Building
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
    vim.cmd('copen')
  end
end

local buildcmd_files = {
  ["build.sh"] = {"bash", "-c", "./build.sh"},
  ["build.ps1"] = {"powershell", "-NoProfile", "-NoExit", ".\\build.ps1"},
  ["build.bat"] = {"cmd.exe", "/c", "build.bat"},
  ["build.zig"] = {"zig.exe", "build"},
  ["Makefile"] = {"make"},
  ["CMakeList.txt"] = {"cmake"},
  ["meson.build"] = {"meson"},
  ["premake5.lua"] = {"premake5"},
}

function detect_build_cmd()
  local cwd = fn.getcwd(0, 0)
  for file, cmd in pairs(buildcmd_files) do
    local filepath = cwd .. "/" .. file
    if fn.filereadable(filepath) == 1 then
      return cmd
    end
  end
  return ""
end

function async_run(buildcmd)
  if not buildcmd then
    print("Run: no build command");
    return
  end

  local buildstr = table.concat(buildcmd, " ")

  if args ~= nil then
    for _, arg in ipairs(args) do
      table.insert(buildcmd, arg)
    end
  end

  vim.cmd("silent! wall")

  local start_time = vim.uv.hrtime()
  local function on_exit(result)
    local end_time = vim.uv.hrtime()
    local duration = (end_time - start_time) / 1e9

    vim.schedule(function ()
      g.async_make_running = false
      fn.setqflist({}, 'a', {
        title = string.format("%s: completed in %.2fs", buildstr, duration)
      })
    end)
  end

  local function on_stdout(err, data)
    if data then
      vim.schedule(function ()
        local lines = vim.split(data, "\n", { trimempty = true })
        fn.setqflist({}, "a", { lines = lines })
      end)
    end
  end
  vim.g.async_make_running = true
  if vim.g.async_make_running then
    vim.system(buildcmd, { text = true, stdout = on_stdout}, on_exit)
  end
  fn.setqflist({}, "f", { title = string.format("%s: building", buildstr) })
  vim.cmd("copen")
end

api.nvim_create_user_command("Run", function(opts)
  local buildcmd = opts.fargs
  if #opts.fargs < 1 then
    buildcmd = detect_build_cmd()
  end
  async_run(buildcmd)
end, {
  nargs = "*",
  complete = "file",
})

require('telescope').setup({
  defaults = {
    file_ignore_patterns = {
      "%.git", "%.zig%-cache",
      "%.exe", "%.dll", "%.so", "%.obj", "%.a", "%.pdb", "%.ilk",
      "%.png", "%.jpg", "%.jpeg", "%.gif", "%.bmp", "%.ico",
      "%.pdf", "%.zip", "%.tar", "%.gz", "%.rar",
      "%.mp3", "%.mp4", "%.mkv", "%.avi", "%.wav",
      "%.lock",
    },
  },
})
