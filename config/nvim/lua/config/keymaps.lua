vim.keymap.set('n', '\\cd', '<cmd>cd %:p:h<cr>', { desc = "Change directory to current buffer's directory" })
vim.keymap.set('n', '\\cl', '<cmd>lcd %:p:h<cr>', { desc = "Like cd but set the current directory for the current window" })
vim.keymap.set('n', '\\rtb', '<cmd>%s/\\s\\+$//e<cr> \\| <cmd>noh<cr>', { desc = 'Remove trailing spaces from buffer' })
vim.keymap.set('n', '\\rtl', '<cmd>s/\\s\\+$//e<cr> \\| <cmd>noh<cr>', { desc = 'Remove trailing spaces from line' })
