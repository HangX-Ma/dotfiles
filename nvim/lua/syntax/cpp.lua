-- https://github.com/bfrg/vim-c-cpp-modern
-- C++ attributes

if vim.g.cpp_attributes_highlight == 0 then
	vim.api.nvim_command([[
        syntax region cppAttribute matchgroup=cppAttributeBrackets start="\[\[" end="\]\]" contains=cString
        hi def link cppAttribute Macro
        hi def link cppAttributeBrackets Identifier
    ]])
end

-- Standard library
local cppSTLdefine = {
	"MB_CUR_MAX",
	"MB_LEN_MAX",
	"WCHAR_MAX",
	"WCHAR_MIN",
	"WEOF",
	"__STDC_UTF_16__",
	"__STDC_UTF_32__",
}

local cppSTLnamespace = {
	"std",
	"experimental",
	"rel_ops",
}

local cppSTLconstant = {
	"badbit",
	"digits",
	"digits10",
	"eofbit",
	"failbit",
	"goodbit",
	"has_denorm",
	"has_denorm_loss",
	"has_infinity",
	"has_quiet_NaN",
	"has_signaling_NaN",
	"is_bounded",
	"is_exact",
	"is_iec559",
	"is_integer",
	"is_modulo",
	"is_signed",
	"is_specialized",
	"max_exponent",
	"max_exponent10",
	"min_exponent",
	"min_exponent10",
	"npos",
	"radix",
	"round_style",
	"tinyness_before",
	"traps",
}

local cppSTLvariable = {
	"cerr",
	"cin",
	"clog",
	"cout",
	"wcerr",
	"wcin",
	"wclog",
	"wcout",
	"nothrow",
}

local cppSTLexception = {
	"bad_alloc",
	"bad_exception",
	"bad_typeid",
	"bad_cast",
	"domain_error",
	"exception",
	"failure",
	"invalid_argument",
	"length_error",
	"logic_error",
	"out_of_range",
	"overflow_error",
	"range_error",
	"runtime_error",
	"underflow_error",
}

local cppSTLios = {
	"endl",
	"ends",
	"flush",
	"resetiosflags",
	"setbase",
	"setfill",
	"setiosflags",
	"setprecision",
	"setw",
	"ws",
	"boolalpha",
	"dec",
	"defaultfloat",
	"fixed",
	"hex",
	"hexfloat",
	"internal",
	"left",
	"noboolalpha",
	"noshowbase",
	"noshowpoint",
	"noshowpos",
	"noskipws",
	"nounitbuf",
	"nouppercase",
	"oct",
	"right",
	"scientific",
	"showbase",
	"showpoint",
	"showpos",
	"skipws",
	"unitbuf",
	"uppercase",
}

local cppSTLtype = {
	"fmtflags",
	"iostate",
	"openmode",
	"Init",
	"allocator",
	"auto_ptr",
	"basic_filebuf",
	"basic_fstream",
	"basic_ifstream",
	"basic_ios",
	"basic_iostream",
	"basic_istream",
	"basic_istringstream",
	"basic_ofstream",
	"basic_ostream",
	"basic_ostringstream",
	"basic_streambuf",
	"basic_string",
	"basic_stringbuf",
	"basic_stringstream",
	"binary_compose",
	"binder1st",
	"binder2nd",
	"bitset",
	"char_traits",
	"char_type",
	"const_mem_fun1_t",
	"const_mem_fun_ref1_t",
	"const_mem_fun_ref_t",
	"const_mem_fun_t",
	"const_pointer",
	"const_reference",
	"container_type",
	"deque",
	"difference_type",
	"div_t",
	"event_callback",
	"filebuf",
	"first_type",
	"float_denorm_style",
	"float_round_style",
	"fpos",
	"fstream",
	"gslice_array",
	"ifstream",
	"imaxdiv_t",
	"indirect_array",
	"int_type",
	"ios",
	"ios_base",
	"iostream",
	"istream",
	"istringstream",
	"istrstream",
	"iterator_category",
	"iterator_traits",
	"key_compare",
	"key_type",
	"ldiv_t",
	"list",
	"lldiv_t",
	"map",
	"mapped_type",
	"mask_array",
	"mbstate_t",
	"mem_fun1_t",
	"mem_fun_ref1_t",
	"mem_fun_ref_t",
	"mem_fun_t",
	"multimap",
	"multiset",
	"nothrow_t",
	"numeric_limits",
	"off_type",
	"ofstream",
	"ostream",
	"ostringstream",
	"ostrstream",
	"pair",
	"pointer",
	"pointer_to_binary_function",
	"pointer_to_unary_function",
	"pos_type",
	"priority_queue",
	"queue",
	"reference",
	"second_type",
	"seekdir",
	"sequence_buffer",
	"set",
	"size_type",
	"slice_array",
	"stack",
	"state_type",
	"stream",
	"streambuf",
	"streamoff",
	"streampos",
	"streamsize",
	"string",
	"stringbuf",
	"stringstream",
	"strstream",
	"strstreambuf",
	"temporary_buffer",
	"test_type",
	"tm",
	"traits_type",
	"type_info",
	"u16string",
	"u32string",
	"unary_compose",
	"unary_negate",
	"valarray",
	"value_compare",
	"value_type",
	"vector",
	"wfilebuf",
	"wfstream",
	"wifstream",
	"wios",
	"wiostream",
	"wistream",
	"wistringstream",
	"wofstream",
	"wostream",
	"wostringstream",
	"wstreambuf",
	"wstreampos",
	"wstring",
	"wstringbuf",
	"wstringstream",
	"codecvt",
	"codecvt_base",
	"codecvt_byname",
	"collate",
	"collate_byname",
	"ctype",
	"ctype_base",
	"ctype_byname",
	"locale",
	"messages",
	"messages_base",
	"messages_byname",
	"money_base",
	"money_get",
	"money_put",
	"moneypunct",
	"moneypunct_byname",
	"num_get",
	"num_put",
	"numpunct",
	"numpunct_byname",
	"time_base",
	"time_get",
	"time_get_byname",
	"time_put",
	"time_put_byname",
	"binary_function",
	"binary_negate",
	"bit_and",
	"bit_not",
	"bit_or",
	"divides",
	"equal_to",
	"greater",
	"greater_equal",
	"less",
	"less_equal",
	"logical_and",
	"logical_not",
	"logical_or",
	"minus",
	"modulus",
	"multiplies",
	"negate",
	"not_equal_to",
	"plus",
	"unary_function",
	"unary_negate",
	"bidirectional_iterator_tag",
	"forward_iterator_tag",
	"input_iterator_tag",
	"output_iterator_tag",
	"random_access_iterator_tag",
}

local cppSTLtypedef = {
	"time_t",
	"sig_atomic_t",
	"wctrans_t",
	"wctype_t",
	"wint_t",
}

local cppSTLiterator = {
	"back_insert_iterator",
	"bidirectional_iterator",
	"const_iterator",
	"const_reverse_iterator",
	"forward_iterator",
	"front_insert_iterator",
	"input_iterator",
	"insert_iterator",
	"istream_iterator",
	"istreambuf_iterator",
	"iterator",
	"ostream_iterator",
	"ostreambuf_iterator",
	"output_iterator",
	"random_access_iterator",
	"raw_storage_iterator",
	"reverse_bidirectional_iterator",
	"reverse_iterator",
}

local cppSTLfunction = {
	"use_facet",
	"has_facet",
	"get",
}

local cppSTLenum = {}

local cppSTLbool = {}

local cppSTLconcept = {}

-- C++11 extensions
if not vim.g.cpp_no_cpp11 then
	table.insert(cppSTLnamespace, "chrono")
	table.insert(cppSTLnamespace, "this_thread")

	table.insert(cppSTLtype, "array")
	table.insert(cppSTLtype, "atomic")
	table.insert(cppSTLtype, "atomic_bool")
	table.insert(cppSTLtype, "atomic_char")
	table.insert(cppSTLtype, "atomic_flag")
	table.insert(cppSTLtype, "atomic_int")
	table.insert(cppSTLtype, "atomic_llong")
	table.insert(cppSTLtype, "atomic_long")
	table.insert(cppSTLtype, "atomic_schar")
	table.insert(cppSTLtype, "atomic_short")
	table.insert(cppSTLtype, "atomic_uchar")
	table.insert(cppSTLtype, "atomic_uint")
	table.insert(cppSTLtype, "atomic_ullong")
	table.insert(cppSTLtype, "atomic_ulong")
	table.insert(cppSTLtype, "atomic_ushort")
	table.insert(cppSTLtype, "duration")
	table.insert(cppSTLtype, "duration_values")
	table.insert(cppSTLtype, "high_resolution_clock")
	table.insert(cppSTLtype, "hours")
	table.insert(cppSTLtype, "microseconds")
	table.insert(cppSTLtype, "milliseconds")
	table.insert(cppSTLtype, "minutes")
	table.insert(cppSTLtype, "nanoseconds")
	table.insert(cppSTLtype, "seconds")
	table.insert(cppSTLtype, "steady_clock")
	table.insert(cppSTLtype, "system_clock")
	table.insert(cppSTLtype, "time_point")
	table.insert(cppSTLtype, "treat_as_floating_point")
	table.insert(cppSTLtype, "condition_variable")
	table.insert(cppSTLtype, "exception_ptr")
	table.insert(cppSTLtype, "nested_exception")
	table.insert(cppSTLtype, "hash")
	table.insert(cppSTLtype, "is_bind_expression")
	table.insert(cppSTLtype, "is_placeholder")
	table.insert(cppSTLtype, "reference_wrapper")
	table.insert(cppSTLtype, "forward_list")
	table.insert(cppSTLtype, "future")
	table.insert(cppSTLtype, "packaged_task")
	table.insert(cppSTLtype, "promise")
	table.insert(cppSTLtype, "shared_future")
	table.insert(cppSTLtype, "initializer_list")
	table.insert(cppSTLtype, "codecvt_mode")
	table.insert(cppSTLtype, "codecvt_utf16")
	table.insert(cppSTLtype, "codecvt_utf8")
	table.insert(cppSTLtype, "codecvt_utf8_utf16")
	table.insert(cppSTLtype, "wbuffer_convert")
	table.insert(cppSTLtype, "wstring_convert")
	table.insert(cppSTLtype, "allocator_traits")
	table.insert(cppSTLtype, "allocator_type")
	table.insert(cppSTLtype, "default_delete")
	table.insert(cppSTLtype, "enable_shared_from_this")
	table.insert(cppSTLtype, "is_always_equal")
	table.insert(cppSTLtype, "owner_less")
	table.insert(cppSTLtype, "pointer_safety")
	table.insert(cppSTLtype, "pointer_traits")
	table.insert(cppSTLtype, "propagate_on_container_copy_assignment")
	table.insert(cppSTLtype, "propagate_on_container_move_assignment")
	table.insert(cppSTLtype, "propagate_on_container_swap")
	table.insert(cppSTLtype, "rebind_alloc")
	table.insert(cppSTLtype, "rebind_traits")
	table.insert(cppSTLtype, "shared_ptr")
	table.insert(cppSTLtype, "unique_ptr")
	table.insert(cppSTLtype, "uses_allocator")
	table.insert(cppSTLtype, "void_pointer")
	table.insert(cppSTLtype, "const_void_pointer")
	table.insert(cppSTLtype, "weak_ptr")
	table.insert(cppSTLtype, "condition_variable_any")
	table.insert(cppSTLtype, "lock_guard")
	table.insert(cppSTLtype, "mutex")
	table.insert(cppSTLtype, "once_flag")
	table.insert(cppSTLtype, "recursive_mutex")
	table.insert(cppSTLtype, "recursive_timed_mutex")
	table.insert(cppSTLtype, "timed_mutex")
	table.insert(cppSTLtype, "unique_lock")
	table.insert(cppSTLtype, "bernoulli_distribution")
	table.insert(cppSTLtype, "binomial_distribution")
	table.insert(cppSTLtype, "cauchy_distribution")
	table.insert(cppSTLtype, "chi_squared_distribution")
	table.insert(cppSTLtype, "default_random_engine")
	table.insert(cppSTLtype, "discard_block_engine")
	table.insert(cppSTLtype, "discrete_distribution")
	table.insert(cppSTLtype, "exponential_distribution")
	table.insert(cppSTLtype, "extreme_value_distribution")
	table.insert(cppSTLtype, "fisher_f_distribution")
	table.insert(cppSTLtype, "gamma_distribution")
	table.insert(cppSTLtype, "geometric_distribution")
	table.insert(cppSTLtype, "independent_bits_engine")
	table.insert(cppSTLtype, "knuth_b")
	table.insert(cppSTLtype, "linear_congruential_engine")
	table.insert(cppSTLtype, "lognormal_distribution")
	table.insert(cppSTLtype, "mersenne_twister_engine")
	table.insert(cppSTLtype, "minstd_rand")
	table.insert(cppSTLtype, "minstd_rand0")
	table.insert(cppSTLtype, "mt19937")
	table.insert(cppSTLtype, "mt19937_64")
	table.insert(cppSTLtype, "negative_binomial_distribution")
	table.insert(cppSTLtype, "normal_distribution")
	table.insert(cppSTLtype, "piecewise_constant_distribution")
	table.insert(cppSTLtype, "piecewise_linear_distribution")
	table.insert(cppSTLtype, "poisson_distribution")
	table.insert(cppSTLtype, "random_device")
	table.insert(cppSTLtype, "ranlux24")
	table.insert(cppSTLtype, "ranlux24_base")
	table.insert(cppSTLtype, "ranlux48")
	table.insert(cppSTLtype, "ranlux48_base")
	table.insert(cppSTLtype, "seed_seq")
	table.insert(cppSTLtype, "shuffle_order_engine")
	table.insert(cppSTLtype, "student_t_distribution")
	table.insert(cppSTLtype, "subtract_with_carry_engine")
	table.insert(cppSTLtype, "uniform_int_distribution")
	table.insert(cppSTLtype, "uniform_real_distribution")
	table.insert(cppSTLtype, "weibull_distribution")
	table.insert(cppSTLtype, "atto")
	table.insert(cppSTLtype, "centi")
	table.insert(cppSTLtype, "deca")
	table.insert(cppSTLtype, "deci")
	table.insert(cppSTLtype, "exa")
	table.insert(cppSTLtype, "femto")
	table.insert(cppSTLtype, "giga")
	table.insert(cppSTLtype, "hecto")
	table.insert(cppSTLtype, "kilo")
	table.insert(cppSTLtype, "mega")
	table.insert(cppSTLtype, "micro")
	table.insert(cppSTLtype, "milli")
	table.insert(cppSTLtype, "nano")
	table.insert(cppSTLtype, "peta")
	table.insert(cppSTLtype, "pico")
	table.insert(cppSTLtype, "ratio")
	table.insert(cppSTLtype, "ratio_add")
	table.insert(cppSTLtype, "ratio_divide")
	table.insert(cppSTLtype, "ratio_equal")
	table.insert(cppSTLtype, "ratio_greater")
	table.insert(cppSTLtype, "ratio_greater_equal")
	table.insert(cppSTLtype, "ratio_less")
	table.insert(cppSTLtype, "ratio_less_equal")
	table.insert(cppSTLtype, "ratio_multiply")
	table.insert(cppSTLtype, "ratio_not_equal")
	table.insert(cppSTLtype, "ratio_subtract")
	table.insert(cppSTLtype, "tera")
	table.insert(cppSTLtype, "yocto")
	table.insert(cppSTLtype, "yotta")
	table.insert(cppSTLtype, "zepto")
	table.insert(cppSTLtype, "zetta")
	table.insert(cppSTLtype, "basic_regex")
	table.insert(cppSTLtype, "regex")
	table.insert(cppSTLtype, "wregex")
	table.insert(cppSTLtype, "match_results")
	table.insert(cppSTLtype, "regex_traits")
	table.insert(cppSTLtype, "sub_match")
	table.insert(cppSTLtype, "syntax_option_type")
	table.insert(cppSTLtype, "match_flag_type")
	table.insert(cppSTLtype, "error_type")
	table.insert(cppSTLtype, "scoped_allocator_adaptor")
	table.insert(cppSTLtype, "outer_allocator_type")
	table.insert(cppSTLtype, "inner_allocator_type")
	table.insert(cppSTLtype, "error_code")
	table.insert(cppSTLtype, "error_condition")
	table.insert(cppSTLtype, "error_category")
	table.insert(cppSTLtype, "is_error_code_enum")
	table.insert(cppSTLtype, "is_error_condition_enum")
	table.insert(cppSTLtype, "thread")
	table.insert(cppSTLtype, "tuple")
	table.insert(cppSTLtype, "tuple_size")
	table.insert(cppSTLtype, "tuple_element")
	table.insert(cppSTLtype, "type_index")
	table.insert(cppSTLtype, "add_const")
	table.insert(cppSTLtype, "add_cv")
	table.insert(cppSTLtype, "add_lvalue_reference")
	table.insert(cppSTLtype, "add_pointer")
	table.insert(cppSTLtype, "add_rvalue_reference")
	table.insert(cppSTLtype, "add_volatile")
	table.insert(cppSTLtype, "aligned_storage")
	table.insert(cppSTLtype, "aligned_union")
	table.insert(cppSTLtype, "alignment_of")
	table.insert(cppSTLtype, "common_type")
	table.insert(cppSTLtype, "conditional")
	table.insert(cppSTLtype, "decay")
	table.insert(cppSTLtype, "enable_if")
	table.insert(cppSTLtype, "extent")
	table.insert(cppSTLtype, "false_type")
	table.insert(cppSTLtype, "has_virtual_destructor")
	table.insert(cppSTLtype, "integral_constant")
	table.insert(cppSTLtype, "is_abstract")
	table.insert(cppSTLtype, "is_arithmetic")
	table.insert(cppSTLtype, "is_array")
	table.insert(cppSTLtype, "is_assignable")
	table.insert(cppSTLtype, "is_base_of")
	table.insert(cppSTLtype, "is_class")
	table.insert(cppSTLtype, "is_compound")
	table.insert(cppSTLtype, "is_const")
	table.insert(cppSTLtype, "is_constructible")
	table.insert(cppSTLtype, "is_convertible")
	table.insert(cppSTLtype, "is_copy_assignable")
	table.insert(cppSTLtype, "is_copy_constructible")
	table.insert(cppSTLtype, "is_default_constructible")
	table.insert(cppSTLtype, "is_destructible")
	table.insert(cppSTLtype, "is_empty")
	table.insert(cppSTLtype, "is_enum")
	table.insert(cppSTLtype, "is_floating_point")
	table.insert(cppSTLtype, "is_function")
	table.insert(cppSTLtype, "is_fundamental")
	table.insert(cppSTLtype, "is_integral")
	table.insert(cppSTLtype, "is_invocable")
	table.insert(cppSTLtype, "is_invocable_r")
	table.insert(cppSTLtype, "is_literal_type")
	table.insert(cppSTLtype, "is_lvalue_reference")
	table.insert(cppSTLtype, "is_member_function_pointer")
	table.insert(cppSTLtype, "is_member_object_pointer")
	table.insert(cppSTLtype, "is_member_pointer")
	table.insert(cppSTLtype, "is_move_assignable")
	table.insert(cppSTLtype, "is_move_constructible")
	table.insert(cppSTLtype, "is_nothrow_assignable")
	table.insert(cppSTLtype, "is_nothrow_constructible")
	table.insert(cppSTLtype, "is_nothrow_copy_assignable")
	table.insert(cppSTLtype, "is_nothrow_copy_constructible")
	table.insert(cppSTLtype, "is_nothrow_default_constructible")
	table.insert(cppSTLtype, "is_nothrow_destructible")
	table.insert(cppSTLtype, "is_nothrow_invocable")
	table.insert(cppSTLtype, "is_nothrow_invocable_r")
	table.insert(cppSTLtype, "is_nothrow_move_assignable")
	table.insert(cppSTLtype, "is_nothrow_move_constructible")
	table.insert(cppSTLtype, "is_object")
	table.insert(cppSTLtype, "is_pod")
	table.insert(cppSTLtype, "is_pointer")
	table.insert(cppSTLtype, "is_polymorphic")
	table.insert(cppSTLtype, "is_reference")
	table.insert(cppSTLtype, "is_rvalue_reference")
	table.insert(cppSTLtype, "is_same")
	table.insert(cppSTLtype, "is_scalar")
	table.insert(cppSTLtype, "is_signed")
	table.insert(cppSTLtype, "is_standard_layout")
	table.insert(cppSTLtype, "is_trivial")
	table.insert(cppSTLtype, "is_trivially_assignable")
	table.insert(cppSTLtype, "is_trivially_constructible")
	table.insert(cppSTLtype, "is_trivially_copy_assignable")
	table.insert(cppSTLtype, "is_trivially_copy_constructible")
	table.insert(cppSTLtype, "is_trivially_copyable")
	table.insert(cppSTLtype, "is_trivially_default_constructible")
	table.insert(cppSTLtype, "is_trivially_destructible")
	table.insert(cppSTLtype, "is_trivially_move_assignable")
	table.insert(cppSTLtype, "is_trivially_move_constructible")
	table.insert(cppSTLtype, "is_union")
	table.insert(cppSTLtype, "is_unsigned")
	table.insert(cppSTLtype, "is_void")
	table.insert(cppSTLtype, "is_volatile")
	table.insert(cppSTLtype, "make_signed")
	table.insert(cppSTLtype, "make_unsigned")
	table.insert(cppSTLtype, "rank")
	table.insert(cppSTLtype, "remove_all_extents")
	table.insert(cppSTLtype, "remove_const")
	table.insert(cppSTLtype, "remove_cv")
	table.insert(cppSTLtype, "remove_extent")
	table.insert(cppSTLtype, "remove_pointer")
	table.insert(cppSTLtype, "remove_reference")
	table.insert(cppSTLtype, "remove_volatile")
	table.insert(cppSTLtype, "result_of")
	table.insert(cppSTLtype, "true_type")
	table.insert(cppSTLtype, "underlying_type")
	table.insert(cppSTLtype, "hasher")
	table.insert(cppSTLtype, "key_equal")
	table.insert(cppSTLtype, "unordered_map")
	table.insert(cppSTLtype, "unordered_multimap")
	table.insert(cppSTLtype, "unordered_multiset")
	table.insert(cppSTLtype, "unordered_set")
	table.insert(cppSTLtype, "function")

	table.insert(cppSTLtypedef, "atomic_char16_t")
	table.insert(cppSTLtypedef, "atomic_char32_t")
	table.insert(cppSTLtypedef, "atomic_int_fast16_t")
	table.insert(cppSTLtypedef, "atomic_int_fast32_t")
	table.insert(cppSTLtypedef, "atomic_int_fast64_t")
	table.insert(cppSTLtypedef, "atomic_int_fast8_t")
	table.insert(cppSTLtypedef, "atomic_int_least16_t")
	table.insert(cppSTLtypedef, "atomic_int_least32_t")
	table.insert(cppSTLtypedef, "atomic_int_least64_t")
	table.insert(cppSTLtypedef, "atomic_int_least8_t")
	table.insert(cppSTLtypedef, "atomic_intmax_t")
	table.insert(cppSTLtypedef, "atomic_intptr_t")
	table.insert(cppSTLtypedef, "atomic_ptrdiff_t")
	table.insert(cppSTLtypedef, "atomic_size_t")
	table.insert(cppSTLtypedef, "atomic_uint_fast16_t")
	table.insert(cppSTLtypedef, "atomic_uint_fast32_t")
	table.insert(cppSTLtypedef, "atomic_uint_fast64_t")
	table.insert(cppSTLtypedef, "atomic_uint_fast8_t")
	table.insert(cppSTLtypedef, "atomic_uint_least16_t")
	table.insert(cppSTLtypedef, "atomic_uint_least32_t")
	table.insert(cppSTLtypedef, "atomic_uint_least64_t")
	table.insert(cppSTLtypedef, "atomic_uint_least8_t")
	table.insert(cppSTLtypedef, "atomic_uintmax_t")
	table.insert(cppSTLtypedef, "atomic_uintptr_t")
	table.insert(cppSTLtypedef, "atomic_wchar_t")
	table.insert(cppSTLtypedef, "nullptr_t")
	table.insert(cppSTLtypedef, "max_align_t")
	table.insert(cppSTLtypedef, "allocator_arg_t")
	table.insert(cppSTLtypedef, "adopt_lock_t")
	table.insert(cppSTLtypedef, "defer_lock_t")
	table.insert(cppSTLtypedef, "try_to_lock_t")
	table.insert(cppSTLtypedef, "piecewise_construct_t")

	table.insert(cppSTLconstant, "max_digits10")

	table.insert(cppSTLvariable, "_1")
	table.insert(cppSTLvariable, "_2")
	table.insert(cppSTLvariable, "_3")
	table.insert(cppSTLvariable, "_4")
	table.insert(cppSTLvariable, "_5")
	table.insert(cppSTLvariable, "_6")
	table.insert(cppSTLvariable, "_7")
	table.insert(cppSTLvariable, "_8")
	table.insert(cppSTLvariable, "_9")
	table.insert(cppSTLvariable, "defer_lock")
	table.insert(cppSTLvariable, "try_to_lock")
	table.insert(cppSTLvariable, "adopt_lock")
	table.insert(cppSTLvariable, "allocator_arg")

	table.insert(cppSTLdefine, "math_errhandling")
	table.insert(cppSTLdefine, "FLT_EVAL_METHOD")
	table.insert(cppSTLdefine, "FP_INFINITE")
	table.insert(cppSTLdefine, "FP_NAN")
	table.insert(cppSTLdefine, "FP_NORMAL")
	table.insert(cppSTLdefine, "FP_SUBNORMAL")
	table.insert(cppSTLdefine, "FP_ZERO")
	table.insert(cppSTLdefine, "HUGE_VALF")
	table.insert(cppSTLdefine, "HUGE_VALL")
	table.insert(cppSTLdefine, "INFINITY")
	table.insert(cppSTLdefine, "MATH_ERREXCEPT")
	table.insert(cppSTLdefine, "MATH_ERRNO")
	table.insert(cppSTLdefine, "NAN")

	table.insert(cppSTLenum, "memory_order")
	table.insert(cppSTLenum, "future_status")
	table.insert(cppSTLenum, "future_errc")
	table.insert(cppSTLenum, "launch")
	table.insert(cppSTLenum, "io_errc")
	table.insert(cppSTLenum, "cv_status")
	table.insert(cppSTLenum, "errc")

	table.insert(cppSTLfunction, "duration_cast")
	table.insert(cppSTLfunction, "time_point_cast")
	table.insert(cppSTLfunction, "mem_fn")
	table.insert(cppSTLfunction, "const_pointer_cast")
	table.insert(cppSTLfunction, "dynamic_pointer_cast")
	table.insert(cppSTLfunction, "static_pointer_cast")
	table.insert(cppSTLfunction, "allocate_shared")
	table.insert(cppSTLfunction, "make_shared")
	table.insert(cppSTLfunction, "isblank")
	table.insert(cppSTLfunction, "generate_canonical")
	table.insert(cppSTLfunction, "forward_as_tuple")
	table.insert(cppSTLfunction, "make_tuple")
	table.insert(cppSTLfunction, "tie")
	table.insert(cppSTLfunction, "tuple_cat")
	table.insert(cppSTLfunction, "declval")
	table.insert(cppSTLfunction, "forward")
	table.insert(cppSTLfunction, "move")
	table.insert(cppSTLfunction, "move_if_noexcept")

	table.insert(cppSTLexception, "bad_function_call")
	table.insert(cppSTLexception, "future_error")
	table.insert(cppSTLexception, "regex_error")
	table.insert(cppSTLexception, "system_error")
	table.insert(cppSTLexception, "bad_weak_ptr")
	table.insert(cppSTLexception, "bad_array_new_length")

	table.insert(cppSTLiterator, "move_iterator")
	table.insert(cppSTLiterator, "regex_iterator")
	table.insert(cppSTLiterator, "regex_token_iterator")
	table.insert(cppSTLiterator, "const_local_iterator")
	table.insert(cppSTLiterator, "local_iterator")

	table.insert(cppSTLvariable, "ignore")
end

-- C++14 extensions
if not vim.g.cpp_no_cpp14 then
	table.insert(cppSTLnamespace, "literals")
	table.insert(cppSTLnamespace, "chrono_literals")
	table.insert(cppSTLnamespace, "string_literals")
	table.insert(cppSTLnamespace, "complex_literals")

	table.insert(cppSTLfunction, "make_unique")

	table.insert(cppSTLtype, "index_sequence")
	table.insert(cppSTLtype, "index_sequence_for")
	table.insert(cppSTLtype, "integer_sequence")
	table.insert(cppSTLtype, "make_index_sequence")
	table.insert(cppSTLtype, "make_integer_sequence")
	table.insert(cppSTLtype, "shared_lock")
	table.insert(cppSTLtype, "shared_timed_mutex")
	table.insert(cppSTLtype, "is_final")
	table.insert(cppSTLtype, "is_null_pointer")

	table.insert(cppSTLtypedef, "tuple_element_t")
	table.insert(cppSTLtypedef, "add_const_t")
	table.insert(cppSTLtypedef, "add_cv_t")
	table.insert(cppSTLtypedef, "add_lvalue_reference_t")
	table.insert(cppSTLtypedef, "add_pointer_t")
	table.insert(cppSTLtypedef, "add_rvalue_reference_t")
	table.insert(cppSTLtypedef, "add_volatile_t")
	table.insert(cppSTLtypedef, "aligned_storage_t")
	table.insert(cppSTLtypedef, "aligned_union_t")
	table.insert(cppSTLtypedef, "common_type_t")
	table.insert(cppSTLtypedef, "conditional_t")
	table.insert(cppSTLtypedef, "decay_t")
	table.insert(cppSTLtypedef, "enable_if_t")
	table.insert(cppSTLtypedef, "make_signed_t")
	table.insert(cppSTLtypedef, "make_unsigned_t")
	table.insert(cppSTLtypedef, "remove_all_extents_t")
	table.insert(cppSTLtypedef, "remove_const_t")
	table.insert(cppSTLtypedef, "remove_cv_t")
	table.insert(cppSTLtypedef, "remove_extent_t")
	table.insert(cppSTLtypedef, "remove_pointer_t")
	table.insert(cppSTLtypedef, "remove_reference_t")
	table.insert(cppSTLtypedef, "remove_volatile_t")
	table.insert(cppSTLtypedef, "result_of_t")
	table.insert(cppSTLtypedef, "underlying_type_t")
end

-- C++17 extensions
if not vim.g.cpp_no_cpp17 then
	table.insert(cppSTLnamespace, "filesystem")
	table.insert(cppSTLnamespace, "execution")
	table.insert(cppSTLnamespace, "string_view_literals")

	table.insert(cppSTLtype, "any")
	table.insert(cppSTLtype, "byte")
	table.insert(cppSTLtype, "is_execution_policy")
	table.insert(cppSTLtype, "parallel_policy")
	table.insert(cppSTLtype, "parallel_unsequenced_policy")
	table.insert(cppSTLtype, "sequenced_policy")
	table.insert(cppSTLtype, "directory_entry")
	table.insert(cppSTLtype, "directory_iterator")
	table.insert(cppSTLtype, "file_status")
	table.insert(cppSTLtype, "file_time_type")
	table.insert(cppSTLtype, "path")
	table.insert(cppSTLtype, "recursive_directory_iterator")
	table.insert(cppSTLtype, "space_info")
	table.insert(cppSTLtype, "default_order")
	table.insert(cppSTLtype, "default_searcher")
	table.insert(cppSTLtype, "boyer_moore_searcher")
	table.insert(cppSTLtype, "boyer_moore_horspool_searcher")
	table.insert(cppSTLtype, "memory_resource")
	table.insert(cppSTLtype, "monotonic_buffer_resource")
	table.insert(cppSTLtype, "polymorphic_allocator")
	table.insert(cppSTLtype, "pool_options")
	table.insert(cppSTLtype, "synchronized_pool_resource")
	table.insert(cppSTLtype, "unsynchronized_pool_resource")
	table.insert(cppSTLtype, "scoped_lock")
	table.insert(cppSTLtype, "optional")
	table.insert(cppSTLtype, "shared_mutex")
	table.insert(cppSTLtype, "basic_string_view")
	table.insert(cppSTLtype, "string_view")
	table.insert(cppSTLtype, "u16string_view")
	table.insert(cppSTLtype, "u32string_view")
	table.insert(cppSTLtype, "wstring_view")
	table.insert(cppSTLtype, "bool_constant")
	table.insert(cppSTLtype, "conjunction")
	table.insert(cppSTLtype, "disjunction")
	table.insert(cppSTLtype, "has_unique_object_representations")
	table.insert(cppSTLtype, "invoke_result")
	table.insert(cppSTLtype, "is_aggregate")
	table.insert(cppSTLtype, "is_callable")
	table.insert(cppSTLtype, "is_invocable")
	table.insert(cppSTLtype, "is_invocable_r")
	table.insert(cppSTLtype, "is_nothrow_invocable")
	table.insert(cppSTLtype, "is_nothrow_invocable_r")
	table.insert(cppSTLtype, "is_nothrow_swappable")
	table.insert(cppSTLtype, "is_nothrow_swappable_with")
	table.insert(cppSTLtype, "is_nowthrow_callable")
	table.insert(cppSTLtype, "is_swappable")
	table.insert(cppSTLtype, "is_swappable_with")
	table.insert(cppSTLtype, "negation")
	table.insert(cppSTLtype, "node_type")
	table.insert(cppSTLtype, "insert_return_type")
	table.insert(cppSTLtype, "in_place_tag")
	table.insert(cppSTLtype, "monostate")
	table.insert(cppSTLtype, "variant")
	table.insert(cppSTLtype, "variant_size")
	table.insert(cppSTLtype, "variant_alternative")
	table.insert(cppSTLtype, "from_chars_result")
	table.insert(cppSTLtype, "to_chars_result")
	table.insert(cppSTLtype, "chars_format")

	table.insert(cppSTLtypedef, "invoke_result_t")
	table.insert(cppSTLtypedef, "default_order_t")
	table.insert(cppSTLtypedef, "nullopt_t")
	table.insert(cppSTLtypedef, "void_t")
	table.insert(cppSTLtypedef, "in_place_t")
	table.insert(cppSTLtypedef, "in_place_type_t")
	table.insert(cppSTLtypedef, "in_place_index_t")
	table.insert(cppSTLtypedef, "variant_alternative_t")

	table.insert(cppSTLexception, "bad_any_cast")
	table.insert(cppSTLexception, "filesystem_error")
	table.insert(cppSTLexception, "bad_optional_access")
	table.insert(cppSTLexception, "bad_variant_access")

	table.insert(cppSTLconstant, "is_always_lock_free")
	table.insert(cppSTLconstant, "seq")
	table.insert(cppSTLconstant, "par")
	table.insert(cppSTLconstant, "par_unseq")
	table.insert(cppSTLconstant, "copy_symlinks")
	table.insert(cppSTLconstant, "auto_format")
	table.insert(cppSTLconstant, "create_hard_links")
	table.insert(cppSTLconstant, "create_symlinks")
	table.insert(cppSTLconstant, "directories_only")
	table.insert(cppSTLconstant, "follow_directory_symlink")
	table.insert(cppSTLconstant, "generic_format")
	table.insert(cppSTLconstant, "group_all")
	table.insert(cppSTLconstant, "group_exec")
	table.insert(cppSTLconstant, "group_read")
	table.insert(cppSTLconstant, "group_write")
	table.insert(cppSTLconstant, "native_format")
	table.insert(cppSTLconstant, "others_all")
	table.insert(cppSTLconstant, "others_exec")
	table.insert(cppSTLconstant, "others_read")
	table.insert(cppSTLconstant, "others_write")
	table.insert(cppSTLconstant, "overwrite_existing")
	table.insert(cppSTLconstant, "owner_all")
	table.insert(cppSTLconstant, "owner_exec")
	table.insert(cppSTLconstant, "owner_read")
	table.insert(cppSTLconstant, "owner_write")
	table.insert(cppSTLconstant, "preferred_separator")
	table.insert(cppSTLconstant, "recursive")
	table.insert(cppSTLconstant, "set_gid")
	table.insert(cppSTLconstant, "set_uid")
	table.insert(cppSTLconstant, "skip_existing")
	table.insert(cppSTLconstant, "skip_permission_denied")
	table.insert(cppSTLconstant, "skip_symlinks")
	table.insert(cppSTLconstant, "sticky_bit")
	table.insert(cppSTLconstant, "update_existing")
	table.insert(cppSTLconstant, "hardware_destructive_interference_size")
	table.insert(cppSTLconstant, "hardware_constructive_interference_size")
	table.insert(cppSTLconstant, "tuple_size_v")
	table.insert(cppSTLconstant, "nullopt")
	table.insert(cppSTLconstant, "alignment_of_v")
	table.insert(cppSTLconstant, "rank_v")
	table.insert(cppSTLconstant, "extent_v")
	table.insert(cppSTLconstant, "variant_npos")
	table.insert(cppSTLconstant, "variant_size_v")

	table.insert(cppSTLbool, "treat_as_floating_point_v")
	table.insert(cppSTLbool, "is_execution_policy_v")
	table.insert(cppSTLbool, "is_bind_expression_v")
	table.insert(cppSTLbool, "is_placeholder_v")
	table.insert(cppSTLbool, "is_error_code_enum_v")
	table.insert(cppSTLbool, "is_error_condition_enum_v")
	table.insert(cppSTLbool, "uses_allocator_v")
	table.insert(cppSTLbool, "conjunction_v")
	table.insert(cppSTLbool, "disjunction_v")
	table.insert(cppSTLbool, "has_unique_object_representations_v")
	table.insert(cppSTLbool, "has_virtual_destructor_v")
	table.insert(cppSTLbool, "is_abstract_v")
	table.insert(cppSTLbool, "is_aggregate_v")
	table.insert(cppSTLbool, "is_arithmetic_v")
	table.insert(cppSTLbool, "is_array_v")
	table.insert(cppSTLbool, "is_assignable_v")
	table.insert(cppSTLbool, "is_base_of_v")
	table.insert(cppSTLbool, "is_callable_v")
	table.insert(cppSTLbool, "is_class_v")
	table.insert(cppSTLbool, "is_compound_v")
	table.insert(cppSTLbool, "is_const_v")
	table.insert(cppSTLbool, "is_constructible_v")
	table.insert(cppSTLbool, "is_convertible_v")
	table.insert(cppSTLbool, "is_copy_assignable_v")
	table.insert(cppSTLbool, "is_copy_constructible_v")
	table.insert(cppSTLbool, "is_default_constructible_v")
	table.insert(cppSTLbool, "is_destructible_v")
	table.insert(cppSTLbool, "is_empty_v")
	table.insert(cppSTLbool, "is_enum_v")
	table.insert(cppSTLbool, "is_final_v")
	table.insert(cppSTLbool, "is_floating_point_v")
	table.insert(cppSTLbool, "is_function_v")
	table.insert(cppSTLbool, "is_fundamental_v")
	table.insert(cppSTLbool, "is_integral_v")
	table.insert(cppSTLbool, "is_invocable_r_v")
	table.insert(cppSTLbool, "is_invocable_v")
	table.insert(cppSTLbool, "is_literal_type_v")
	table.insert(cppSTLbool, "is_lvalue_reference_v")
	table.insert(cppSTLbool, "is_member_function_pointer_v")
	table.insert(cppSTLbool, "is_member_object_pointer_v")
	table.insert(cppSTLbool, "is_member_pointer_v")
	table.insert(cppSTLbool, "is_move_assignable_v")
	table.insert(cppSTLbool, "is_move_constructible_v")
	table.insert(cppSTLbool, "is_nothrow_assignable_v")
	table.insert(cppSTLbool, "is_nothrow_constructible_v")
	table.insert(cppSTLbool, "is_nothrow_copy_assignable_v")
	table.insert(cppSTLbool, "is_nothrow_copy_constructible_v")
	table.insert(cppSTLbool, "is_nothrow_default_constructible_v")
	table.insert(cppSTLbool, "is_nothrow_destructible_v")
	table.insert(cppSTLbool, "is_nothrow_invocable_r_v")
	table.insert(cppSTLbool, "is_nothrow_invocable_v")
	table.insert(cppSTLbool, "is_nothrow_move_assignable_v")
	table.insert(cppSTLbool, "is_nothrow_move_constructible_v")
	table.insert(cppSTLbool, "is_nothrow_swappable_v")
	table.insert(cppSTLbool, "is_nothrow_swappable_with_v")
	table.insert(cppSTLbool, "is_nowthrow_callable_v")
	table.insert(cppSTLbool, "is_null_pointer_v")
	table.insert(cppSTLbool, "is_object_v")
	table.insert(cppSTLbool, "is_pod_v")
	table.insert(cppSTLbool, "is_pointer_v")
	table.insert(cppSTLbool, "is_polymorphic_v")
	table.insert(cppSTLbool, "is_reference_v")
	table.insert(cppSTLbool, "is_rvalue_reference_v")
	table.insert(cppSTLbool, "is_same_v")
	table.insert(cppSTLbool, "is_scalar_v")
	table.insert(cppSTLbool, "is_signed_v")
	table.insert(cppSTLbool, "is_standard_layout_v")
	table.insert(cppSTLbool, "is_swappable_v")
	table.insert(cppSTLbool, "is_swappable_with_v")
	table.insert(cppSTLbool, "is_trivial_v")
	table.insert(cppSTLbool, "is_trivially_assignable_v")
	table.insert(cppSTLbool, "is_trivially_constructible_v")
	table.insert(cppSTLbool, "is_trivially_copy_assignable_v")
	table.insert(cppSTLbool, "is_trivially_copy_constructible_v")
	table.insert(cppSTLbool, "is_trivially_copyable_v")
	table.insert(cppSTLbool, "is_trivially_default_constructible_v")
	table.insert(cppSTLbool, "is_trivially_destructible_v")
	table.insert(cppSTLbool, "is_trivially_move_assignable_v")
	table.insert(cppSTLbool, "is_trivially_move_constructible_v")
	table.insert(cppSTLbool, "is_union_v")
	table.insert(cppSTLbool, "is_unsigned_v")
	table.insert(cppSTLbool, "is_void_v")
	table.insert(cppSTLbool, "is_volatile_v")
	table.insert(cppSTLbool, "negation_v")

	table.insert(cppSTLfunction, "duration_cast")
	table.insert(cppSTLfunction, "time_point_cast")
	table.insert(cppSTLfunction, "mem_fn")
	table.insert(cppSTLfunction, "const_pointer_cast")
	table.insert(cppSTLfunction, "dynamic_pointer_cast")
	table.insert(cppSTLfunction, "static_pointer_cast")
	table.insert(cppSTLfunction, "allocate_shared")
	table.insert(cppSTLfunction, "make_shared")
	table.insert(cppSTLfunction, "isblank")
	table.insert(cppSTLfunction, "generate_canonical")
	table.insert(cppSTLfunction, "forward_as_tuple")
	table.insert(cppSTLfunction, "make_tuple")
	table.insert(cppSTLfunction, "tie")
	table.insert(cppSTLfunction, "tuple_cat")
	table.insert(cppSTLfunction, "declval")
	table.insert(cppSTLfunction, "forward")
	table.insert(cppSTLfunction, "move")
	table.insert(cppSTLfunction, "move_if_noexcept")
	table.insert(cppSTLfunction, "reinterpret_pointer_cast")
	table.insert(cppSTLfunction, "make_from_tuple")
	table.insert(cppSTLfunction, "make_optional")
	table.insert(cppSTLfunction, "any_cast")

	table.insert(cppSTLenum, "copy_options")
	table.insert(cppSTLenum, "directory_options")
	table.insert(cppSTLenum, "file_type")
	table.insert(cppSTLenum, "perm_options")
	table.insert(cppSTLenum, "perms")

	table.insert(cppSTLvariable, "capacity")
	table.insert(cppSTLvariable, "free")
	table.insert(cppSTLvariable, "available")

	table.insert(cppSTLconstant, "all")
	table.insert(cppSTLconstant, "mask")
	table.insert(cppSTLconstant, "unknown")
	table.insert(cppSTLconstant, "replace")
	table.insert(cppSTLconstant, "add")
	table.insert(cppSTLconstant, "remove")
	table.insert(cppSTLconstant, "nofollow")
	table.insert(cppSTLconstant, "none")
	table.insert(cppSTLconstant, "not_found")
	table.insert(cppSTLconstant, "regular")
	table.insert(cppSTLconstant, "directory")
	table.insert(cppSTLconstant, "symlink")
	table.insert(cppSTLconstant, "block")
	table.insert(cppSTLconstant, "character")
	table.insert(cppSTLconstant, "fifo")
	table.insert(cppSTLconstant, "socket")
	table.insert(cppSTLconstant, "unknown")
end

-- C++20 extensions
if not vim.g.cpp_no_cpp20 then
	table.insert(cppSTLnamespace, "ranges")
	table.insert(cppSTLnamespace, "views")

	table.insert(cppSTLconstant, "dynamic_extent")

	table.insert(cppSTLvariable, "default_sentinel")
	table.insert(cppSTLvariable, "unreachable_sentinel")

	table.insert(cppSTLexception, "format_error")

	table.insert(cppSTLtype, "atomic_ref")
	table.insert(cppSTLtype, "endian")
	table.insert(cppSTLtype, "weak_ordering")
	table.insert(cppSTLtype, "strong_ordering")
	table.insert(cppSTLtype, "partial_ordering")
	table.insert(cppSTLtype, "weak_equality")
	table.insert(cppSTLtype, "strong_equality")
	table.insert(cppSTLtype, "common_comparison_category")
	table.insert(cppSTLtype, "contract_violation")
	table.insert(cppSTLtype, "coroutine_traits")
	table.insert(cppSTLtype, "coroutine_handle")
	table.insert(cppSTLtype, "noop_coroutine_handle")
	table.insert(cppSTLtype, "noop_coroutine_promise")
	table.insert(cppSTLtype, "suspend_never")
	table.insert(cppSTLtype, "suspend_always")
	table.insert(cppSTLtype, "remove_cvref")
	table.insert(cppSTLtype, "is_bounded_array")
	table.insert(cppSTLtype, "is_layout_compatible")
	table.insert(cppSTLtype, "is_unbounded_array")
	table.insert(cppSTLtype, "is_nothrow_convertible")
	table.insert(cppSTLtype, "has_strong_structural_equality")
	table.insert(cppSTLtype, "is_pointer_interconvertible_base_of")
	table.insert(cppSTLtype, "unwrap_reference")
	table.insert(cppSTLtype, "unwrap_ref_decay")
	table.insert(cppSTLtype, "basic_common_reference")
	table.insert(cppSTLtype, "common_reference")
	table.insert(cppSTLtype, "dangling")
	table.insert(cppSTLtype, "ref_view")
	table.insert(cppSTLtype, "filter_view")
	table.insert(cppSTLtype, "transform_view")
	table.insert(cppSTLtype, "iota_view")
	table.insert(cppSTLtype, "join_view")
	table.insert(cppSTLtype, "empty_view")
	table.insert(cppSTLtype, "single_view")
	table.insert(cppSTLtype, "split_view")
	table.insert(cppSTLtype, "common_view")
	table.insert(cppSTLtype, "reverse_view")
	table.insert(cppSTLtype, "view_interface")
	table.insert(cppSTLtype, "span")
	table.insert(cppSTLtype, "basic_syncbuf")
	table.insert(cppSTLtype, "basic_osyncstream")
	table.insert(cppSTLtype, "syncbuf")
	table.insert(cppSTLtype, "wsyncbuf")
	table.insert(cppSTLtype, "osyncstream")
	table.insert(cppSTLtype, "wosyncstream")
	table.insert(cppSTLtype, "jthread")
	table.insert(cppSTLtype, "latch")
	table.insert(cppSTLtype, "barrier")
	table.insert(cppSTLtype, "stop_token")
	table.insert(cppSTLtype, "stop_source")
	table.insert(cppSTLtype, "stop_callback")
	table.insert(cppSTLtype, "counting_semaphore")
	table.insert(cppSTLtype, "binary_semaphore")
	table.insert(cppSTLtype, "source_location")
	table.insert(cppSTLtype, "compare_three_way_result")
	table.insert(cppSTLtype, "contiguous_iterator_tag")
	table.insert(cppSTLtype, "incrementable_traits")
	table.insert(cppSTLtype, "indirectly_readable_traits")
	table.insert(cppSTLtype, "move_sentinel")
	table.insert(cppSTLtype, "common_iterator")
	table.insert(cppSTLtype, "counted_iterator")
	table.insert(cppSTLtype, "projected")
	table.insert(cppSTLtype, "type_identity")
	table.insert(cppSTLtype, "formatter")
	table.insert(cppSTLtype, "basic_format_context")
	table.insert(cppSTLtype, "basic_format_args")
	table.insert(cppSTLtype, "basic_format_string")
	table.insert(cppSTLtype, "basic_format_parse_context")

	table.insert(cppSTLtypedef, "common_comparison_category_t")
	table.insert(cppSTLtypedef, "remove_cvref_t")
	table.insert(cppSTLtypedef, "unwrap_reference_t")
	table.insert(cppSTLtypedef, "unwrap_ref_decay_t")
	table.insert(cppSTLtypedef, "common_reference_t")
	table.insert(cppSTLtypedef, "iterator_t")
	table.insert(cppSTLtypedef, "sentinel_t")
	table.insert(cppSTLtypedef, "safe_iterator_t")
	table.insert(cppSTLtypedef, "safe_subrange_t")
	table.insert(cppSTLtypedef, "compare_three_way_result_t")
	table.insert(cppSTLtypedef, "iter_value_t")
	table.insert(cppSTLtypedef, "iter_reference_t")
	table.insert(cppSTLtypedef, "iter_difference_t")
	table.insert(cppSTLtypedef, "iter_rvalue_reference_t")
	table.insert(cppSTLtypedef, "iter_common_reference_t")
	table.insert(cppSTLtypedef, "default_sentinel_t")
	table.insert(cppSTLtypedef, "unreachable_sentinel_t")
	table.insert(cppSTLtypedef, "indirect_result_t")
	table.insert(cppSTLtypedef, "type_identity_t")
	table.insert(cppSTLtypedef, "format_context")
	table.insert(cppSTLtypedef, "wformat_context")
	table.insert(cppSTLtypedef, "format_args")
	table.insert(cppSTLtypedef, "wformat_args")
	table.insert(cppSTLtypedef, "format_string")
	table.insert(cppSTLtypedef, "wformat_string")
	table.insert(cppSTLtypedef, "format_parse_context")
	table.insert(cppSTLtypedef, "wformat_parse_context")

	table.insert(cppSTLfunction, "make_unique_default_init")
	table.insert(cppSTLfunction, "make_shared_default_init")
	table.insert(cppSTLfunction, "allocate_shared_default_init")
	table.insert(cppSTLfunction, "uses_allocator_construction_args")
	table.insert(cppSTLfunction, "make_obj_using_allocator")
	table.insert(cppSTLfunction, "is_corresponding_member")
	table.insert(cppSTLfunction, "subspan")
	table.insert(cppSTLfunction, "in_range")
	table.insert(cppSTLfunction, "is_pointer_interconvertible_with_class")

	table.insert(cppSTLbool, "is_bounded_array_v")
	table.insert(cppSTLbool, "is_layout_compatible_v")
	table.insert(cppSTLbool, "is_unbounded_array_v")
	table.insert(cppSTLbool, "is_nothrow_convertible_v")
	table.insert(cppSTLbool, "has_strong_structural_equality_v")
	table.insert(cppSTLbool, "is_pointer_interconvertible_base_of_v")
	table.insert(cppSTLbool, "disable_sized_sentinel_for")
	table.insert(cppSTLbool, "disable_sized_range")
	table.insert(cppSTLbool, "enable_borrowed_range")
	table.insert(cppSTLbool, "enable_view")

	table.insert(cppSTLconcept, "assignable_from")
	table.insert(cppSTLconcept, "boolean")
	table.insert(cppSTLconcept, "common_reference_with")
	table.insert(cppSTLconcept, "common_with")
	table.insert(cppSTLconcept, "constructible_from")
	table.insert(cppSTLconcept, "convertible_to")
	table.insert(cppSTLconcept, "copy_constructible")
	table.insert(cppSTLconcept, "copyable")
	table.insert(cppSTLconcept, "default_constructible")
	table.insert(cppSTLconcept, "derived_from")
	table.insert(cppSTLconcept, "destructible")
	table.insert(cppSTLconcept, "equality_comparable")
	table.insert(cppSTLconcept, "equality_comparable_with")
	table.insert(cppSTLconcept, "equivalence_relation")
	table.insert(cppSTLconcept, "floating_point")
	table.insert(cppSTLconcept, "integral")
	table.insert(cppSTLconcept, "invocable")
	table.insert(cppSTLconcept, "movable")
	table.insert(cppSTLconcept, "move_constructible")
	table.insert(cppSTLconcept, "predicate")
	table.insert(cppSTLconcept, "regular")
	table.insert(cppSTLconcept, "regular_invocable")
	table.insert(cppSTLconcept, "relation")
	table.insert(cppSTLconcept, "same_as")
	table.insert(cppSTLconcept, "semiregular")
	table.insert(cppSTLconcept, "signed_integral")
	table.insert(cppSTLconcept, "strict_weak_order")
	table.insert(cppSTLconcept, "swappable")
	table.insert(cppSTLconcept, "swappable_with")
	table.insert(cppSTLconcept, "totally_ordered")
	table.insert(cppSTLconcept, "totally_ordered_with")
	table.insert(cppSTLconcept, "unsigned_integral")
	table.insert(cppSTLconcept, "default_initializable")
	table.insert(cppSTLconcept, "range")
	table.insert(cppSTLconcept, "sized_range")
	table.insert(cppSTLconcept, "view")
	table.insert(cppSTLconcept, "input_range")
	table.insert(cppSTLconcept, "output_range")
	table.insert(cppSTLconcept, "forward_range")
	table.insert(cppSTLconcept, "bidirectional_range")
	table.insert(cppSTLconcept, "random_access_range")
	table.insert(cppSTLconcept, "contiguous_range")
	table.insert(cppSTLconcept, "common_range")
	table.insert(cppSTLconcept, "viewable_range")
	table.insert(cppSTLconcept, "three_way_comparable")
	table.insert(cppSTLconcept, "three_way_comparable_with")
	table.insert(cppSTLconcept, "indirectly_readable")
	table.insert(cppSTLconcept, "indirectly_writable")
	table.insert(cppSTLconcept, "weakly_incrementable")
	table.insert(cppSTLconcept, "incrementable")
	table.insert(cppSTLconcept, "input_or_output_iterator")
	table.insert(cppSTLconcept, "sentinel_for")
	table.insert(cppSTLconcept, "sized_sentinel_for")
	table.insert(cppSTLconcept, "input_iterator")
	table.insert(cppSTLconcept, "output_iterator")
	table.insert(cppSTLconcept, "forward_iterator")
	table.insert(cppSTLconcept, "bidirectional_iterator")
	table.insert(cppSTLconcept, "random_access_iterator")
	table.insert(cppSTLconcept, "contiguous_iterator")
	table.insert(cppSTLconcept, "indirectly_unary_invocable")
	table.insert(cppSTLconcept, "indirectly_regular_unary_invocable")
	table.insert(cppSTLconcept, "indirect_unary_predicate")
	table.insert(cppSTLconcept, "indirect_binary_predicate")
	table.insert(cppSTLconcept, "indirect_equivalence_relation")
	table.insert(cppSTLconcept, "indirect_strict_weak_order")
	table.insert(cppSTLconcept, "indirectly_movable")
	table.insert(cppSTLconcept, "indirectly_movable_storable")
	table.insert(cppSTLconcept, "indirectly_copyable")
	table.insert(cppSTLconcept, "indirectly_copyable_storable")
	table.insert(cppSTLconcept, "indirectly_swappable")
	table.insert(cppSTLconcept, "indirectly_comparable")
	table.insert(cppSTLconcept, "permutable")
	table.insert(cppSTLconcept, "mergeable")
	table.insert(cppSTLconcept, "sortable")
end

-- C++23 extensions
if not vim.g.cpp_no_cpp23 then
	table.insert(cppSTLtype, "basic_stacktrace")
	table.insert(cppSTLtype, "stacktrace_entry")
	table.insert(cppSTLtype, "is_scoped_enum")
	table.insert(cppSTLtype, "mdspan")
	table.insert(cppSTLtype, "extents")
	table.insert(cppSTLtype, "default_accessor")
	table.insert(cppSTLtype, "layout_left")
	table.insert(cppSTLtype, "layout_right")
	table.insert(cppSTLtype, "layout_stride")
	table.insert(cppSTLtype, "flat_set")
	table.insert(cppSTLtype, "flat_map")
	table.insert(cppSTLtype, "flat_multiset")
	table.insert(cppSTLtype, "flat_multimap")
	table.insert(cppSTLtype, "is_implicit_lifetime")
	table.insert(cppSTLtype, "reference_constructs_from_temporary")
	table.insert(cppSTLtype, "reference_converts_from_temporary")

	table.insert(cppSTLtypedef, "stacktrace")
	table.insert(cppSTLtypedef, "dextents")

	table.insert(cppSTLbool, "is_implicit_lifetime_v")
	table.insert(cppSTLbool, "is_scoped_enum_v")
	table.insert(cppSTLbool, "reference_constructs_from_temporary_v")
	table.insert(cppSTLbool, "reference_converts_from_temporary_v")

	table.insert(cppSTLfunction, "invoke_r")

	table.insert(cppSTLtype, "expected")
	table.insert(cppSTLtype, "unexpected")
	table.insert(cppSTLtype, "unexpect_t")
	table.insert(cppSTLtype, "bad_expected_access")

	table.insert(cppSTLvariable, "unexpect")
end

-- Boost
if not vim.g.cpp_no_boost then
	table.insert(cppSTLnamespace, "boost")
	table.insert(cppSTLfunction, "lexical_cast")
end

-- Default highlighting
vim.api.nvim_command([[
    hi def link cppSTLbool Boolean
    hi def link cppStatement Statement
    hi def link cppSTLfunction Function
    hi def link cppSTLdefine Constant
    hi def link cppSTLconstant Constant
    hi def link cppSTLnamespace Constant
    hi def link cppSTLexception Type
    hi def link cppSTLiterator Type
    hi def link cppSTLtype Type
    hi def link cppSTLtypedef Typedef
    hi def link cppSTLenum Typedef
    hi def link cppSTLios Function
    hi def link cppSTLconcept Typedef
    hi def link cppSTLvariable Identifier
    hi! def link cppModifier Statement
]])

-- Highlight all standard C++ keywords as Statement
if vim.g.cpp_simple_highlight then
	vim.api.nvim_command([[
        hi! def link cppStructure Statement
        hi! def link cppExceptions Statement
        hi! def link cppStorageClass Statement
    ]])
end
