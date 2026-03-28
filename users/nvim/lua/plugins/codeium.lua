return {
	{
		"Exafunction/codeium.nvim",
		cmd = "Codeium",
		event = "InsertEnter",
		build = ":Codeium Auth",
		opts = {
			enable_cmp_source = false, -- Отключаем в выпадающем списке, оставляем только текст
			virtual_text = {
				enabled = true,
				key_bindings = {
					accept = false, -- Отключаем стандартный, переопределим в keymaps
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
		},
	},
}
