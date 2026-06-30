*! version 0.1.1 26jun2026
program define fromr, rclass
    version 14.1
    syntax [, NAME(string asis) CLEAR noCHECK]

    _srlb_init, quiet

    if `"`macval(name)'"' == "" local name "StataData"
    _srlb_assert_r_name `"`macval(name)'"' name

    capture quietly describe
    if !_rc {
        if r(changed) & "`clear'" == "" {
            error 4
        }
    }

    local pfx ".StataRLink_fromr_col"
    local rcode `"obj <- get('`name'', envir=.GlobalEnv, inherits=FALSE); "'
    local rcode `"`rcode'if (!is.data.frame(obj)) stop('`name' object is not a data.frame!'); "'
    local rcode `"`rcode'nr <- nrow(obj); nc <- ncol(obj); "'
    local rcode `"`rcode'if (nr == 0L) stop('`name' is empty: it has no observations/rows!'); "'
    local rcode `"`rcode'if (nc == 0L) stop('`name' is empty: it has no variables/columns!'); "'
    local rcode `"`rcode'safe <- function(x) { "'
    local rcode `"`rcode'x <- iconv(x, to='ASCII//TRANSLIT', sub='_'); "'
    local rcode `"`rcode'x[is.na(x) | !nzchar(x)] <- 'v'; "'
    local rcode `"`rcode'x <- gsub('[^A-Za-z0-9_]', '_', x); x <- gsub('_+', '_', x); "'
    local rcode `"`rcode'x <- sub('^[^A-Za-z_]+', 'v', x); x <- substr(x, 1L, 32L); "'
    local rcode `"`rcode'x[!nzchar(x)] <- 'v'; x }; "'
    local rcode `"`rcode'make_unique <- function(z) { "'
    local rcode `"`rcode'bad <- tolower(c('if','in','using','byte','int','long','float','double','str','strl','_n','_N','_all')); "'
    local rcode `"`rcode'out <- character(length(z)); used <- character(); "'
    local rcode `"`rcode'for (i in seq_along(z)) { "'
    local rcode `"`rcode'base <- z[i]; if (tolower(base) %in% bad) base <- paste0('v_', substr(base, 1L, 29L)); "'
    local rcode `"`rcode'cand <- substr(base, 1L, 32L); j <- 1L; "'
    local rcode `"`rcode'while (tolower(cand) %in% tolower(used)) { "'
    local rcode `"`rcode'suffix <- paste0('_', j); cand <- paste0(substr(base, 1L, 32L - nchar(suffix, type='bytes')), suffix); j <- j + 1L }; "'
    local rcode `"`rcode'out[i] <- cand; used <- c(used, cand) }; out }; "'
    local rcode `"`rcode'nm <- names(obj); if (is.null(nm)) nm <- rep('', nc); sn <- make_unique(safe(nm)); "'
    local rcode `"`rcode'cat('@@N@@ ', nr, '\n', sep=''); cat('@@K@@ ', nc, '\n', sep=''); "'
    local rcode `"`rcode'for (i in seq_len(nc)) { "'
    local rcode `"`rcode'x <- obj[[i]]; if (is.factor(x)) x <- as.character(x); "'
    local rcode `"`rcode'if (inherits(x, 'Date') || inherits(x, 'POSIXt')) x <- as.character(x); "'
    local rcode `"`rcode'if (is.list(x) && !is.data.frame(x)) x <- vapply(x, function(y) paste(y, collapse=', '), character(1)); "'
    local rcode `"`rcode'if (!(is.logical(x) || is.integer(x) || is.numeric(x) || is.character(x))) x <- as.character(x); "'
    local rcode `"`rcode'assign(paste0('`pfx'', i), x, envir=.GlobalEnv); "'
    local rcode `"`rcode'cat('@@V@@ ', i, ' ', sn[i], '\n', sep='') }"'

    di as txt "Exporting " as res `"'`name''"' as txt " from R..."
    return clear
    capture noisily rbridge, code(`"`macval(rcode)'"')
    local rc = _rc
    if `rc' exit `rc'

    local stored 0
    capture local stored = r(stored_lines)
    if _rc local stored 0

    local N .
    local K .
    forvalues i = 1/`stored' {
        mata: st_local("line", st_global("r(output`i')"))
        if substr(`"`macval(line)'"', 1, 6) == "@@N@@" {
            local N = real(word(`"`macval(line)'"', 2))
        }
        else if substr(`"`macval(line)'"', 1, 6) == "@@K@@" {
            local K = real(word(`"`macval(line)'"', 2))
        }
        else if substr(`"`macval(line)'"', 1, 6) == "@@V@@" {
            gettoken tag rest : line
            gettoken idx rest : rest
            gettoken vname rest : rest
            local v`idx' `"`macval(vname)'"'
        }
    }

    if missing(`N') | missing(`K') {
        di as err "fromr could not read metadata returned by R"
        exit 498
    }

    di as txt "Importing data into Stata..."
    clear
    quietly set obs `N'

    local imported
    forvalues i = 1/`K' {
        local vname "`v`i''"
        if `"`vname'"' == "" local vname "v`i'"
        capture noisily rbridge generate `vname', from(`pfx'`i')
        local rc = _rc
        if `rc' {
            di as err "fromr failed while importing R column `i' as Stata variable `vname'"
            capture noisily rbridge, code("rm(list=paste0('`pfx'', seq_len(`K')), envir=.GlobalEnv); invisible(gc())")
            exit `rc'
        }
        local imported `imported' `vname'
    }

    capture quietly rbridge, code("rm(list=paste0('`pfx'', seq_len(`K')), envir=.GlobalEnv); invisible(gc())")

    if "`check'" != "nocheck" {
        if _N != `N' {
            di as err "Something went wrong: the imported Stata data has `=_N' rows; R had `N' rows."
            exit 692
        }
        if c(k) != `K' {
            di as err "Something went wrong: the imported Stata data has `=c(k)' variables; R had `K' columns."
            exit 692
        }
    }

    di as txt "(`K' vars, `N' obs)"
    return clear
    return local name `"`macval(name)'"'
    return local varlist "`imported'"
    return scalar N = `N'
    return scalar k = `K'
end
