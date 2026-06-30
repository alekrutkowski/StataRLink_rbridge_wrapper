# StataRLink-style wrapper for stata-rbridge

This is a small ado-layer that keeps the old **[StataRLink](https://github.com/alekrutkowski/StataRLink)** command names while using **[stata-rbridge](https://github.com/alekrutkowski/stata-rbridge)** as the backend.

Provided commands:

- `startr` – initializes `rbridge`.
- `r` – evaluates one line of R code through `rbridge, code()`.
- `tor` – exports Stata data to an R data frame, default name `StataData`.
- `fromr` – imports an R data frame into Stata, default name `StataData`.
- `stopr` – compatibility close command. With `rbridge`, embedded R ends when Stata exits; `stopr, clear` removes ordinary R objects while keeping bridge helper names.

## Requirements

Install and verify [`stata-rbridge`](https://github.com/alekrutkowski/stata-rbridge) first. In Stata:

```stata
which rbridge
rbridge init
rbridge status
```

## Install from an unpacked copy

Download from https://github.com/alekrutkowski/StataRLink_rbridge_wrapper/archive/refs/heads/main.zip and unzip.

From Stata, after unzipping this directory:

```stata
net install statarlink_rbridge, from("/path/to/tataRLink_rbridge_wrapper") replace
```

Or copy the `.ado` and `.sthlp` files to your PERSONAL ado directory.

## Usage

```stata
startr

sysuse auto, clear
keep make price mpg rep78

tor
r StataData <- within(StataData, new <- price / 100)
fromr, clear
list in 1/5, clean

stopr, clear
```

The old `global rscript_path` setting is not used. `stata-rbridge` embeds R in the Stata process instead of launching the old StataRLink file-server workflow.

## Escaping and tricky R strings

The `r` wrapper now copies the user payload with Stata's `: copy local 0`, passes it with `macval()`, and copies retained R console output through Mata's `st_global()` before returning compatibility macros. This avoids a second round of Stata macro expansion inside the wrapper.

This cannot undo Stata's first command-line macro expansion. A literal R dollar sign typed at the Stata prompt still needs Stata escaping, or you can avoid it with bracket indexing:

```stata
r cat(mean(StataData\$price), "\n")
r cat(mean(StataData[["price"]]), "\n")
```

For literal R backticks in code typed directly at the Stata prompt, prefix each Stata-visible backtick with a backslash. For larger or very quote-heavy R blocks, put the R code in a `.R` file and use `rbridge source`; code read from a file is not parsed by Stata as command-line text.

## Compatibility notes

- `r(r1)` contains a synthetic prompt line, and printed R output begins at `r(r2)` where possible. This matches common old StataRLink patterns like `quietly r exists('x')` followed by checking `r(r2)`.
- `tor` supports `varlist`, `if`, `in`, `name()`, `replace`, and accepts `nocheck`.
- `fromr` supports `name()`, `clear`, and `nocheck`. It imports columns one by one through `rbridge generate`.
- `name()` must be a syntactic R name, for example `StataData`, `my_data`, or `.hidden_data`.
- `fromr` converts R factors, Date, POSIXct/POSIXlt, and unsupported column classes to character before import.
- `q()` and `quit()` are ignored by the `r` wrapper because embedded R should not be shut down from inside the Stata process.

## License

MIT License. Copyright (c) 2026 Alek Rutkowski.
