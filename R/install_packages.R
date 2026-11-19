# Installs the CRAN packages used by R/m5_forecast.R
pkgs <- c("vroom", "stringr", "dplyr", "forecast", "caret", "vars", "lmtest")
install.packages(setdiff(pkgs, rownames(installed.packages())))
