-- 1. Выход из режима вставки на jk
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })

-- 2. Навигация между окнами (Ctrl + h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- --- Codeium (ИИ подсказки) ---
-- ПРИНЯТЬ: Alt + Enter (как в WebStorm)
vim.keymap.set("i", "<M-CR>", function()
	return require("codeium.virtual_text").accept()
end, { expr = true, silent = true, desc = "Codeium Accept" })

-- ЛИСТАТЬ: Alt + ] и Alt + [
vim.keymap.set("i", "<M-]>", function()
	return require("codeium.virtual_text").cycle_completions(1)
end, { expr = true, desc = "Codeium Next" })

vim.keymap.set("i", "<M-[>", function()
	return require("codeium.virtual_text").cycle_completions(-1)
end, { expr = true, desc = "Codeium Prev" })

-- 4. УМНЫЙ ENTER (Разнос тегов и скобок)
vim.keymap.set("i", "<cr>", function()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]

	local char_before = line:sub(col, col)
	local char_after = line:sub(col + 1, col + 1)

	if
		(char_before == ">" and char_after == "<")
		or (
			(char_before == "{" and char_after == "}")
			or (char_before == "[" and char_after == "]")
			or (char_before == "(" and char_after == ")") -- Исправлено char_before -> char_after
		)
	then
		return "<cr><esc>O"
	end

	return "<cr>"
end, { expr = true, replace_keycodes = true, desc = "Smart Enter" })
