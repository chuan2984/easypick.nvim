local function debug_print(object)
	vim.notify("Debug: " .. vim.inspect(object), vim.log.levels.Debug)
end

local git_root = function()
	local git_root_path = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		debug_print("Error: Not in a git repository")
		return
	end
	return git_root_path
end

return {
	debug_print = debug_print,
	git_root = git_root,
}
