*! version 0.1.1 26jun2026
program define startr, rclass
    version 14.1
    syntax [, FORCE]

    local rs : copy global rserver
    local rb : copy global rserver_backend

    if `"`macval(rs)'"' == "on" & `"`macval(rb)'"' == "rbridge" & "`force'" == "" {
        di as err `"R "server" seems to be open already."'
        di as err "Use option {bf:force} if you really want to re-initialize the bridge."
        exit 691
    }

    _srlb_init, force
    return add
    di as txt `"R "server" started successfully"'
    di as txt "backend: rbridge embedded R session"
end
