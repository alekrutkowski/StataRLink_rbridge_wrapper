cap mkdir "`c(sysdir_personal)'"
local files _srlb_assert_r_name.ado _srlb_init.ado r.ado startr.ado stopr.ado tor.ado fromr.ado r.sthlp startr.sthlp stopr.sthlp tor.sthlp fromr.sthlp
foreach f of local files {
    di as txt "Installing `f'"
    copy "`f'" "`c(sysdir_personal)'`f'", text replace
}

discard
which rbridge
which r
which tor
which fromr
