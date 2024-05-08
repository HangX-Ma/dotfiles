return {
	"tpope/vim-surround",
	event = { "BufReadPre", "BufNewFile" },
	version = "*",

    -- USAGE, ex: "Hello World"
    -- 1. cs"': replace "" to ''
    -- 2. cst": to full circle
    -- 3. ds": remove " entirely
    -- 4. ysiw]: With the cursor on "Hello", press ysiw] (iw is a text object) to "[Hello] World"
    -- 5. yss) or yssb: wrap the entire line in parentheses
}
