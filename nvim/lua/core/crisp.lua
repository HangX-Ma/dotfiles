local Crisp = {}

function Crisp.notifyLSPError()
	return not os.getenv("NVIM_NOT_NOTIFY_LSP_ERROR")
end

function Crisp.prequire(module)
	local ok, result = pcall(require, module)
	if ok then
		return result
	else
		return nil
	end
end

function Crisp.isBigFile(bufnr)
	local maxSize = 1024 * 1024 -- 1MB
	local maxLine = 2048
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	local lineCount = vim.api.nvim_buf_line_count(bufnr)
	if ok and stats then
		if stats.size > maxSize then
			return true
		end
		if lineCount > maxLine then
			return true
		end
	end
	return false
end

Crisp.notify = function(msg, level, title)
	local notify = Crisp.prequire("notify")
	if notify then
		notify(msg, level, { title = title, timeout = 1000 })
	else
		vim.notify(msg, level)
	end
end

Crisp.info = function(msg, title)
	Crisp.notify(msg, vim.log.levels.INFO, title)
end

Crisp.warn = function(msg, title)
	Crisp.notify(msg, vim.log.levels.WARN, title)
end

Crisp.error = function(msg, title)
	Crisp.notify(msg, vim.log.levels.ERROR, title)
end

Crisp.setKeymap = function(mode, lhs, rhs, opts)
	opts = opts or {}

	vim.tbl_extend("keep", opts, {
		noremap = true,
		silent = true,
	})

	if type(rhs) == "function" then
		opts.callback = rhs
		rhs = ""
	end

	vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

Crisp.setBufKeymap = function(buffer, mode, lhs, rhs, opts)
	opts = opts or {}

	vim.tbl_extend("keep", opts, {
		noremap = true,
		silent = true,
	})

	if type(rhs) == "function" then
		opts.callback = rhs
		rhs = ""
	end

	vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
end

Crisp.createAutocmd = vim.api.nvim_create_autocmd
Crisp.createCommand = vim.api.nvim_create_user_command

return Crisp
