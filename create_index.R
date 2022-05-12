is.app <- function(path) {
  files <- c('app.R', 'server.R')
  any(sapply(paste(path, files, sep="/"), file.exists))
}

df_from_shiny_app_path <- function(app_path) {
  paths <- list.dirs(app_path, recursive = FALSE)
  apps <- list()
  for (path in paths) {
    if (is.app(path)) {
      desc_file <- paste(path, 'DESCRIPTION', sep="/")
      if (file.exists(desc_file)) {
        apps[[path]] <- as.vector(read.dcf(paste(paths[3], 'DESCRIPTION', sep="/")))
      } else {
        apps[[path]] <- c(Title=NA, Author=NA, AuthorUrl=NA, License=NA, DisplayMode=NA,
                          Tags=NA, Type=NA)
      }
    }
  }
  
  df <- as.data.frame(do.call(rbind, apps))
  df$url <- rownames(df)
  rownames(df) <- NULL
  df
}

create_index <- function(app_path, output_path) {
  
  df <- df_from_shiny_app_path(app_path)
  
  HTML <- "Listado de Aplicaciones Shiny disponibles"
  
}