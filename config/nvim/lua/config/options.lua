vim.opt.incsearch = false
vim.opt.colorcolumn = "80"
vim.opt.synmaxcol = 365
vim.opt.listchars = { space = '·', tab = '»·', trail= '~', eol = '▼' }
vim.opt.list = false
vim.opt.makeprg = "tbmake -sj TESTS=NO RECURSIVE=YES"
vim.opt.scrolljump = 20

-- tab settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.softtabstop = -1

vim.g.clipboard = "win32yank"

vim.g.autoformat = false

