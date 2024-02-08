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


Crisp.createAutocmd = vim.api.nvim_create_autocmd
Crisp.createCommand = vim.api.nvim_create_user_command

return Crisp
