# DOWNLOAD ERA5 Data:

library(ecmwfr)

cds.key <- "82b7992e-8570-4518-a47d-eb405d930849"
wf_set_key(user = "6cc5d6f2-61b9-4a15-b657-f7ca1dc70c87", key = cds.key)

request <- list(
  dataset_short_name = "reanalysis-era5-single-levels",
  product_type   = "reanalysis",
  format = "netcdf",
  variable = "2m_temperature",
  year = '2016',
  month = '01',
  day = "1",
  time = c("00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"),
  # area is specified as N, W, S, E
  area = c(50, -20, 30, 20),
  target = "Temperature_2m_e5_single.nc")

file <- wf_request(user = "6cc5d6f2-61b9-4a15-b657-f7ca1dc70c87",
                   request = request,
                   transfer = TRUE,
                   path ='/Volumes/MaloneLab/Research/Mangrove_Synthesis/ERA5_GRIB',
                   verbose = TRUE)

library(terra)
library(raster)

test <- raster("download_e5_single.nc")

plot(test[[1]])
