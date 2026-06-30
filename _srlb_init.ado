*! version 0.1.1 26jun2026
program define _srlb_init, rclass
    version 14.1
    syntax [, FORCE QUIET]

    capture which rbridge
    if _rc {
        di as err "rbridge was not found on the Stata ado-path"
        di as err "Install stata-rbridge first, then verify with: which rbridge"
        exit 499
    }

    local rs : copy global rserver
    local rb : copy global rserver_backend

    if "`force'" != "" | `"`macval(rs)'"' != "on" | `"`macval(rb)'"' != "rbridge" {
        if "`quiet'" != "" {
            capture quietly rbridge init
        }
        else {
            capture noisily rbridge init
        }
        local rc = _rc
        if `rc' {
            di as err "rbridge init failed"
            exit `rc'
        }
        global rserver "on"
        global rserver_backend "rbridge"
    }

    local rs : copy global rserver
    return local backend "rbridge"
    return local rserver `"`macval(rs)'"'
end
