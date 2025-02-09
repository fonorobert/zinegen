# zinegen

*Based on [checklistgen](https://github.com/fonorobert/checklistgen).*

Shell script and stylesheets wrapping pandoc, weasyprint and pdfjam to generate 6-fold zines on A4 paper in PDF.

## Dependencies

- pandoc
- weasyprint
- psutils

To set up depednencies on Mac (with command line tools and Homebrew installed):

```
brew install pandoc weasyprint psutils
```

## Usage

```
zinegen -o /path/to/build/location -s /path/to/css/stylesheet FILES-TO-BUILD
```

-o defaults to `./build` and -s to `./custom.css` (relative to the folder where the script is ran in)

**Note:** run the script in the root of the folder that contains your md files. This ensures that image inclusions will be run relative to your source folder.

## Document format

Each page of zine a separate .md file.  
Exact format TBD.
