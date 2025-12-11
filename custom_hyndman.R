# Custom entry formats for Hyndman CV template
# Creates a separate publication_entries function for publications
# while preserving the original detailed_entries for other sections

library(vitae)
library(glue)

# Helper function from vitae (needed for glue_alt)
glue_alt <- function(..., .envir = parent.frame()) {
  glue::glue(..., .open = "<<", .close = ">>", .envir = .envir)
}

# Helper function to escape special LaTeX characters
escape_latex <- function(x) {
  x <- gsub("\\\\", "\\\\textbackslash{}", x)
  x <- gsub("([&%$#_{}])", "\\\\\\1", x)
  x <- gsub("~", "\\\\textasciitilde{}", x)
  x <- gsub("\\^", "\\\\textasciicircum{}", x)
  x
}

# Helper function to bold a specific name in author lists
bold_name <- function(author_string, name_to_bold = "Calacci") {
  # Match "D Calacci", "D. Calacci", "Dana Calacci" etc
  # Use \\1\\2 to reference the captured groups
  pattern <- paste0("(([A-Z]\\.?\\s+)?", name_to_bold, ")")
  replacement <- "\\\\textbf{\\1}"
  gsub(pattern, replacement, author_string, ignore.case = FALSE, perl = TRUE)
}

# Custom publication entries format:
# - Year on the left
# - Title in bold, left-justified
# - Authors below title
# - Venue below authors in italics with short venue in brackets
# - URL link with emoji if available
publication_entries <- function(data, what, when, with, where, venue_short, url, show_venue_short = TRUE) {
  what_expr <- rlang::enquo(what)
  when_expr <- rlang::enquo(when)
  with_expr <- rlang::enquo(with)
  where_expr <- rlang::enquo(where)
  venue_short_expr <- rlang::enquo(venue_short)
  url_expr <- rlang::enquo(url)

  out <- dplyr::mutate(data,
                       what = !!what_expr,
                       when = !!when_expr,
                       with = !!with_expr,
                       where = !!where_expr,
                       venue_short = !!venue_short_expr,
                       url = !!url_expr)

  # Escape special LaTeX characters in title, authors, and venue FIRST
  out$what <- escape_latex(out$what)
  out$with <- escape_latex(out$with)
  out$where <- escape_latex(out$where)

  # Then bold my name in author list (after escaping so \textbf{} doesn't get escaped)
  out$with <- bold_name(out$with)

  # Handle venue short name (only if show_venue_short is TRUE)
  if (show_venue_short) {
    out$venue_short <- ifelse(is.na(out$venue_short) | out$venue_short == "",
                              "",
                              paste0("[", escape_latex(out$venue_short), "] "))
  } else {
    out$venue_short <- ""
  }

  # Handle URL - use text link that's clearly clickable after title
  out$url_link <- ifelse(is.na(out$url) | out$url == "",
                        "",
                        paste0(" \\href{", out$url, "}{\\textcolor{blue}{$\\rightarrow$}}"))

  # Add URL link to title
  out$what <- paste0(out$what, out$url_link)

  # Clean up empty fields
  out$with <- ifelse(out$with == "", "\\empty%", paste0(out$with, "\\par%"))
  out$where <- ifelse(out$where == "",
                     "\\empty%",
                     paste0("\\textit{", out$venue_short, out$where, "}\\par%"))

  entries <- glue::glue_data(
    out,
"<<when>> & \\hspace{4.2em}\\parbox[t]{0.75\\textwidth}{%
  \\textbf{<<what>>}\\par%
  <<with>>
  <<where>>
\\vspace{\\parsep}}\\\\",
    .open = "<<",
    .close = ">>"
  )

  result <- paste(c(
    "\\begin{longtable}{@{}lp{0.65\\textwidth}@{}}",
    entries,
    "\\end{longtable}"
  ), collapse = "\n")

  # Return as knitr asis output to bypass vitae's processing
  knitr::asis_output(result)
}

# Media coverage entries format:
# - Year on the left
# - Title with optional link arrow
# - Venue below (no authors, no short venue)
media_entries <- function(data, what, when, where, url) {
  what_expr <- rlang::enquo(what)
  when_expr <- rlang::enquo(when)
  where_expr <- rlang::enquo(where)
  url_expr <- rlang::enquo(url)

  out <- dplyr::mutate(data,
                       what = !!what_expr,
                       when = !!when_expr,
                       where = !!where_expr,
                       url = !!url_expr)

  # Escape special LaTeX characters
  out$what <- escape_latex(out$what)
  out$where <- escape_latex(out$where)

  # Handle URL - use text link that's clearly clickable after title
  out$url_link <- ifelse(is.na(out$url) | out$url == "",
                        "",
                        paste0(" \\href{", out$url, "}{\\textcolor{blue}{$\\rightarrow$}}"))

  # Add URL link to title
  out$what <- paste0(out$what, out$url_link)

  # Format venue
  out$where <- ifelse(out$where == "",
                     "\\empty%",
                     paste0("\\textit{", out$where, "}\\par%"))

  entries <- glue::glue_data(
    out,
"<<when>> & \\hspace{4.2em}\\parbox[t]{0.75\\textwidth}{%
  \\textbf{<<what>>}\\par%
  <<where>>
\\vspace{\\parsep}}\\\\",
    .open = "<<",
    .close = ">>"
  )

  result <- paste(c(
    "\\begin{longtable}{@{}lp{0.65\\textwidth}@{}}",
    entries,
    "\\end{longtable}"
  ), collapse = "\n")

  # Return as knitr asis output to bypass vitae's processing
  knitr::asis_output(result)
}
