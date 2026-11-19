# Installs the CRAN packages used by M5.R
pkgs <- c("vroom", "stringr", "dplyr", "forecast", "caret", "vars", "lmtest")
install.packages(setdiff(pkgs, rownames(installed.packages())))
