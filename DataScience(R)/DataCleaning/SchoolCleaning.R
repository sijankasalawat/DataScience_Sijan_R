library(tidyverse)
library(dplyr)
library(stringi)
library(scales)
library(data.table)


setwd("D:/DataScienceAssignment")


School_2017_2018 = fread("Datasets/School_2017-2018/2017-2018/england_ks4final.csv",fill=TRUE) %>% 
  mutate(Year = 2017) %>% 
  select( Year,PCODE,SCHNAME, ATT8SCR,) %>%  
  na.omit() %>% 
  distinct()

School_2018_2019 = fread("Datasets/School_2018-2019/2018-2019/england_ks4final.csv",fill=TRUE) %>% 
  mutate(Year = 2018) %>% 
  select( Year,PCODE,SCHNAME, ATT8SCR,) %>% 
  na.omit() %>% 
  distinct()

School_2019_2020 = fread("Datasets/School_2018-2019/2018-2019/england_ks4final.csv",fill=TRUE) %>% 
  mutate(Year = 2019) %>% 
  select( Year,PCODE,SCHNAME, ATT8SCR,) %>% 
  na.omit() %>% 
  distinct()



School_2021_2022 = fread("Datasets/School_2021-2022/2021-2022/england_ks4final.csv",fill=TRUE) %>% 
  mutate(Year = 2021) %>% 
  select( Year,PCODE,SCHNAME, ATT8SCR,) %>% 
  na.omit() %>% 
  distinct()

School_2022_2023 = fread("Datasets/School_2021-2022/2021-2022/england_ks4final.csv",fill=TRUE) %>% 
  mutate(Year = 2022) %>% 
  select( Year,PCODE,SCHNAME, ATT8SCR,) %>% 
  na.omit() %>% 
  distinct()


SchoolData = rbind(School_2017_2018,School_2018_2019,School_2019_2020,School_2021_2022,School_2022_2023)
write.csv(SchoolData, "D:/DataScienceAssignment/Cleaned Datasets/Combined_School_Data.csv",row.names = FALSE)


pattern = ' .*$'

CleanedSchoolData = SchoolData %>% 
  mutate(ID = row_number()) %>% 
  mutate(shortPostcode=gsub(pattern,"",PCODE)) %>%
  filter (ATT8SCR != "NE" & ATT8SCR != "SUPP") %>% 
  filter(ATT8SCR !=""& shortPostcode!=""& PCODE!="") %>% 
  select( ID,Year,PCODE,shortPostcode,SCHNAME, ATT8SCR,) %>% 
  na.omit() %>% 
  distinct()
View(CleanedSchoolData)

colnames(CleanedSchoolData) = c("ID", "Year", "PostCode", "shortPostcode", "SchoolName", "Attainment8Score")

write.csv(CleanedSchoolData, "D:/DataScienceAssignment/Cleaned Datasets/Cleaned_School_Data.csv",row.names = FALSE)


Post=read.csv("D:/DataScienceAssignment/Cleaned Datasets/Combined_House_Pricing_2019-2022.csv") %>% 
  select(PostCode,County) %>% 
  mutate(shortPostcode=gsub(pattern,"",PostCode)) %>% 
  select(County,shortPostcode)

# School data cleaning seperatly for OXFORDSHIRE and YORKSHIRE

OXFORSSHIRESchoolData = CleanedSchoolData %>% 
  left_join(Post,by = "shortPostcode") %>% 
  select(Year, PostCode, shortPostcode, SchoolName, Attainment8Score,County) %>% 
  filter(County=="OXFORDSHIRE") %>% 
  na.omit() %>% 
  distinct() %>% 
  mutate(ID = row_number()) %>% 
  select(ID,Year, PostCode, shortPostcode, SchoolName, Attainment8Score)

write.csv(OXFORSSHIRESchoolData, "D:/DataScienceAssignment/Cleaned datasets/OXFORSSHIRESchoolData.CSV",row.names = FALSE) 

YORKSHIRESchoolData = CleanedSchoolData %>% 
  left_join(Post,by = "shortPostcode") %>% 
  select(Year, PostCode, shortPostcode, SchoolName, Attainment8Score,County) %>% 
  filter(County=="YORK" | County=="WEST YORKSHIRE" | County=="SOUTH YORKSHIRE" | County=="NORTH YORKSHIRE") %>% 
  na.omit() %>% 
  distinct() %>% 
  mutate(ID = row_number()) %>% 
  select(ID,Year, PostCode, shortPostcode, SchoolName, Attainment8Score)

View(YORKSHIRESchoolData)

write.csv(YORKSHIRESchoolData, "D:/DataScienceAssignment/Cleaned datasets/YORKSHIRESchoolData.CSV",row.names = FALSE) 

