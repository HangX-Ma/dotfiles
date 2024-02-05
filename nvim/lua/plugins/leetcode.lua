require("leetcode").setup {
    arg = "leetcode.nvim",
    lang = "cpp",
    cn = { -- leetcode.cn
        enabled = true,
        translator = false,
        translate_problems = false,
    },

    injector = {
        ["cpp"] = {
            before = {
                "#include <iostream>;",
                "#include <string>;",
                "#include <vector>;",
                "using namespace std;"
            },
        },
    },
    description = {
        position = "left",
        width = "40%",
        show_stats = true,
    },
    image_support = false,
}
