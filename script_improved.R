# 📚 Chargement des packages ----

library(tidyverse)  # Pour data manipulation (readr, dplyr, etc.)
library(writexl)    # Pour l'écriture Excel


file_date_format <- c("%m/%d/%Y", "%m/%d/%y") ## prise en charge de plusieurs formats.
decimal_delim <-  "."
column_sep <- ";"



# ================================
### 🚩 4️⃣ Jointure avec fichier des semaines  -----
# ================================

# Lire le fichier des correspondances semaine-date
week_dates <- read_delim("dates_semaines_2025.txt") %>% 
  rename(Week = Semaine)


# ================================
# 🚩 1️⃣ Fonction pour lire et fusionner plusieurs fichiers CSV ----
# ================================

# Cette fonction lit une liste de fichiers CSV avec le même format
# et les fusionne en faisant un LEFT JOIN sur la colonne Date.
# Elle enlève aussi la colonne Time.

read_and_merge_files <- function(file_list) { 
  
  # Lire le premier fichier
  
  merged_data <- read_delim(
    file = file_list[1], 
    delim = column_sep, 
    locale = locale(decimal_mark = decimal_delim, encoding = "Latin1"),
    col_types = cols(Date = col_character())
  ) %>% 
    mutate(
      Date = parse_date_time(Date, orders = file_date_format) %>% as_date()
    ) %>% 
    select(-Time)
  
  merged_data <- week_dates %>% 
    left_join(merged_data, by = "Date")
  
  # Boucle pour fusionner les autres fichiers (s'il y en a)
  
  for (file in file_list[-1]) {
    temp_data <- read_delim(
      file = file, 
      delim = column_sep, 
      locale = locale(decimal_mark = decimal_delim, encoding = "Latin1"),
      col_types = cols(Date = col_character())
    ) %>% 
      mutate(
        Date = parse_date_time(Date, orders = file_date_format) %>% as_date()
      ) %>% 
      select(-Time)
    
    merged_data <- merged_data %>% 
      left_join(temp_data, by = "Date") %>% 
      mutate(across(!c(Date, Week), as.numeric)) %>% 
      rowwise() %>% 
      mutate(N_missing = sum(is.na(c_across(!c(Date, Week))))) %>% 
      filter(N_missing != 5) %>% 
      select(!N_missing) %>% 
      ungroup()
  }
  

  
  return(merged_data)
}

# ================================
# 🚩 2️⃣ Lecture des données par site ----
# ================================

# 📍 Bobo-Dioulasso

bobo_files <- list.files(path = "data/Bobo/", full.names = TRUE)
bobo_data <- read_and_merge_files(bobo_files) %>% 
  mutate(
    localite = "DO",
    district = 9121
  )


# 📍 Boulbi / Sig-Nonghin
boulbi_files <- list.files(path = "data/Boulbi/", full.names = TRUE)
boulbi_data <- read_and_merge_files(boulbi_files) %>% 
  mutate(
    localite = "Sig-Nonghin",
    district = 7141
  )


# 📍 Koupela / Pouytenga
koupela_files <- list.files(path = "data/Koupela/", full.names = TRUE)
koupela_data <- read_and_merge_files(koupela_files) %>% 
  mutate(
    localite = "Pouytenga",
    district = 4221
  )


# ================================
### 🚩 3️⃣ Fusionner toutes les localités --------
# ================================


all_data <- bind_rows(bobo_data, boulbi_data, koupela_data) %>% 
  mutate(
    Tmean = (TMAX + TMIN) / 2,
    Umean = (UMAX + UMIN) / 2,
    Year = year(Date)
  )


n_days_perweek <- all_data %>% 
  group_by(localite,  Year, Week) %>% 
  summarise(
    N_days = n()
  )


all_data <-  all_data %>% 
  left_join(n_days_perweek) %>% 
  filter(N_days >= 5)

#all_data <- all_data %>% 
#  left_join(week_dates, by = c("Date", "Week"))

# ================================
### 🚩 5️⃣ Résumer par localité, district, année, semaine ----
# ================================

summary_data <- all_data %>% 
  group_by(localite, district, Year, Week) %>% 
  summarise(
    Pluie_totale = sum(Pluie, na.rm = TRUE),
    Temperature_Moyenne = mean(Tmean, na.rm = TRUE),
    Humidite_Moyenne = mean(Umean, na.rm = TRUE),
    .groups = "drop"
  )

# ================================
### 🚩 6️⃣ Export vers Excel ----
# ================================

write_xlsx(summary_data, path = "Donnees_climatiques_EWARS-CSD.xlsx")

### ✅ Fin du script   ----
