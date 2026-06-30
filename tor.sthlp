{smcl}
{* *! version 0.1.1 26jun2026}{...}
{title:Title}

{phang}{bf:tor} {hline 2} export the current Stata dataset to an R data frame through {cmd:rbridge}

{title:Syntax}

{p 8 12 2}{cmd:tor} [{varlist}] [{ifin}] [{cmd:,} {opt name(R_name)} {opt replace} {opt nocheck}]

{title:Description}

{pstd}{cmd:tor} copies the selected Stata data into an ordinary R data frame. By default, the R object is named {cmd:StataData}, matching StataRLink. Unlike old StataRLink, data transfer is through the in-memory {cmd:rbridge} view and {cmd:st_pull()}, not through tab-delimited files.

{pstd}If {it:varlist} is omitted, all variables are exported. {cmd:if} and {cmd:in} restrictions are passed to {cmd:rbridge}.

{title:Options}

{phang}{opt name(R_name)} names the R data frame. The name must be a syntactic R object name, such as {cmd:StataData} or {cmd:my_data}.

{phang}{opt replace} allows replacement of an existing R object with the same name.

{phang}{opt nocheck} is accepted for compatibility. The wrapper does not use StataRLink's old file-based consistency check.

{title:Examples}

{p 8 12 2}. {cmd:sysuse auto, clear}
{p 8 12 2}. {cmd:tor make price mpg rep78}
{p 8 12 2}. {cmd:r str(StataData)}
{p 8 12 2}. {cmd:tor m* in 1/3, name(myOtherName)}

{title:Also see}

{psee}{help rbridge}, {help r}, {help fromr}
