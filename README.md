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

**01_makeALLFLUX_CO2model.m**
Reads in Flux data, ERA5 data, and MODIS data for both SRS6 and HKMPM sites
Gapfills flux data (TA, TS, SW_IN, P, WS, TURB, NetRad) with ERA5 data, or uses ERA5 data is Flux data is missing that varaible
Creates 30 day moving sum of P
Creates Random Forest model of NEE with inputs of TS, SW_IN, and NDVI
Writes out RF model and RF_input data

**01_makeHKMPM_CO2model.m**
Reads in Flux data, ERA5 data, and MODIS data for HKMPM site
Gapfills flux data (TA, TS, SW_IN, P, WS, TURB, NetRad) with ERA5 data, or uses ERA5 data is Flux data is missing that varaible
Creates 30 day moving sum of P
Creates Random Forest model of NEE with inputs of TS, SW_IN, and NDVI
Writes out RF model and RF_input data

**01_makeSRS6_CO2model.m**
Reads in Flux data, ERA5 data, and MODIS data for SRS6 site
Gapfills flux data (TA, TS, SW_IN, P, WS, TURB, NetRad) with ERA5 data, or uses ERA5 data is Flux data is missing that varaible
Creates 30 day moving sum of P
Creates Random Forest model of NEE with inputs of TS, SW_IN, and NDVI
Writes out RF model and RF_input data

**02_HKMPM_CO2gapfill.m**
Reads in Flux data, ERA5 data, MODIS data, and RF model for HKMPM site
Models NEE, then gapfills NEE data
Writes out NEE gapfilled data

**02_SRS6_CO2gapfill.m**
Reads in Flux data, ERA5 data, MODIS data, and RF model for SRS6 site
Models NEE, then gapfills NEE data
Writes out NEE gapfilled data

**03_makeALLFLUX_CH4model_PLACEHOLDER.txt**

**03_makeHKMPM_CH4model.m**
Reads in Flux data, ERA5 data, and MODIS data for HKMPM site
Gapfills flux data (TA, TS, SW_IN, P, WS, TURB, NetRad) with ERA5 data, or uses ERA5 data is Flux data is missing that varaible
Creates 30 day moving sum of P
Creates Day of Year variable
Creates Random Forest model of NEE with inputs of NEE, TA, Turb, VPD, NetRad, DOY, NDVI, P
Writes out RF model and RF_input data

**03_makeSRS6_CH4model.m**
Reads in Flux data, ERA5 data, and MODIS data for SRS6 site
Gapfills flux data (TA, TS, SW_IN, P, WS, TURB, NetRad) with ERA5 data, or uses ERA5 data is Flux data is missing that varaible
Creates 30 day moving sum of P
Creates Day of Year variable
Creates Random Forest model of NEE with inputs of NEE, TA, Turb, VPD, NetRad, DOY, NDVI, P
Writes out RF model and RF_input data

**04_HKMPM_CH4gapfill.m**
Reads in Flux data, ERA5 data, MODIS data, and RF model for HKMPM site
Models CH4, then gapfills CH4 data
Writes out CH4 gapfilled data

**04_SRS6_CH4gapfill.m**
Reads in Flux data, ERA5 data, MODIS data, and RF model for SRS6 site
Models CH4, then gapfills CH4 data
Writes out CH4 gapfilled data
