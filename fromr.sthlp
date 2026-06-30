{smcl}
{* *! version 0.1.1 26jun2026}{...}
{title:Title}

{phang}{bf:fromr} {hline 2} import an R data frame into Stata through {cmd:rbridge}

{title:Syntax}

{p 8 12 2}{cmd:fromr} [{cmd:,} {opt name(R_name)} {opt clear} {opt nocheck}]

{title:Description}

{pstd}{cmd:fromr} imports an R data frame into Stata. By default, the R object is named {cmd:StataData}, matching StataRLink. The command reads the R data frame column by column using {cmd:rbridge generate}.

{pstd}The current Stata data are cleared before import. If the current data have unsaved changes, specify {cmd:clear}, as in StataRLink.

{pstd}R factors, Date, POSIXct/POSIXlt, and unsupported column classes are converted to character before import. Stata variable names are made valid and unique. Character columns longer than fixed-width Stata strings supported by {cmd:rbridge generate} will stop with an error.

{title:Options}

{phang}{opt name(R_name)} names the R data frame to import. The name must be a syntactic R object name.

{phang}{opt clear} allows replacement of changed Stata data in memory.

{phang}{opt nocheck} skips the final row and column count check.

{title:Examples}

{p 8 12 2}. {cmd:sysuse auto, clear}
{p 8 12 2}. {cmd:tor make price mpg rep78}
{p 8 12 2}. {cmd:r StataData <- within(StataData, new <- price/100)}
{p 8 12 2}. {cmd:fromr, clear}

{title:Also see}

{psee}{help rbridge}, {help r}, {help tor}
