%%% mangrove ch4 multisite project
%%% starting Aug 2024
%%% read in all LAI data, write out csv's

clear all
close all



%%%%%%% SRS6
%%%read in MODIS data

%%%LAI
modis_LAI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\SRS6\mangrove-multisite-us-Skr-MCD15A2H-061-results.csv','VariableNamingRule','preserve');

%LAI QC screening
temp=modis_LAI.MCD15A2H_061_Lai_500m;

temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_MODLAND);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_CloudState);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Aerosol);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cirrus);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Internal_CloudMask);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cloud_Shadow);
temp = standardizeMissing(temp, 0);

modis_LAI.LAIqc=temp;
clear temp

%make timetable
modis_LAI = timetable(modis_LAI.Date,modis_LAI.LAIqc);
modis_LAI.Properties.VariableNames = {'LAI'};


%%%NDVI
modis_NDVI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\SRS6\mangrove-multisite-us-Skr-MOD13A1-061-results.csv','VariableNamingRule','preserve');

%NDVI QC screening
temp=modis_NDVI.MOD13A1_061__500m_16_days_NDVI;

temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_MODLAND);
%temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Aerosol_Quantity);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Adjacent_cloud_detected);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Atmosphere_BRDF_Correction);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Mixed_Clouds);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Possible_shadow);
temp = standardizeMissing(temp, 0);

modis_NDVI.NDVIqc=temp;
clear temp

%make timetable
modis_NDVI = timetable(modis_NDVI.Date,modis_NDVI.NDVIqc);
modis_NDVI.Properties.VariableNames = {'NDVI'};


%%% join modis data
SRS6_modis = synchronize(modis_LAI,modis_NDVI); 
clear modis_NDVI modis_LAI






%%%%%%% Cauvery
%%%read in MODIS data

%%%LAI
modis_LAI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Cauvery Vellar-Coleroon\Cauvery-Vellar-Coleroon-MCD15A2H-061-results.csv','VariableNamingRule','preserve');

%LAI QC screening
temp=modis_LAI.MCD15A2H_061_Lai_500m;

temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_MODLAND);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_CloudState);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Aerosol);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cirrus);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Internal_CloudMask);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cloud_Shadow);
temp = standardizeMissing(temp, 0);

modis_LAI.LAIqc=temp;
clear temp

%make timetable
modis_LAI = timetable(modis_LAI.Date,modis_LAI.LAIqc);
modis_LAI.Properties.VariableNames = {'LAI'};


%%%NDVI
modis_NDVI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Cauvery Vellar-Coleroon\Cauvery-Vellar-Coleroon-MOD13A1-061-results.csv','VariableNamingRule','preserve');

%NDVI QC screening
temp=modis_NDVI.MOD13A1_061__500m_16_days_NDVI;

temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_MODLAND);
%temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Aerosol_Quantity);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Adjacent_cloud_detected);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Atmosphere_BRDF_Correction);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Mixed_Clouds);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Possible_shadow);
temp = standardizeMissing(temp, 0);

modis_NDVI.NDVIqc=temp;
clear temp

%make timetable
modis_NDVI = timetable(modis_NDVI.Date,modis_NDVI.NDVIqc);
modis_NDVI.Properties.VariableNames = {'NDVI'};


%%% join modis data
Cauvery_modis = synchronize(modis_LAI,modis_NDVI); 
clear modis_NDVI modis_LAI







%%%%%%% HKMPM
%%%read in MODIS data

%%%LAI
modis_LAI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\HK-MPM\HKMPM-MCD15A2H-061-results.csv','VariableNamingRule','preserve');

%LAI QC screening
temp=modis_LAI.MCD15A2H_061_Lai_500m;

temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_MODLAND);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_CloudState);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Aerosol);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cirrus);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Internal_CloudMask);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cloud_Shadow);
temp = standardizeMissing(temp, 0);

modis_LAI.LAIqc=temp;
clear temp

%make timetable
modis_LAI = timetable(modis_LAI.Date,modis_LAI.LAIqc);
modis_LAI.Properties.VariableNames = {'LAI'};


%%%NDVI
modis_NDVI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\HK-MPM\HKMPM-MOD13A1-061-results.csv','VariableNamingRule','preserve');

%NDVI QC screening
temp=modis_NDVI.MOD13A1_061__500m_16_days_NDVI;

temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_MODLAND);
%temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Aerosol_Quantity);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Adjacent_cloud_detected);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Atmosphere_BRDF_Correction);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Mixed_Clouds);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Possible_shadow);
temp = standardizeMissing(temp, 0);

modis_NDVI.NDVIqc=temp;
clear temp

%make timetable
modis_NDVI = timetable(modis_NDVI.Date,modis_NDVI.NDVIqc);
modis_NDVI.Properties.VariableNames = {'NDVI'};


%%% join modis data
HKMPM_modis = synchronize(modis_LAI,modis_NDVI); 
clear modis_NDVI modis_LAI






%%%%%%% Nanji
%%%read in MODIS data

%%%LAI
modis_LAI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Nanji Island\Nanji-3-MCD15A2H-061-results.csv','VariableNamingRule','preserve');

%LAI QC screening
temp=modis_LAI.MCD15A2H_061_Lai_500m;

temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_MODLAND);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_CloudState);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Aerosol);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cirrus);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Internal_CloudMask);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cloud_Shadow);
temp = standardizeMissing(temp, 0);

modis_LAI.LAIqc=temp;
clear temp

%make timetable
modis_LAI = timetable(modis_LAI.Date,modis_LAI.LAIqc);
modis_LAI.Properties.VariableNames = {'LAI'};


%%%NDVI
modis_NDVI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Nanji Island\Nanji-3-MOD13A1-061-results.csv','VariableNamingRule','preserve');

%NDVI QC screening
temp=modis_NDVI.MOD13A1_061__500m_16_days_NDVI;

temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_MODLAND);
%temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Aerosol_Quantity);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Adjacent_cloud_detected);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Atmosphere_BRDF_Correction);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Mixed_Clouds);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Possible_shadow);
temp = standardizeMissing(temp, 0);

modis_NDVI.NDVIqc=temp;
clear temp

%make timetable
modis_NDVI = timetable(modis_NDVI.Date,modis_NDVI.NDVIqc);
modis_NDVI.Properties.VariableNames = {'NDVI'};


%%% join modis data
Nanji_modis = synchronize(modis_LAI,modis_NDVI); 
clear modis_NDVI modis_LAI





%%%%%%% Nansha
%%%read in MODIS data

%%%LAI
modis_LAI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Nansha Wetland Park\Nansha-4-MCD15A2H-061-results.csv','VariableNamingRule','preserve');

%LAI QC screening
temp=modis_LAI.MCD15A2H_061_Lai_500m;

temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_MODLAND);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_CloudState);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Aerosol);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cirrus);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Internal_CloudMask);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cloud_Shadow);
temp = standardizeMissing(temp, 0);

modis_LAI.LAIqc=temp;
clear temp

%make timetable
modis_LAI = timetable(modis_LAI.Date,modis_LAI.LAIqc);
modis_LAI.Properties.VariableNames = {'LAI'};


%%%NDVI
modis_NDVI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Nansha Wetland Park\Nansha-4-MOD13A1-061-results.csv','VariableNamingRule','preserve');

%NDVI QC screening
temp=modis_NDVI.MOD13A1_061__500m_16_days_NDVI;

temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_MODLAND);
%temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Aerosol_Quantity);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Adjacent_cloud_detected);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Atmosphere_BRDF_Correction);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Mixed_Clouds);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Possible_shadow);
temp = standardizeMissing(temp, 0);

modis_NDVI.NDVIqc=temp;
clear temp

%make timetable
modis_NDVI = timetable(modis_NDVI.Date,modis_NDVI.NDVIqc);
modis_NDVI.Properties.VariableNames = {'NDVI'};


%%% join modis data
Nansha_modis = synchronize(modis_LAI,modis_NDVI); 
clear modis_NDVI modis_LAI







%%%%%%% Sundarbans
%%%read in MODIS data

%%%LAI
modis_LAI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Sundarbans\Sundarbans-MCD15A2H-061-results.csv','VariableNamingRule','preserve');

%LAI QC screening
temp=modis_LAI.MCD15A2H_061_Lai_500m;

temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_MODLAND);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_CloudState);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Aerosol);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cirrus);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Internal_CloudMask);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cloud_Shadow);
temp = standardizeMissing(temp, 0);

modis_LAI.LAIqc=temp;
clear temp

%make timetable
modis_LAI = timetable(modis_LAI.Date,modis_LAI.LAIqc);
modis_LAI.Properties.VariableNames = {'LAI'};


%%%NDVI
modis_NDVI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Sundarbans\Sundarbans-MOD13A1-061-results.csv','VariableNamingRule','preserve');

%NDVI QC screening
temp=modis_NDVI.MOD13A1_061__500m_16_days_NDVI;

temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_MODLAND);
%temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Aerosol_Quantity);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Adjacent_cloud_detected);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Atmosphere_BRDF_Correction);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Mixed_Clouds);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Possible_shadow);
temp = standardizeMissing(temp, 0);

modis_NDVI.NDVIqc=temp;
clear temp

%make timetable
modis_NDVI = timetable(modis_NDVI.Date,modis_NDVI.NDVIqc);
modis_NDVI.Properties.VariableNames = {'NDVI'};


%%% join modis data
Sundarbans_modis = synchronize(modis_LAI,modis_NDVI); 
clear modis_NDVI modis_LAI






%%%%%%% Yunxiao
%%%read in MODIS data

%%%LAI
modis_LAI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Yunxiao\Yunxiao-MCD15A2H-061-results.csv','VariableNamingRule','preserve');

%LAI QC screening
temp=modis_LAI.MCD15A2H_061_Lai_500m;

temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_MODLAND);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparLai_QC_CloudState);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Aerosol);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cirrus);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Internal_CloudMask);
temp=temp.*not(modis_LAI.MCD15A2H_061_FparExtra_QC_Cloud_Shadow);
temp = standardizeMissing(temp, 0);

modis_LAI.LAIqc=temp;
clear temp

%make timetable
modis_LAI = timetable(modis_LAI.Date,modis_LAI.LAIqc);
modis_LAI.Properties.VariableNames = {'LAI'};


%%%NDVI
modis_NDVI = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\LAI data\Yunxiao\Yunxiao-MOD13A1-061-results.csv','VariableNamingRule','preserve');

%NDVI QC screening
temp=modis_NDVI.MOD13A1_061__500m_16_days_NDVI;

temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_MODLAND);
%temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Aerosol_Quantity);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Adjacent_cloud_detected);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Atmosphere_BRDF_Correction);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Mixed_Clouds);
temp=temp.*not(modis_NDVI.MOD13A1_061__500m_16_days_VI_Quality_Possible_shadow);
temp = standardizeMissing(temp, 0);

modis_NDVI.NDVIqc=temp;
clear temp

%make timetable
modis_NDVI = timetable(modis_NDVI.Date,modis_NDVI.NDVIqc);
modis_NDVI.Properties.VariableNames = {'NDVI'};


%%% join modis data
Yunxiao_modis = synchronize(modis_LAI,modis_NDVI); 
clear modis_NDVI modis_LAI









%%%%% write out data as CSV files
Cauvery_modis.Time.Format='yyyyMMddHHmm';
HKMPM_modis.Time.Format='yyyyMMddHHmm';
Nansha_modis.Time.Format='yyyyMMddHHmm';
SRS6_modis.Time.Format='yyyyMMddHHmm';
Sundarbans_modis.Time.Format='yyyyMMddHHmm';
Yunxiao_modis.Time.Format='yyyyMMddHHmm';
Nanji_modis.Time.Format='yyyyMMddHHmm';


writetimetable(Cauvery_modis,'MODIS_data_Cauvery.csv')
writetimetable(HKMPM_modis,'MODIS_data_HKMPM.csv')
writetimetable(Nansha_modis,'MODIS_data_Nansha.csv')
writetimetable(SRS6_modis,'MODIS_data_SRS6.csv')
writetimetable(Sundarbans_modis,'MODIS_data_Sundarbans.csv')
writetimetable(Yunxiao_modis,'MODIS_data_Yunxiao.csv')
writetimetable(Nanji_modis,'MODIS_data_Nanji.csv')

