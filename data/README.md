# Data

The M5 data is not stored in this repo (it is gitignored). Download it from the
[M5 Forecasting - Accuracy data page](https://www.kaggle.com/c/m5-forecasting-accuracy/data)
(Kaggle account required) or with:

    kaggle competitions download -c m5-forecasting-accuracy

Unzip these files directly into this `data/` folder:

- `calendar.csv` - dates, weekday, month, events, SNAP flags per state
- `sell_prices.csv` - weekly sell price per store and item
- `sales_train_validation.csv` - daily unit sales `d_1`..`d_1913` per item-store

Run the script from the repo root so the relative `data/` path resolves.
