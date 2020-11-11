#### Create R package from command line

# The directory should be in your project folder XX/YY/ZZ/covidDataCDC

raw_data_path <- "inst/raw_data/"

file_ls <- list.files(raw_data_path)

# Create data fields data list
data_fields <- lapply(file_ls, function(x) {
  get(load(paste0(raw_data_path, x)))
})

names(data_fields) <- c("available_fields", "available_states",
                        "default_fields", "default_states")
# Create internal data
usethis::use_data(data_fields, overwrite = T)

# Create documentation for the package
devtools::document()

# Build package
package_loc <- devtools::build()
install.packages(package_loc, repos = NULL) #, lib = lib_path)
