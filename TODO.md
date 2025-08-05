
# zinegen TODO

## Script Enhancements

- Add error handling for missing tools (pandoc, weasyprint, psjoin, qpdf, etc.)
- Add `-o` flag to specify output filename (e.g., output.pdf)
- Add `-v` flag for verbose output (e.g., show each command run)
- Add `-n` flag for dry-run (show what would be done without doing it)
- Automatically check number of input files is divisible by 8, pad or warn if not
- Enable and finalize support for portrait layout with `-p` flag
- Support auto-sorting input files by filename
- Add metadata support from YAML frontmatter or CLI flags

## Packaging & Distribution

- Create a Makefile for building zine with optional targets
- Create a Dockerfile with all dependencies (pandoc, weasyprint, etc.)
- Add install script that symlinks `zinegen.sh` to `/usr/local/bin/zinegen`