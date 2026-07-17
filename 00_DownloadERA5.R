# DOWNLOAD ERA5 Data for all current mangrove towers
# Pulls reanalysis-era5-single-levels for every site in Site_Information.csv,
# covering the site's true flux-record span (see Master_Tower_Table.csv) --
# not just "extend forward from what we already have". Two sites need real
# backfill, not just an extension:
#   - Aojiang: local ERA5 record starts 2020, but the Xu et al. CO2 record
#     (downloaded to External_FluxData/Xu2024_Aojiang) goes back to 2017.
#   - Yunxiao: local ERA5 record covers 2019-2020, but the only published
#     flux record we've located (Lu et al. 2024, site code "YX") is 2009-2012
#     -- those two windows do not overlap at all.
# Both gaps and any forward extension to the present are computed from what
# already exists in ERA_Site_DATA, so re-running this script is idempotent.
#
# Variables match what 00_ERA5data.m expects to find in each GRIB:
# 2T, 2D, ST (soil temp lvl 1), SSRD, SSR, STR, 10U, 10V, wind gust, TP.

library(ecmwfr)
library(tidyverse)

# --- Credentials --------------------------------------------------------
# Set these in your ~/.Renviron (CDS_API_UID=..., CDS_API_KEY=...) rather
# than hardcoding them here. The key previously committed in this file
# should be treated as compromised (it has been sitting in tracked source)
# and rotated at https://cds.climate.copernicus.eu/profile.
cds_uid <- Sys.getenv("CDS_API_UID")
cds_key <- Sys.getenv("CDS_API_KEY")
if (cds_uid == "" || cds_key == "") {
  stop("Set CDS_API_UID and CDS_API_KEY in ~/.Renviron before running this script.")
}
wf_set_key(user = cds_uid, key = cds_key)

# --- Paths ---------------------------------------------------------------
site_info_path <- '/Volumes/MaloneLab/Research/Mangrove_Synthesis/Site_Information/Site_Information.csv'
era5_grib_dir  <- '/Volumes/MaloneLab/Research/Mangrove_Synthesis/ERA5_GRIB'
era5_site_dir  <- '/Volumes/MaloneLab/Research/Mangrove_Synthesis/ERA_Site_DATA'

sites <- read.csv(site_info_path, fileEncoding = "latin1")

# --- ERA5 variables (single levels) --------------------------------------
era5_variables <- c(
  "2m_temperature",
  "2m_dewpoint_temperature",
  "soil_temperature_level_1",
  "surface_solar_radiation_downwards",
  "surface_net_solar_radiation",
  "surface_net_thermal_radiation",
  "10m_u_component_of_wind",
  "10m_v_component_of_wind",
  "10m_wind_gust_since_previous_post_processing",
  "total_precipitation"
)

all_hours <- sprintf("%02d:00", 0:23)
all_days  <- sprintf("%02d", 1:31)   # CDS ignores invalid day/month combos
buffer_deg <- 0.25                    # small box around each tower

# ERA5 (final, QC'd product) trails real time by ~2-3 months; ERA5T
# (preliminary) fills the gap but can still be revised. Stop at the last
# fully-elapsed month minus a 2-month lag to stay on the finalized product.
latest_available_date <- floor_date(Sys.Date() %m-% months(2), "month") - 1

# --- Known start of each site's real flux record (from Master_Tower_Table.csv) --
# Falls back to "just extend what we already have" for any site not listed here.
flux_record_start_year <- c(
  SRS6       = 2017,
  HKMPM      = 2016,
  Yunxiao    = 2009,   # backfill: published flux (Lu et al. 2024) predates our ERA5
  Nansha     = 2019,
  Cauvery    = 2017,
  Sundarbans = 2012,
  Aojiang    = 2017,   # backfill: Xu et al. 2025 extended CO2 record starts 2017
  Nanji      = 2020    # matches the CO2 EC study period found at these coords
)

# --- Figure out which years of a site's ERA5 record already exist ---------
covered_years <- function(site_name) {
  f <- file.path(era5_site_dir, paste0("ERA5_data_", site_name, ".csv"))
  if (!file.exists(f)) return(integer(0))
  d <- read.csv(f)
  dates <- as.Date(as.character(d[[1]]), format = "%Y%m%d%H%M")
  seq(min(as.integer(format(dates, "%Y")), na.rm = TRUE),
      max(as.integer(format(dates, "%Y")), na.rm = TRUE))
}

# --- Submit one request per site per missing year (backfill + forward) ----
for (i in seq_len(nrow(sites))) {

  site_name <- sites$Site[i]

  lat <- sites$Latitude[i]
  lon <- sites$Longitude[i]
  area <- c(lat + buffer_deg, lon - buffer_deg, lat - buffer_deg, lon + buffer_deg)

  end_year <- as.integer(format(latest_available_date, "%Y"))
  record_start <- if (site_name %in% names(flux_record_start_year)) {
    flux_record_start_year[[site_name]]
  } else {
    end_year - 1  # unknown record: just extend what we have by a year
  }

  have_years <- covered_years(site_name)
  need_years <- setdiff(record_start:end_year, have_years)

  if (length(need_years) == 0) {
    message(site_name, ": already fully covered ", record_start, "-", end_year)
    next
  }

  message(site_name, ": requesting ", length(need_years), " missing year(s) -- ",
          paste(need_years, collapse = ", "))

  for (yr in need_years) {

    months_in_year <- if (yr == end_year) {
      sprintf("%02d", 1:as.integer(format(latest_available_date, "%m")))
    } else {
      sprintf("%02d", 1:12)
    }

    out_dir <- file.path(era5_grib_dir, site_name, yr)
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
    target_name <- paste0(site_name, "_", yr, "_era5.grib")

    request <- list(
      dataset_short_name = "reanalysis-era5-single-levels",
      product_type = "reanalysis",
      format = "grib",
      variable = era5_variables,
      year = as.character(yr),
      month = months_in_year,
      day = all_days,
      time = all_hours,
      area = area,               # N, W, S, E
      target = target_name
    )

    tryCatch({
      wf_request(
        user = cds_uid,
        request = request,
        transfer = TRUE,
        path = out_dir,
        verbose = TRUE
      )
    }, error = function(e) {
      message("  FAILED for ", site_name, " ", yr, ": ", conditionMessage(e))
    })
  }
}
