# RMarkdown CV Template

An RMarkdown CV template to keep an up-to-date academic CV using the `vitae` package with a custom Hyndman template.

## Installation

### Required R Packages

Before using this template, you need to install the following R packages. Open RStudio and run:

```r
# Install required packages
install.packages(c("vitae", "tibble", "dplyr", "knitr", "glue", "rlang", "yaml"))
```

Note: The `yaml` package is used to automatically detect your surname from the YAML metadata. It's typically installed as a dependency of `rmarkdown`, but if you encounter issues, install it explicitly.

If you don't have RStudio installed, you can download it from [rstudio.com](https://www.rstudio.com/products/rstudio/download/).

### LaTeX Requirements

This template generates PDF output using LaTeX. You'll need a LaTeX distribution installed:

- **macOS**: Install [MacTeX](https://www.tug.org/mactex/)
- **Windows**: Install [MiKTeX](https://miktex.org/)
- **Linux**: Install `texlive-full` via your package manager

## Running the Template

1. Open `cv.Rmd` in RStudio
2. Update the YAML header (lines 1-21) with your personal information:
   - `name`: Your first name
   - `surname`: Your last name
   - `position`: Your current position
   - `address`: Your location
   - `phone`: Your phone number
   - `pronouns`: Your pronouns
   - `www`: Your website
   - `email`: Your email address
   - `github`: Your GitHub username
   - `aboutme`: A brief description of your work

3. Click the **"Knit"** button in RStudio (or press `Cmd+Shift+K` on macOS / `Ctrl+Shift+K` on Windows/Linux) to generate your CV PDF

## Data Format

This template uses two methods for entering data:

### 1. CSV Files

Two CSV files are used for structured data:

#### `contributions.csv`

Contains publications, talks, posters, and other academic contributions. Required columns:

- `Year`: Publication/presentation year (numeric or text)
- `Title`: Title of the work
- `Authors`: Author list (your name will be automatically bolded based on the `surname` field in the YAML metadata)
- `Venue`: Full venue name (e.g., "Proceedings of the ACM on Human-Computer Interaction")
- `VenueShort`: Short venue abbreviation (e.g., "CSCW")
- `Section`: Category that determines which section the entry appears in. Valid values:
  - `Refereed Article`
  - `Under Review`
  - `Public Writing`
  - `Keynote`
  - `Organized Events`
  - `Conference Talk`
  - `Poster`
  - `Invited Talk`
  - `Internal Talk`
  - `Media Coverage`
- `URL`: Optional URL link (leave empty if no URL)

**Example row:**
```csv
2025,"Dead Zone of Accountability: Why Social Claims in Machine Learning Research Should Be Articulated and Defended","Tianqi Kou, Cindy Lin, D Calacci","Proceedings of the AAAI/ACM Conference on AI, Ethics, and Society",AIES,Refereed Article,https://ojs.aaai.org/index.php/AIES/article/view/36649
```

#### `students.csv`

Contains student advising and mentorship information. Required columns:

- `Name`: Student name
- `Year`: Year(s) of mentorship (e.g., "2023-", "2024-2025")
- `Institution`: Institution name
- `Notes`: Optional additional notes
- `Type`: Category of mentorship. Valid values:
  - `Committee`: Committee membership
  - `Mentorship`: Graduate/postdoc mentorship
  - `Undergraduate`: Undergraduate mentorship

**Example row:**
```csv
Student Name,2023-,Princeton University,,Mentorship
```

### 2. Inline Data (tribble)

Some sections use inline `tribble()` calls directly in the RMarkdown file. These sections include:

- **Education**: Columns: `Degree`, `Year`, `Institution`, `Where`
- **Appointments**: Columns: `Institution`, `Year`, `Department`, `Title`
- **Grants**: Columns: `Year`, `Title`, `Role`, `Funder`
- **Teaching Experience**: Columns: `Year`, `Title`, `Where`, `Description`
- **Professional Service**: Columns: `Year`, `Title`, `Authors`, `Venue`
- **University Service**: Columns: `Year`, `Title`, `Authors`, `Venue`
- **Other Professional Experience**: Columns: `Year`, `Title`, `Authors`, `Venue`

**Example:**
```r
tribble(
  ~ Degree, ~ Year, ~ Institution, ~ Where,
  "PhD, Media Arts and Sciences", "2019-2023", "Massachusetts Institute of Technology", "Cambridge, MA",
  "M.S., Media Arts and Sciences", "2016-2018", "Massachusetts Institute of Technology", "Cambridge, MA"
) %>%
  detailed_entries(Degree, Year, Institution, Where)
```

## Customizing Sections

### Removing Sections

**If you don't have relevant information for a section, delete the entire section** (including the section header, any subsections, and all associated R code chunks). For example, if you don't have any grants, delete:

```markdown
# Grants 

## Current

```{r}
...
```

## Submitted & Under Review

```{r}
...
```

## Completed

```{r}
...
```
```

Simply remove all of this content from your `cv.Rmd` file.

### Adding New Sections

To add a new section:

1. Add a new section header (e.g., `# New Section Name`)
2. Add an R code chunk that either:
   - Filters from `contributions.csv` using `filter(Section == 'YourSectionName')`
   - Uses a `tribble()` with inline data
3. Use the appropriate entry function:
   - `publication_entries()` for publications/talks
   - `detailed_entries()` for structured entries
   - `media_entries()` for media coverage

### Modifying Section Content

- **To change which contributions appear in a section**: Modify the `filter(Section == '...')` line in the relevant code chunk
- **To change the order**: Modify the `arrange()` function (e.g., `arrange(desc(Year))` sorts by year descending)
- **To add/remove venue abbreviations**: Set `show_venue_short = TRUE` or `FALSE` in `publication_entries()`

## Custom Functions

The template includes custom formatting functions in `custom_hyndman.R`:

- `publication_entries()`: Formats publications with title, authors, venue, and optional URL
- `detailed_entries()`: Formats structured entries (from `vitae` package)
- `media_entries()`: Formats media coverage entries

These functions automatically:
- Bold your name in author lists (automatically uses the `surname` from YAML metadata)
- Escape special LaTeX characters
- Add clickable URL links (blue arrow symbol)
- Format venue names with optional short abbreviations

## Troubleshooting

- **PDF won't compile**: Make sure you have a LaTeX distribution installed (see Installation section)
- **Missing packages**: Run `install.packages(c("vitae", "tibble", "dplyr", "knitr", "glue", "rlang"))`
- **CSV errors**: Make sure your CSV files are properly formatted with all required columns
- **Name not bolding**: The template automatically uses the `surname` field from your YAML metadata to bold your name in author lists. Make sure `surname` is set correctly in the YAML header. The template looks for patterns like "D Surname", "D. Surname", or "Firstname Surname" in author lists.

## License

See LICENSE file for details.
