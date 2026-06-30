{smcl}
{* *! version 0.1.1 26jun2026}{...}
{title:Title}

{phang}{bf:startr} {hline 2} initialize the embedded R session used by StataRLink-style wrappers

{title:Syntax}

{p 8 12 2}{cmd:startr} [{cmd:,} {opt force}]

{title:Description}

{pstd}{cmd:startr} is a compatibility wrapper around {cmd:rbridge init}. The old StataRLink {cmd:rscript_path} global is not used because {cmd:rbridge} embeds R inside Stata rather than launching a local Rscript server.

{title:Option}

{phang}{opt force} calls {cmd:rbridge init} even if the compatibility globals suggest that the session is already open.

{title:Also see}

{psee}{help rbridge}, {help r}, {help stopr}
