*! version 0.1.1 26jun2026
program define _srlb_assert_r_name, rclass
    version 14.1
    args name optname

    if `"`macval(optname)'"' == "" local optname "name"

    if `"`macval(name)'"' == "" {
        di as err "empty R object name in `optname'()"
        exit 198
    }

    if !regexm(`"`macval(name)'"', "^[A-Za-z.][A-Za-z0-9._]*$") | regexm(`"`macval(name)'"', "^[.][0-9]") {
        di as err "`optname'() must contain one syntactic R object name"
        di as err "examples: StataData, my_data, .hidden_data"
        exit 198
    }

    local reserved "if else repeat while function for in next break TRUE FALSE NULL Inf NaN NA NA_integer_ NA_real_ NA_complex_ NA_character_"
    if strpos(" `reserved' ", " `name' ") {
        di as err "`name' is a reserved R word; choose another `optname'()"
        exit 198
    }

    return local name `"`macval(name)'"'
end
