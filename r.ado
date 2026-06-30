*! version 0.1.1 26jun2026
program define r, rclass
    version 14.1

    _srlb_init, quiet

    // Copy local 0 without re-expanding macro references contained in it.
    // This protects payloads that already contain literal $, `, or ' characters
    // after Stata's initial command-line macro expansion has happened.
    local code : copy local 0

    mata: st_local("srlb_empty", strofreal(strlen(strtrim(st_local("code"))) == 0))
    if `srlb_empty' {
        di as err "nothing to send to R"
        exit 198
    }

    mata: st_local("srlb_quit", strofreal((strtrim(st_local("code")) == "q()") | (strtrim(st_local("code")) == "quit()")))
    if `srlb_quit' {
        di as txt "q() and quit() are ignored by the rbridge compatibility wrapper"
        di as txt "Use {bf:stopr} for the StataRLink-style command; embedded R ends when Stata exits."
        return clear
        return local code `"`macval(code)'"'
        return local r1 `"> `macval(code)'"'
        return scalar rn = 1
        return scalar rc = 0
        exit
    }

    return clear
    capture noisily rbridge, code(`"`macval(code)'"')
    local rc = _rc

    local stored 0
    capture local stored = r(stored_lines)
    if _rc local stored 0
    if missing(`stored') local stored 0

    // Pull rbridge's retained console text through Mata/st_global() so R output
    // containing $, `, or other macro-looking text is not expanded by Stata.
    mata: st_local("rb_output", st_global("r(output)"))
    mata: st_local("rb_error",  st_global("r(error)"))
    forvalues i = 1/`stored' {
        mata: st_local("rb_line`i'", st_global("r(output`i')"))
    }

    return clear
    return local code `"`macval(code)'"'
    return local output `"`macval(rb_output)'"'
    return local error  `"`macval(rb_error)'"'
    return scalar rc = `rc'

    return local r1 `"> `macval(code)'"'
    local rn 1
    forvalues i = 1/`stored' {
        local line : copy local rb_line`i'
        local linelen : strlen local line
        if `linelen' > 0 {
            local rn = `rn' + 1
            return local r`rn' `"`macval(line)'"'
        }
    }
    return scalar rn = `rn'

    if `rc' exit `rc'
end
