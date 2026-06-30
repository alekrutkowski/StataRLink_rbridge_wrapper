*! version 0.1.1 26jun2026
program define tor, rclass
    version 14.1
    syntax [varlist(default=none)] [if] [in] [, NAME(string asis) REPLACE noCHECK]

    _srlb_init, quiet

    if `"`macval(name)'"' == "" local name "StataData"
    _srlb_assert_r_name `"`macval(name)'"' name

    quietly describe
    local allN = r(N)
    local allk = r(k)
    if `allN' == 0 | `allk' == 0 {
        di as err "The dataset in Stata memory is empty!"
        di as err "(`allk' variables/columns, `allN' observations/rows)"
        exit 3
    }

    if `"`varlist'"' == "" {
        local bridge_varlist "_all"
        local return_varlist "_all"
        local k = `allk'
    }
    else {
        local bridge_varlist `"`varlist'"'
        local return_varlist `"`varlist'"'
        local k : word count `varlist'
    }
    quietly count `if' `in'
    local N = r(N)

    local allow_replace = cond("`replace'" != "", "TRUE", "FALSE")
    local rcode "if (!`allow_replace' && exists('`name'', envir=.GlobalEnv, inherits=FALSE)) stop('Object `name' already exists in R; specify option replace'); `name' <- st_pull(); str(`name')"

    di as txt "Exporting data from Stata..."
    di as txt "Importing data into R object " as res `"'`name''"' as txt "..."

    return clear
    capture noisily rbridge `bridge_varlist' `if' `in', code(`"`macval(rcode)'"')
    local rc = _rc
    if `rc' exit `rc'

    return add
    return local name `"`macval(name)'"'
    return local varlist `"`return_varlist'"'
    return scalar N = `N'
    return scalar k = `k'
end
