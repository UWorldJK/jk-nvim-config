return {
	"oclay1st/gradle.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	cmd = {
		"Gradle",
		"GradleExec",
		"GradleInit",
		"GradleFavorites",
	},
	keys = {
		{ "<leader>Gg", "<cmd>Gradle<cr>", desc = "Open Gradle projects" },
		{ "<leader>Ge", "<cmd>GradleExec<cr>", desc = "Execute Gradle task" },
		{ "<leader>Gi", "<cmd>GradleInit<cr>", desc = "Create new Gradle project" },
		{ "<leader>Gf", "<cmd>GradleFavorites<cr>", desc = "Open Gradle favorites" },
	},
}
