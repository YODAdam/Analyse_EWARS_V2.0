library(tidyverse)
library(writexl)




# 

read_func <- function(list_file) { 
  d1 <- read_delim(file = list_file[1], delim = ";", locale = locale(decimal_mark = ",", encoding = "Latin1", date_format = "%d/%m/%y")) %>% 
    select(!Time)
  
  for (file in list_file[2:length(list_file)] ) {
    data <- read_delim(file = file, delim = ";", locale = locale(decimal_mark = ",", encoding = "Latin1", date_format = "%d/%m/%y")) %>% 
      select(!Time)
    d1 <- d1 %>% 
      left_join(data)
  }
  
  # data <- data %>% 
  #   select(Date, Pluie, TMAX, TMIN,UMAX, UMIN)
  
  return(d1)
}


## Reading Bobo_Data

list_file <- list.files(path = "data/Bobo/", full.names = TRUE)


Bobo_data <- read_func(list_file = list_file)
Bobo_data <- Bobo_data %>% 
  mutate(
    localite = "DO",
    district = 9121
  )


## Reading Ouagadata

list_file <- list.files(path = "data/Boulbi/", full.names = TRUE)


Boulbi_data <- read_func(list_file = list_file)
Boulbi_data <- Boulbi_data %>% 
  mutate(
    localite = "Sig-Nonghin",
    district = 7141
  )



## Reading Koupela

list_file <- list.files(path = "data/Koupela/", full.names = TRUE)


Koupela_data <- read_func(list_file = list_file)
Koupela_data <- Koupela_data %>% 
  mutate(
    localite = "Pouytenga",
    district = 4221
  )


All_data <- bind_rows(Bobo_data, Boulbi_data, Koupela_data) %>% 
  mutate(Week = epiweek(x = Date),
         Tmean = (TMAX + TMIN) /2 ,
         Umean = (UMAX + UMIN) /2,
         Year = year(x = Date)
         ) %>% 
  select(!Week)


week_data <- read_delim(file = "dates_semaines_2025.txt") %>% 
  rename(Week = Semaine)

All_data <- All_data %>% 
  left_join(week_data)

summary_data <- All_data %>% 
  group_by(localite, district, Year, Week) %>% 
  summarise(
    Pluie = sum(Pluie), 
    Temperature_Moyenne = mean(Tmean),
    Humidite_Moyenne = mean(Umean)
  )


write_xlsx(x = summary_data, path = "Donnees_climatiques_EWARS-CSD.xlsx")
