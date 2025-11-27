# 📘 Climate Data Processing Script (R)

This repository contains an R script designed to **read, clean, merge, summarize, and export weekly climate data** from multiple monitoring sites in Burkina Faso.  
It automates the processing of CSV files containing daily meteorological observations and produces a consolidated **Excel file** compatible with EWARS-CSD workflows.

## 🚀 Features

### ✔️ Multi-file CSV import  
Reads and merges multiple CSV files from different stations (Bobo, Boulbi, Koupéla).

### ✔️ Automatic date parsing  
Handles multiple date formats:
```
"%m/%d/%Y", "%m/%d/%y"
```

### ✔️ Weekly mapping  
Automatically joins each date to its corresponding **week number** using an external lookup file.

### ✔️ Cleaning and filtering  
- Removes the `Time` column  
- Standardizes decimal and column delimiters  
- Converts numeric columns  
- Removes rows with too many missing values  
- Keeps only weeks containing at least **5 valid days**

### ✔️ Aggregation  
Generates weekly summaries for each site:  
- Total rainfall  
- Mean temperature (from TMAX and TMIN)  
- Mean humidity (from UMAX and UMIN)

### ✔️ Export  
Outputs the cleaned and summarized dataset in:  
👉 **`Donnees_climatiques_EWARS-CSD.xlsx`**

## 📁 Project Structure

```
📦 project/
 ├── data/
 │    ├── Bobo/
 │    ├── Boulbi/
 │    └── Koupela/
 ├── dates_semaines_2025.txt
 ├── script.R
 └── README.md
```

## 🛠️ Dependencies

```r
install.packages(c("tidyverse", "writexl", "lubridate"))
```

## ▶️ How to Run

```r
source("script.R")
```

## 📤 Output

**Donnees_climatiques_EWARS-CSD.xlsx** — weekly rainfall, temperature, and humidity summaries.

## 📝 Author

**Adaman YODA**  
National Meteorological Agency of Burkina Faso  
PhD Candidate – West Africa Climate System (FUTA, Nigeria)
