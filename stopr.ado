*! version 0.1.1 26jun2026
program define stopr, rclass
    version 14.1
    syntax [, CLEAR]

    capture which rbridge
    if _rc {
        global rserver "off"
        global rserver_backend ""
        di as txt `"R "server" stopped successfully"'
        exit
    }

    if "`clear'" != "" {
        capture noisily rbridge, code("objs <- setdiff(ls(envir=.GlobalEnv, all.names=TRUE), c('st_pull','st_write','stata')); rm(list=objs, envir=.GlobalEnv); invisible(gc())")
        local rc = _rc
        if `rc' exit `rc'
    }

    global rserver "off"
    global rserver_backend ""
    return local backend "rbridge"
    return scalar stopped = 0
    di as txt `"R "server" stopped successfully"'
    di as txt "note: embedded R remains loaded until Stata exits; use {bf:stopr, clear} to remove R objects"
end
