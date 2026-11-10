# Telco Customer Churn Analytics

## Project objective

Analyze customer churn patterns in the IBM Telco Customer Churn dataset and develop evidence-based retention recommendations.

## Dataset

Source: [IBM Telco Customer Churn dataset on Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)

Place the downloaded file at:

`data/raw/WA_Fn-UseC_-Telco-Customer-Churn.csv`

The raw CSV is excluded from Git. Download it from the source above to reproduce the analysis.

## Project structure

- `data/raw/` - downloaded source data
- `data/clean/` - prepared analysis data
- `sql/` - SQL analysis
- `notebooks/` - Python analysis notebooks
- `powerbi/` - dashboard files and notes
- `report/` - final report
- `images/` - charts and report images

## Environment setup

From the project root, create and activate a virtual environment, then install the recorded packages:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt