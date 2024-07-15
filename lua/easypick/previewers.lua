local previewers = require("telescope.previewers")
local putils = require("telescope.previewers.utils")
local util = require("easypick.util")

local default = function(opts)
	opts = opts or {}
	return previewers.vim_buffer_cat.new(opts)
end

local branch_diff = function(opts)
	return previewers.new_buffer_previewer({
		title = "Git Branch Diff Preview",
		get_buffer_by_name = function(_, entry)
			return entry.value
		end,

		define_preview = function(self, entry, _)
			local file_name = entry.value

			local base_branch = opts.base_branch:gsub("\n", "")

			-- Convert file_name to an absolute path relative to git root
			local git_root = util.git_root()
			file_name = vim.fn.fnamemodify(git_root .. "/" .. file_name, ":p")

			local cmd = {
				"git",
				"--no-pager",
				"diff",
				base_branch,
				"HEAD",
				"--",
				file_name,
			}

			putils.job_maker(cmd, self.state.bufnr, {
				value = file_name,
				bufname = self.state.bufname,
			})
			putils.regex_highlighter(self.state.bufnr, "diff")
		end,
	})
end

local file_diff = function(opts)
	opts = opts or {}
	return previewers.git_file_diff.new(opts)
end

return {
	default = default,
	branch_diff = branch_diff,
	file_diff = file_diff,
}
