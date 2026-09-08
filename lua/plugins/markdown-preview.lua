-- markdown-preview.nvim ships a node app that vim.pack.add never builds;
-- run its install step ourselves whenever the plugin is installed/updated.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "markdown-preview.nvim" and ev.data.kind ~= "delete" then
			vim.system({ "npm", "install" }, { cwd = ev.data.path .. "/app" })
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
})
