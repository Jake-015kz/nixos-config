return {
	"David-Kunz/gen.nvim",
	-- Плагин загрузится сразу, чтобы Which-key успел подхватить кнопки
	lazy = false,
	-- Описываем ключи так, как этого ждет LazyVim
	keys = {
		{ "<leader>ai", ":Gen<CR>", mode = { "n", "v" }, desc = "Меню ИИ (Jake)" },
		{ "<leader>ag", ":Gen Generate<CR>", mode = { "n", "v" }, desc = "Запрос ИИ (Jake)" },
	},
	opts = {
		model = "qwen-jake",
		display_mode = "float",
		show_model = true,
		no_auto_close = true,
		-- Твой фирменный русский промпт
		prompt = "Отвечай строго на РУССКОМ языке. Инструкция: $prompt\nКод: $text",
	},
}
