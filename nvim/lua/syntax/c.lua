-- https://github.com/bfrg/vim-c-cpp-modern
-- 设置高亮组
vim.api.nvim_set_hl(0, "cTodo", { link = "Todo" })
vim.api.nvim_set_hl(0, "cUserFunction", { link = "Function" })
vim.api.nvim_set_hl(0, "cUserFunctionPointer", { link = "Function" })
vim.api.nvim_set_hl(0, "cStructMember", { link = "Identifier" })
vim.api.nvim_set_hl(0, "cTypeName", { link = "Type" })
vim.api.nvim_set_hl(0, "cOperator", { link = "Operator" })
vim.api.nvim_set_hl(0, "cAnsiName", { link = "Identifier" })
vim.api.nvim_set_hl(0, "cBoolean", { link = "Boolean" })

-- 高亮注释中的关键词
vim.cmd([[
syn keyword cTodo contained BUG NOTE
]])

-- 高亮函数名
if vim.g.cpp_function_highlight == 1 then
	vim.cmd([[
    syn match cUserFunction "\<\h\w*\ze\_s\{-}(\%(\*\h\w*)\_s\{-}(\)\@!"
    syn match cUserFunctionPointer "\%((\s*\*\s*\)\@6<=\h\w*\ze\s*)\_s\{-}(.*)"
    ]])
end

-- 高亮结构体/类成员变量
if vim.g.cpp_member_highlight == 1 then
	vim.cmd([[
    syn match cMemberAccess "\.\|->" nextgroup=cStructMember,cppTemplateKeyword
    syn match cStructMember "\<\h\w*\>\%((\|<\)\@!" contained
    syn cluster cParenGroup add=cStructMember
    syn cluster cPreProcGroup add=cStructMember
    syn cluster cMultiGroup add=cStructMember
    ]])

	if vim.bo.filetype == "cpp" then
		vim.cmd([[
        syn keyword cppTemplateKeyword template
        hi def link cppTemplateKeyword cppStructure
        ]])
	end
end

-- 高亮结构体、联合体和枚举声明中的名称
if vim.g.cpp_type_name_highlight == 1 then
	vim.cmd([[
    syn match cTypeName "\%(\%(\<struct\|union\|enum\)\s\+\)\@8<=\h\w*"
    ]])

	if vim.bo.filetype == "cpp" then
		vim.cmd([[
        syn match cTypeName "\%(\%(\<class\|using\|concept\|requires\)\s\+\)\@10<=\h\w*"
        ]])
	end
end

-- 高亮运算符
if vim.g.cpp_operator_highlight == 1 then
	vim.cmd([[
    syn match cOperator "[?!~*&%<>^|=,+]"
    syn match cOperator "[][]"
    syn match cOperator "[^:]\@1<=:[^:]\@="
    syn match cOperator "-[^>]"me=e-1
    syn match cOperator "/[^/*]"me=e-1
    ]])
end

-- 高亮 ANSI 标准名称
vim.cmd([[
syn keyword cAnsiName
        \ PRId8 PRIi16 PRIo32 PRIu64 PRId16 PRIi32 PRIo64 PRIuLEAST8 PRId32 PRIi64 PRIoLEAST8 PRIuLEAST16 PRId64 PRIiLEAST8 PRIoLEAST16 PRIuLEAST32 PRIdLEAST8 PRIiLEAST16 PRIoLEAST32 PRIuLEAST64 PRIdLEAST16 PRIiLEAST32 PRIoLEAST64 PRIuFAST8 PRIdLEAST32 PRIiLEAST64 PRIoFAST8 PRIuFAST16 PRIdLEAST64 PRIiFAST8 PRIoFAST16 PRIuFAST32 PRIdFAST8 PRIiFAST16 PRIoFAST32 PRIuFAST64 PRIdFAST16 PRIiFAST32 PRIoFAST64 PRIuMAX PRIdFAST32 PRIiFAST64 PRIoMAX PRIuPTR PRIdFAST64 PRIiMAX PRIoPTR PRIx8 PRIdMAX PRIiPTR PRIu8 PRIx16 PRIdPTR PRIo8 PRIu16 PRIx32 PRIi8 PRIo16 PRIu32 PRIx64 PRIxLEAST8 SCNd8 SCNiFAST32 SCNuLEAST32 PRIxLEAST16 SCNd16 SCNiFAST64 SCNuLEAST64 PRIxLEAST32 SCNd32 SCNiMAX SCNuFAST8 PRIxLEAST64 SCNd64 SCNiPTR SCNuFAST16 PRIxFAST8 SCNdLEAST8 SCNo8 SCNuFAST32 PRIxFAST16 SCNdLEAST16 SCNo16 SCNuFAST64 PRIxFAST32 SCNdLEAST32 SCNo32 SCNuMAX PRIxFAST64 SCNdLEAST64 SCNo64 SCNuPTR PRIxMAX SCNdFAST8 SCNoLEAST8 SCNx8 PRIxPTR SCNdFAST16 SCNoLEAST16 SCNx16 PRIX8 SCNdFAST32 SCNoLEAST32 SCNx32 PRIX16 SCNdFAST64 SCNoLEAST64 SCNx64 PRIX32 SCNdMAX SCNoFAST8 SCNxLEAST8 PRIX64 SCNdPTR SCNoFAST16 SCNxLEAST64 PRIXLEAST8 SCNi8 SCNoFAST32 SCNxLEAST32 PRIXLEAST16 SCNi16 SCNoFAST64 SCNxLEAST64 PRIXLEAST32 SCNi32 SCNoMAX SCNxFAST8 PRIXLEAST64 SCNi64 SCNoPTR SCNxFAST16 PRIXFAST8 SCNiLEAST8 SCNu8 SCNxFAST32 PRIXFAST16 SCNiLEAST16 SCNu16 SCNxFAST64 PRIXFAST32 SCNiLEAST32 SCNu32 SCNxMAX PRIXFAST64 SCNiLEAST64 SCNu64 SCNxPTR PRIXMAX SCNiFAST8 SCNuLEAST8 PRIXPTR SCNiFAST16 SCNuLEAST16 STDC CX_LIMITED_RANGE STDC FENV_ACCESS STDC FP_CONTRACT
        \ errno environ and bitor not_eq xor and_eq compl or xor_eq bitand not or_eq
]])

-- 高亮布尔值
vim.cmd([[
syn keyword cBoolean true false TRUE FALSE
]])

-- 高亮所有标准 C 关键词为 Statement
if vim.g.cpp_simple_highlight == 1 then
	vim.cmd([[
    hi! def link cStorageClass Statement
    hi! def link cStructure    Statement
    hi! def link cTypedef      Statement
    hi! def link cLabel        Statement
    ]])
end
