return {
	"windwp/nvim-ts-autotag",

	-- Вкладывать opts в opts не нужно, пишем настройки сразу
	opts = {
		enable_close = true, -- Автозакрытие (пишешь <div> -> получаешь </div>)
		enable_rename = true, -- Переименование (меняешь <div> на <section> -> закрывающий меняется сам)
		enable_close_on_slash = true, -- Закрытие при вводе /
	},
	-- Можно добавить список расширений, где это должно работать железно
	filetypes = {
		"html",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"svelte",
		"vue",
		"tsx",
		"jsx",
		"xml",
	},
}
