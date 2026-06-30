{smcl}
{* *! version 0.1.1 26jun2026}{...}
{title:Title}

{phang}{bf:stopr} {hline 2} StataRLink-style close command for the {cmd:rbridge} backend

{title:Syntax}

{p 8 12 2}{cmd:stopr} [{cmd:,} {opt clear}]

{title:Description}

{pstd}{cmd:stopr} exists for old StataRLink habits. With {cmd:rbridge}, the R interpreter is embedded in Stata and cannot be safely terminated by sending {cmd:q()} or {cmd:quit()}. This command marks the compatibility session as off. The embedded R session itself ends when Stata exits.

{title:Option}

{phang}{opt clear} removes ordinary objects from R's global environment before marking the compatibility session as off, while keeping bridge helper names.

{title:Also see}

{psee}{help rbridge}, {help r}, {help startr}
