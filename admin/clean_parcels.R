# Clean property and zoning data for Class 4

# libraries

library(tidyverse)
library(sf)

parcels <- read_sf("~/Clients/MUSA_Teaching_and_Admin/MUSA_BootCamp_2023/Class_4_2025/DOR_Parcel/DOR_Parcel.shp")
zoning <- read_sf("~/Clients/MUSA_Teaching_and_Admin/MUSA_BootCamp_2023/Class_4_2025/Zoning_BaseDistricts/Zoning_BaseDistricts.shp")

parcels_joined <- st_join(parcels %>%
                            st_centroid(),
                          zoning %>%
                            select(CODE, ZONINGGROU)) %>%
  as.data.frame() %>%
  select(OBJECTID, CODE, ZONINGGROU) %>%
  group_by(OBJECTID) %>%
  slice(1) %>%
  ungroup() %>%
  left_join(., parcels, by = ("OBJECTID" = "OBJECTID")) %>%
  st_as_sf() %>%
  select(OBJECTID, CODE, ZONINGGROU, BASEREG, PARCEL, ADDR_STD)

st_write(parcels_joined, "~/Clients/MUSA_Teaching_and_Admin/MUSA_BootCamp_2023/Class_4_2025/parcels_clean_2025.shp")

# Write out a clean file of the highways for class

national_highways <- st_read("~/Clients/MUSA_Teaching_and_Admin/MUSA_BootCamp_2023/Class_4_2024/Class_4_2021/Class_4_2021/Gettysburg/national_highways.shp")

st_write(national_highways, "~/Clients/MUSA_Teaching_and_Admin/MUSA_BootCamp_2023/Class_4_2025/us_highways.shp")

# Do the same with PA counties

pa_counties <- st_read("~/Clients/MUSA_Teaching_and_Admin/MUSA_BootCamp_2023/Class_4_2024/Class_4_2021/Class_4_2021/Gettysburg/pa_counties.shp")

st_write(pa_counties, "~/Clients/MUSA_Teaching_and_Admin/MUSA_BootCamp_2023/Class_4_2025/counties.shp")
