#' @import fs
NULL

#' @title create_rmarkdown_project
#' @description Main function to create a new project. Triggered by the new
#' project wizard. It's callback is at:
#' inst/rstudio/templates/project/create_project.dcf
#' @param ... additional arguments
#' @param path the path to the new project. Will also serve as project name
#' @return Nothing. Create a new RStudio project
#' @export
create_rmarkdown_project <- function(path, ...) {

  # get some needed info: the path to the stored template and the additional
  # arguments
  from <- demoPath_sys("templatedemo")
  dots <- list(...)

  cat('Copy template structure to', path, '.\n')
  fs::dir_copy(
    path = from,
    new_path = path,
    overwrite = TRUE
  )
  cat('New project created in', path, '.\n')

  # Listing copied files ***from source directory***
  copied_files <- list.files(
    path = from,
    full.names = FALSE,
    all.files = TRUE,
    recursive = TRUE
  )

  cat('Create new package references')
  replace_package_name(
    copied_files,
    basename(path),
    path
  )

  # here we switch into the new folder
  setwd(path)
  # activate renv if needed
  if(dots$useRenv){
    cat('Activate renv.\n')
    renv::activate(project = getwd())
  }

  # if not needed, remove the .gitignore from the copied template
  if(!dots$createGitignore){
    cat("Git not created.\n")
    file.remove('.gitignore')
  }

  # add the specified environmetn to the .Renviorn file
  cat('Adding environment', dots$chosenEnv, 'to the new project.\n')
  addEnvToRenviron(tolower(dots$chosenEnv))

  cat('All done')

}

#' @title demoPath_sys
#' @description return the path where the template is saved locally
#' @param ... additional arguments
#' @param lib.loc the path to the R library
#' @param mustWork logical
#' @return string
demoPath_sys <- function (..., lib.loc = NULL, mustWork = FALSE){
  system.file(..., package = "rstudiotemplate", lib.loc = lib.loc, mustWork = mustWork)
}

#' @title replace_package_name
#' @description replace the generic reference to a template "templetedemo"
#' with the actual name of the new project
#' @param copied_files all the files to search for replacements (basename())
#' @param package_name the new project name
#' @param path the full root path of the copied_files
#' @return Nothing. Overwrite files
replace_package_name <- function(copied_files,
                                 package_name,
                                 path){
  # Going through copied files to replace package name
  for (f in copied_files) {
    copied_file <- file.path(path, f)

    try({
      replace_word(
        file = copied_file,
        pattern = "templatedemo",
        replace = package_name
      )
    },silent = TRUE)
  }
}

#' @title replace_word
#' @description replace a pattern in a file
#' @param file the path to the file
#' @param pattern the pattern to be replaced
#' @param replace the replacement
#' @return Nothing. Overwrite the file
replace_word <- function (file, pattern, replace){
  suppressWarnings(tx <- readLines(file))
  tx2 <- gsub(pattern = pattern, replacement = replace, x = tx)
  writeLines(tx2, con = file)
}

#' @title addEnvToRenviron
#' @description add a line to the .Renviron file of the new project to specify
#' the active environment used by config
#' @param chosenEnv string. The selected environment
#' @return Nothing. Overwrite .Renviron
addEnvToRenviron <- function(chosenEnv){
  tx <- readLines('.Renviron')
  tx <- c(tx, paste0('R_CONFIG_ACTIVE=',chosenEnv))
  writeLines(tx, '.Renviron')
}
