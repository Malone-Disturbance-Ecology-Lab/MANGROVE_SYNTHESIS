# MANGROVE_SYNTHESIS

**00_ERA5data.m**
ERA data must be downloaded for each site.
Reads in the following ERA5 data: 2m air temp, 2m dew point temp, 0 - 7cm soil temp, SW_IN, SW_Tot, LW_Tot, 10m u-component of wind, 10m v-component of wind, 10m wind gust since previous post-processing (proxy for turblance), and total precip.
Calculates  VPD, Wind Speed, NetRad
Writes out timetables for each site.

**00_MODISdata.m**
MODIS data must be downloaded for each site.
Reads in the following MODIS data: 500m LAI, 500m NDVI
Apply LAI data QAQC checks for MODLAND, CloudState, Aerosol, Cirrus, Internal_CloudMask, and Cloud_Shadow
Apply NDVI data QAQC checks for MODLAND, Adjacent_cloud_detected, Atmosphere_BRDF_Correction, Mixed_Clouds, and Possible_shadow
Writes out timetables for each site.

**00_MODISdata.m**
Reads in AmeriFLux data for SRS6, FLUXNET data for HKMPM
At SRS6:
Calculate CO2 NEE (FC+SC) and CH4 NEE (FCH4+SCH4)
Filter NEE >100 and <-100
Apply USTAR filtering for SRS6 data following Pastorello, G. et al (2020) and Barr, A. G. et al. (2013)
Writes out timetables for each site
