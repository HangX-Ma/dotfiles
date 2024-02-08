local crisp = require("core.crisp")

crisp.createAutocmd({ "VimEnter" }, {
    command = "clearjumps",
})

crisp.createAutocmd({ "FileType" }, {
    command = "set formatoptions-=ro",
})
