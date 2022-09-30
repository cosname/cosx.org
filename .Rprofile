if (file.exists('~/.Rprofile')) sys.source('~/.Rprofile', globalenv())

options(
  digits = 4, formatR.indent = 2,
  blogdown.hugo.version = '0.101.0',
  blogdown.hugo.server = c(
    '-D', '-F', '--navigateToChanged', '--noTimes'
  ),
  blogdown.yaml.empty = FALSE, blogdown.publishDir = '../cosx-public'
)

local({
  pandoc_path = Sys.getenv('RSTUDIO_PANDOC', NA)
  if (Sys.which('pandoc') == '' && !is.na(pandoc_path)) Sys.setenv(PATH = paste(
    Sys.getenv('PATH'), pandoc_path, sep = .Platform$path.sep
  ))
})
