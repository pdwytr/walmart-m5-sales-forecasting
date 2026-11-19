# Forecasting Walmart Retail Unit Sales (M5 Accuracy) with ARIMAX in R

A baseline ARIMAX forecaster for the Kaggle M5 Forecasting - Accuracy competition: 28-day-ahead unit sales for Walmart products, using SNAP days, calendar events, weekday, month and (in early model versions) price as regressors.

## Competition context

[M5 Forecasting - Accuracy](https://www.kaggle.com/c/m5-forecasting-accuracy) was run by the Makridakis Open Forecasting Center (MOFC), University of Nicosia. The task is to forecast 28 days of unit sales for 30,490 item-store series from Walmart stores in California, Texas and Wisconsin (3,049 products, 3 categories, 7 departments, 10 stores). Submissions are scored with a Weighted Root Mean Squared Scaled Error (RMSSE); see the competition's evaluation page and M5 guide for details.

## Approach (as implemented in `R/m5_forecast.R`)

There are 30,490 series, so the script starts with a simple, interpretable baseline: one model per state x category group instead of one per series. It currently models the CA / FOODS group only.

1. Summing: daily unit sales of all CA FOODS series are summed into one series (1,913 days).
2. Regressors: SNAP flag (`snap_CA`), event type, weekday, month, and the summed weekly price for the group. Dummy variables are built with `caret::dummyVars`; one level each of event and weekday is dropped to avoid redundancy.
3. Exploration: Granger causality of price on sales (`lmtest::grangertest`), `VARselect`, decomposition, ACF/PACF.
4. Models (`forecast::auto.arima` with `xreg`), validated on the last 28 days of history:
   - `mod_1`: seasonal frequency 30
   - `mod_2`: frequency 7. Ljung-Box residual checks favour it over `mod_1`.
   - `mod_3`: frequency 7 + log transform (`lambda = 0`)
   - `mod_4`: frequency 7 + log transform + price excluded (zero-sales days dropped). This is the final model.
   Errors (MAE, MSE, RMSE, MAPE) are computed for each via `regr.eval`.
5. Prediction: `mod_4` forecasts 56 days (the validation and evaluation windows). The group forecast is divided by the number of series, so every series in the group gets the average per-item forecast. The result is written to `output/ca_food_forecast.csv`.

Scope note: the script covers the CA / FOODS group only (the SNAP column is `snap_CA`; change it to model other groups). Evaluation metrics are computed when you run the script; this repo does not include a saved results file or leaderboard score.

## Tech stack

R with `vroom`, `stringr`, `dplyr`, `forecast`, `caret`, `vars`, `lmtest`.

## Quickstart

1. Download the data from the [M5 competition page](https://www.kaggle.com/c/m5-forecasting-accuracy/data) (requires a Kaggle account, or `kaggle competitions download -c m5-forecasting-accuracy`).
2. Put these files in the `data/` folder (see `data/README.md`):
   - `data/calendar.csv` - dates, weekday, month, events, SNAP flags per state
   - `data/sell_prices.csv` - weekly sell price per store and item
   - `data/sales_train_validation.csv` - daily unit sales `d_1`..`d_1913` per item-store
3. Install dependencies once, then run from the repo root:

```
Rscript R/install_packages.R
Rscript R/m5_forecast.R
```

`R/m5_forecast.R` is written as an exploratory script with plots, so running it section by section in RStudio is also fine. Output: `output/ca_food_forecast.csv` with an `id` column and 56 forecast columns (`X1`..`X56`).

## Project structure

```
.
├── R/
│   ├── m5_forecast.R        # EDA, modelling and prediction script
│   └── install_packages.R   # installs the CRAN packages used
├── data/                    # M5 CSVs go here (gitignored); see data/README.md
├── output/                  # generated forecast CSV (gitignored)
└── README.md
```
