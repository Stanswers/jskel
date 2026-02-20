-- tagstop = 2
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"lua", "java", "sh", "html", "xhtml", "css", "json"},
  callback = function() vim.opt.tabstop = 2 end,
})

-- tabstop = 4
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"go", "python", "make", "gitconfig", "c", "cpp", "xml", "xslt", "xsd"},
  callback = function() vim.opt.tabstop = 4 end,
})

-- tabstop = 8
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"markdown", "help", "text", "make"},
  callback = function() vim.opt.tabstop = 8 end,
})

-- tabs not spaces
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"make"},
  callback = function() vim.opt.expandtab = false end,
})

-- auto return at text width
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"markdown", "help", "text"},
  callback = function() vim.opt.textwidth = 78 end,
})

-- enable spell check for git commits
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"gitcommit"},
  callback = function() vim.opt.spell = true end,
})

-- detect jsonnet as json
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
--   pattern = '*.jsonnet',
--   command = 'setlocal filetype=json'
-- })

