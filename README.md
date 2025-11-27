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

## 📤 Output Description
### **Donnees_climatiques_EWARS-CSD.xlsx**

This Excel file contains **weekly aggregated climate indicators** for all processed sites.  
The following variables are included:

| Variable | Description |
|---------|-------------|
| **localite** | Name of the monitoring site (e.g., Bobo, Sig-Nonghin, Pouytenga) |
| **district** | District code associated with the site |
| **Year** | Observation year |
| **Week** | ISO week number |
| **Pluie_totale** | Total rainfall (mm) during the week |
| **Temperature_Moyenne** | Weekly mean temperature (°C), based on `(TMAX + TMIN)/2` |
| **Humidite_Moyenne** | Weekly mean relative humidity (%), based on `(UMAX + UMIN)/2` |

### Example Output (illustrative)

| Localité     | District | Année | Semaine | Pluie Totale | Température Moyenne | Humidité Moyenne |
|--------------|----------|--------|---------|---------------|----------------------|-------------------|
| Bobo         | 9121     | 2025   | 12      | 14.2 mm       | 28.4°C               | 63 %              |
| Sig-Nonghin  | 7141     | 2025   | 12      | 9.1 mm        | 29.8°C               | 57 %              |
| Pouytenga    | 4221     | 2025   | 12      | 11.0 mm       | 27.5°C               | 61 %              |

This file is directly usable for climate surveillance, early warning systems, reporting, and statistical analysis.

## 📝 Author

**Adaman YODA**  
National Meteorological Agency of Burkina Faso  
PhD Candidate – West Africa Climate System (FUTA, Nigeria)
