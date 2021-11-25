# This script loads all utility function in the "UtilityFunctions" folder and 
# all necessary R packages. 
# Will be common functions to all the conversion tools (e.g. convert mass 
# spectra to lists) and R packages (e.g. data tables). 

# ==============================================================================
## Load custom functions
avail_functions = list.files("../UtilityFunctions/",pattern="*.R")
a = which(avail_functions == "LoadAllFunctions.R");
avail_functions = avail_functions[-a]

if(length(avail_functions)>0){
     for(i in 1:length(avail_functions)){
          source(paste0("../UtilityFunctions/",avail_functions[i]))
     }
}


# ==============================================================================
## Load external packages

# To create data tables
if("data.table" %in% installed.packages() == FALSE){
     install.packages("data.table")
     library(data.table)
} else {
     library(data.table)
}

# For file.move functionality
if("filesstrings" %in% row.names(installed.packages())==FALSE){
  install.packages("filesstrings")
  library(filesstrings)
} else {
  library(filesstrings)
}