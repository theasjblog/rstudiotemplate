demoPath_sys <- function (..., lib.loc = NULL, mustWork = FALSE)
{
  system.file(..., package = "rstudioProjectTemplate", lib.loc = lib.loc, mustWork = mustWork)
}

replace_word <- function (file, pattern, replace)
{
  suppressWarnings(tx <- readLines(file))
  tx2 <- gsub(pattern = pattern, replacement = replace, x = tx)
  writeLines(tx2, con = file)
}

replace_package_name <- function(
    copied_files,
    package_name,
    path
) {
  # Going through copied files to replace package name
  for (f in copied_files) {
    copied_file <- file.path(path, f)

      try(
        {
          replace_word(
            file = copied_file,
            pattern = "templatedemo",
            replace = package_name
          )
        },
        silent = TRUE
      )
  }

}


#' This package will create a function called create_project()
#'
#' It's callback is at: inst/rstudio/templates/project/create_project.dcf
#' @import cli
#' @import renv
#' @import fs
#' @export

create_project <- function(path, ...) {

  cat('Creating directory', path, '\n')
    # Create the project path given the name chosen by the user:
    #dir.create(path, recursive = TRUE, showWarnings = FALSE)


    from <- demoPath_sys("templatedemo")

    cat('Copy template structure\n')
    # Copy over whole directory
    fs::dir_copy(
      path = from,
      new_path = path,
      overwrite = TRUE
    )
    cat('\U2705', 'New project created in', path, '\n')

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



#     # Collect the list of inputs in a list to be called later:
#     dots <- list(...)
#
#     # In the project template we've added 2 choices for the user:
# 	# * One allows them to select if the project will have a .gitignore file
# 	# * The other will create a folder, given a select input from the user


# 	}



	# # Check selected folder
	# if(dots[["folder"]] == "Production"){
	# 	dir.create("production", recursive = TRUE, showWarnings = FALSE)
	# } else {
	# 	dir.create("development", recursive = TRUE, showWarnings = FALSE)
	# }

    # # Initialize the local directory as a Git repository.
    # git init
    #
    # # Add files
    # git add .
    #
    # # Commit your changes
    # git commit -m "First commit"
    #
    # # Add remote origin
    # git remote add origin <Remote repository URL>
    #   # <Remote repository URL> looks like: https://github.com/user/repo.git
    #https://<USERNAME>:<PASSWORD>@github.com/path/to/repo.git

}
