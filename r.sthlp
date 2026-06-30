{smcl}
{* *! version 0.1.1 26jun2026}{...}
{title:Title}

{phang}{bf:r} {hline 2} StataRLink-style wrapper for evaluating one R command through {cmd:rbridge}

{title:Syntax}

{p 8 12 2}{cmd:r} {it:R_code}

{title:Description}

{pstd}{cmd:r} evaluates {it:R_code} in the persistent embedded R session managed by {cmd:rbridge}. It exists for compatibility with old StataRLink do-files that call {cmd:r} directly.

{pstd}The wrapper auto-initializes {cmd:rbridge} if needed. It returns compatibility macros {cmd:r(r1)}, {cmd:r(r2)}, ... and scalar {cmd:r(rn)}. Macro {cmd:r(r1)} contains a synthetic R prompt line, so printed R output starts at {cmd:r(r2)} for the common StataRLink pattern.

{pstd}Calls to {cmd:q()} and {cmd:quit()} are ignored. Use {cmd:stopr}; the embedded R session ends only when Stata exits.

{title:Literal dollar signs and backticks}

{pstd}{cmd:r} uses {cmd:: copy local 0}, {cmd:macval()}, and Mata-based result copying internally to avoid a second round of Stata macro expansion after the command reaches the wrapper.

{pstd}This does not stop Stata's first command-line macro expansion. To type an R dollar sign at the Stata prompt, prefix it with a backslash, or use bracket indexing.

{p 8 12 2}. {cmd:r cat(mean(StataData\$price), "\n")}
{p 8 12 2}. {cmd:r cat(mean(StataData[["price"]]), "\n")}

{pstd}For literal R backticks typed at the Stata prompt, prefix each Stata-visible backtick with a backslash. For larger or quote-heavy code, put the R code in a {cmd:.R} file and call {cmd:rbridge source}.

{title:Examples}

{p 8 12 2}. {cmd:startr}
{p 8 12 2}. {cmd:r x <- 1:5}
{p 8 12 2}. {cmd:r mean(x)}
{p 8 12 2}. {cmd:return list}

{title:Also see}

{psee}{help rbridge}, {help tor}, {help fromr}, {help startr}, {help stopr}
