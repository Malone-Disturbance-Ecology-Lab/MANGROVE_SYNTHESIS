%%% mangrove ch4 multisite project
%%% starting Aug 2024
%%% read in all ERA5 data, write out csv's

clear all
close all



%%%%% SRS6 ERA5 data
%%% manually request and download ERA5 data for site
%%% data: 2m dewpoint temperature, 2m temperature, Surface pressure, Total precipitation, Surface net solar radiation, Surface solar radiation downwards, Soil temperature level 1


%%% read in ERA5 metadata
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2017\352966e320f67d7d9648a7d3bfe166f6.grib');
metadata2017 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2018\d1ccbcdbcf6a35e8e22ec2ad44e2b72f.grib');
metadata2018 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2019\27ea93bc8407a596a1305641d1c3aa09.grib');
metadata2019 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2020\b6407fa0f8a4a86669f18294551b4261.grib');
metadata2020 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2021\43d603bfd791d42dcf79c56b87e70342.grib');
metadata2021 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2022\84f750cb92c4cb83a5ca9bd0d5e37938.grib');
metadata2022 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2023\97fabfdedd6496e23c277e883ce85bf4.grib');
metadata2023 = info.Metadata;

metadata = [metadata2017;metadata2018;metadata2019;metadata2020;metadata2021;metadata2022;metadata2023];
clear info metadata2017 metadata2018 metadata2019 metadata2020 metadata2021 metadata2022 metadata2023


%%% read in ERA5 data
[ERA5_2017] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2017\352966e320f67d7d9648a7d3bfe166f6.grib');
[ERA5_2018] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2018\d1ccbcdbcf6a35e8e22ec2ad44e2b72f.grib');
[ERA5_2019] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2019\27ea93bc8407a596a1305641d1c3aa09.grib');
[ERA5_2020] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2020\b6407fa0f8a4a86669f18294551b4261.grib');
[ERA5_2021] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2021\43d603bfd791d42dcf79c56b87e70342.grib');
[ERA5_2022] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2022\84f750cb92c4cb83a5ca9bd0d5e37938.grib');
[ERA5_2023] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\SRS6\2023\97fabfdedd6496e23c277e883ce85bf4.grib');

ERA5_data = cat(3,ERA5_2017,ERA5_2018,ERA5_2019,ERA5_2020,ERA5_2021,ERA5_2022, ERA5_2023);
clear ERA5_2017 ERA5_2018 ERA5_2019 ERA5_2020 ERA5_2021 ERA5_2022 ERA5_2023


%%% grab data from ERA file
vars = string(metadata.Element);

% grab 2T data (2m air temp)
band = find(vars == '2T');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2T(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2T_tt = timetable(dates,ERA5_2T);
clear A bands dates ERA5_2T


% grab 2D data (2m dew point temp)
band = find(vars == '2D');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2D(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2D_tt = timetable(dates,ERA5_2D);
clear A bands dates ERA5_2D


% grab ST data (0 - 7cm soil temp)
band = find(vars == 'ST');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_ST(1:length(A),1) = A(1,1,:)-273.15;
ERA5_ST_tt = timetable(dates,ERA5_ST);
clear A bands dates ERA5_ST


% grab SSRD data (Surface solar radition downward (SW_IN))
band = find(vars == 'SSRD');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_IN(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_IN_tt = timetable(dates,ERA5_SW_IN);
clear A bands dates ERA5_SW_IN


% grab SSR data (Surface solar radition downward (SW_Tot))
band = find(vars == 'SSR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_Tot_tt = timetable(dates,ERA5_SW_Tot);
clear A bands dates ERA5_SW_Tot

% grab STS data (Surface thermal radition downward (LW_Tot))
band = find(vars == 'STR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_LW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_LW_Tot_tt = timetable(dates,ERA5_LW_Tot);
clear A bands dates ERA5_LW_Tot

% grab wind data (10m u-component of wind)
band = find(vars == '10U');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10U(1:length(A),1) = A(1,1,:);
ERA5_10U_tt = timetable(dates,ERA5_10U);
clear A bands dates ERA5_10U

% grab wind data (10m v-component of wind)
band = find(vars == '10V');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10V(1:length(A),1) = A(1,1,:);
ERA5_10V_tt = timetable(dates,ERA5_10V);
clear A bands dates ERA5_10V

% grab wind gust data, proxy for turbulence (10m wind gust since previous post-processing)
band = find(vars == 'var49 of table 128 of center ECMWF');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_Turb(1:length(A),1) = A(1,1,:);
ERA5_Turb_tt = timetable(dates,ERA5_Turb);
clear A bands dates ERA5_Turb

% grab TP data (total precip)
band = find(vars == 'TP');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_TP(1:length(A),1) = A(1,1,:)*1000; %convert m to mm
ERA5_TP_tt = timetable(dates,ERA5_TP);
clear A bands dates ERA5_TP


%join timetables
ERA5_data = synchronize(ERA5_2T_tt,ERA5_2D_tt,ERA5_ST_tt,ERA5_10U_tt,ERA5_10V_tt,ERA5_Turb_tt,ERA5_SW_IN_tt,ERA5_SW_Tot_tt,ERA5_LW_Tot_tt,ERA5_TP_tt);
clear ERA5_2T_tt ERA5_2D_tt ERA5_ST_tt ERA5_SW_IN_tt ERA5_TP_tt ERA5_10U_tt ERA5_10V_tt ERA5_Turb_tt ERA5_SW_Tot_tt ERA5_LW_Tot_tt
clear band dates metadata vars



%%% calculate VPD
ERA5_data.ERA5_RH=100-(5.*(ERA5_data.ERA5_2T-ERA5_data.ERA5_2D));
ERA5_data.ERA5_VPD = (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))) - ((ERA5_data.ERA5_RH/100).* (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))));

%%% calculate WS
ERA5_data.ERA5_WS = sqrt(ERA5_data.ERA5_10U.^2 + ERA5_data.ERA5_10V.^2);

%%% calcuate NetRad
ERA5_data.ERA5_NetRad = ERA5_data.ERA5_SW_Tot + ERA5_data.ERA5_LW_Tot;

%clean up dew point temp, rh, u-wind, v-wind, solarRad, thermalRad
ERA5_data.ERA5_2D=[];
ERA5_data.ERA5_RH=[];
ERA5_data.ERA5_10U =[];
ERA5_data.ERA5_10V =[];
ERA5_data.ERA5_SW_Tot =[];
ERA5_data.ERA5_LW_Tot =[];


%%%% save data to site specific data
ERA5_data_SRS6 = ERA5_data;
clear ERA5_data








%%%%% HKMPM ERA5 data
%%% manually request and download ERA5 data for site
%%% data: 2m dewpoint temperature, 2m temperature, Surface pressure, Total precipitation, Surface net solar radiation, Surface solar radiation downwards, Soil temperature level 1


%%% read in ERA5 metadata
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\HK-MPM\2016\43ab22fea1ef4a79a41351667edf98d1.grib');
metadata2016 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\HK-MPM\2017\f48a1ece0196df859b5a11c961f3b917.grib');
metadata2017 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\HK-MPM\2018\d33d9784e86d5919f5ef95201df70a51.grib');
metadata2018 = info.Metadata;


metadata = [metadata2016;metadata2017;metadata2018];
clear info metadata2016 metadata2017 metadata2018 info

%%% read in ERA5 data
[ERA5_2016] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\HK-MPM\2016\43ab22fea1ef4a79a41351667edf98d1.grib');
[ERA5_2017] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\HK-MPM\2017\f48a1ece0196df859b5a11c961f3b917.grib');
[ERA5_2018] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\HK-MPM\2018\d33d9784e86d5919f5ef95201df70a51.grib');


ERA5_data = cat(3,ERA5_2016,ERA5_2017,ERA5_2018);
clear ERA5_2016 ERA5_2017 ERA5_2018


%%% grab data from ERA file
vars = string(metadata.Element);

% grab 2T data (2m air temp)
band = find(vars == '2T');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2T(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2T_tt = timetable(dates,ERA5_2T);
clear A bands dates ERA5_2T


% grab 2D data (2m dew point temp)
band = find(vars == '2D');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2D(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2D_tt = timetable(dates,ERA5_2D);
clear A bands dates ERA5_2D


% grab ST data (0 - 7cm soil temp)
band = find(vars == 'ST');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_ST(1:length(A),1) = A(1,1,:)-273.15;
ERA5_ST_tt = timetable(dates,ERA5_ST);
clear A bands dates ERA5_ST


% grab SSRD data (Surface solar radition downward (SW_IN))
band = find(vars == 'SSRD');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_IN(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_IN_tt = timetable(dates,ERA5_SW_IN);
clear A bands dates ERA5_SW_IN


% grab SSR data (Surface solar radition downward (SW_Tot))
band = find(vars == 'SSR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_Tot_tt = timetable(dates,ERA5_SW_Tot);
clear A bands dates ERA5_SW_Tot

% grab STS data (Surface thermal radition downward (LW_Tot))
band = find(vars == 'STR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_LW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_LW_Tot_tt = timetable(dates,ERA5_LW_Tot);
clear A bands dates ERA5_LW_Tot

% grab wind data (10m u-component of wind)
band = find(vars == '10U');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10U(1:length(A),1) = A(1,1,:);
ERA5_10U_tt = timetable(dates,ERA5_10U);
clear A bands dates ERA5_10U

% grab wind data (10m v-component of wind)
band = find(vars == '10V');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10V(1:length(A),1) = A(1,1,:);
ERA5_10V_tt = timetable(dates,ERA5_10V);
clear A bands dates ERA5_10V

% grab wind gust data, proxy for turbulence (10m wind gust since previous post-processing)
band = find(vars == 'var49 of table 128 of center ECMWF');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_Turb(1:length(A),1) = A(1,1,:);
ERA5_Turb_tt = timetable(dates,ERA5_Turb);
clear A bands dates ERA5_Turb

% grab TP data (total precip)
band = find(vars == 'TP');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_TP(1:length(A),1) = A(1,1,:)*1000; %convert m to mm
ERA5_TP_tt = timetable(dates,ERA5_TP);
clear A bands dates ERA5_TP


%join timetables
ERA5_data = synchronize(ERA5_2T_tt,ERA5_2D_tt,ERA5_ST_tt,ERA5_10U_tt,ERA5_10V_tt,ERA5_Turb_tt,ERA5_SW_IN_tt,ERA5_SW_Tot_tt,ERA5_LW_Tot_tt,ERA5_TP_tt);
clear ERA5_2T_tt ERA5_2D_tt ERA5_ST_tt ERA5_SW_IN_tt ERA5_TP_tt ERA5_10U_tt ERA5_10V_tt ERA5_Turb_tt ERA5_SW_Tot_tt ERA5_LW_Tot_tt
clear band dates metadata vars



%%% calculate VPD
ERA5_data.ERA5_RH=100-(5.*(ERA5_data.ERA5_2T-ERA5_data.ERA5_2D));
ERA5_data.ERA5_VPD = (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))) - ((ERA5_data.ERA5_RH/100).* (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))));

%%% calculate WS
ERA5_data.ERA5_WS = sqrt(ERA5_data.ERA5_10U.^2 + ERA5_data.ERA5_10V.^2);

%%% calcuate NetRad
ERA5_data.ERA5_NetRad = ERA5_data.ERA5_SW_Tot + ERA5_data.ERA5_LW_Tot;

%clean up dew point temp, rh, u-wind, v-wind, solarRad, thermalRad
ERA5_data.ERA5_2D=[];
ERA5_data.ERA5_RH=[];
ERA5_data.ERA5_10U =[];
ERA5_data.ERA5_10V =[];
ERA5_data.ERA5_SW_Tot =[];
ERA5_data.ERA5_LW_Tot =[];


%%%% save data to site specific data
ERA5_data_HKMPM = ERA5_data;
clear ERA5_data








%%%%% Aojiang River ERA5 data
%%% manually request and download ERA5 data for site
%%% data: 2m dewpoint temperature, 2m temperature, Surface pressure, Total precipitation, Surface net solar radiation, Surface solar radiation downwards, Soil temperature level 1


%%% read in ERA5 metadata
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Aojiang River\2020\9bb490174e5e29ff0710cf1ccbeb7a0.grib');
metadata2020 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Aojiang River\2021\9c1a1e66d0097f2269ed5d8c9a2e1b51.grib');
metadata2021 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Aojiang River\2022\b0e44d6ed4b8c23e7ba27a708233b768.grib');
metadata2022 = info.Metadata;


metadata = [metadata2020;metadata2021;metadata2022];
clear info metadata2020 metadata2021 metadata2022 


%%% read in ERA5 data
[ERA5_2020] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Aojiang River\2020\9bb490174e5e29ff0710cf1ccbeb7a0.grib');
[ERA5_2021] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Aojiang River\2021\9c1a1e66d0097f2269ed5d8c9a2e1b51.grib');
[ERA5_2022] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Aojiang River\2022\b0e44d6ed4b8c23e7ba27a708233b768.grib');

ERA5_data = cat(3,ERA5_2020,ERA5_2021,ERA5_2022);
clear ERA5_2020 ERA5_2021 ERA5_2022


%%% grab data from ERA file
vars = string(metadata.Element);

% grab 2T data (2m air temp)
band = find(vars == '2T');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2T(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2T_tt = timetable(dates,ERA5_2T);
clear A bands dates ERA5_2T


% grab 2D data (2m dew point temp)
band = find(vars == '2D');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2D(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2D_tt = timetable(dates,ERA5_2D);
clear A bands dates ERA5_2D


% grab ST data (0 - 7cm soil temp)
band = find(vars == 'ST');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_ST(1:length(A),1) = A(1,1,:)-273.15;
ERA5_ST_tt = timetable(dates,ERA5_ST);
clear A bands dates ERA5_ST


% grab SSRD data (Surface solar radition downward (SW_IN))
band = find(vars == 'SSRD');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_IN(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_IN_tt = timetable(dates,ERA5_SW_IN);
clear A bands dates ERA5_SW_IN


% grab SSR data (Surface solar radition downward (SW_Tot))
band = find(vars == 'SSR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_Tot_tt = timetable(dates,ERA5_SW_Tot);
clear A bands dates ERA5_SW_Tot

% grab STS data (Surface thermal radition downward (LW_Tot))
band = find(vars == 'STR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_LW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_LW_Tot_tt = timetable(dates,ERA5_LW_Tot);
clear A bands dates ERA5_LW_Tot

% grab wind data (10m u-component of wind)
band = find(vars == '10U');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10U(1:length(A),1) = A(1,1,:);
ERA5_10U_tt = timetable(dates,ERA5_10U);
clear A bands dates ERA5_10U

% grab wind data (10m v-component of wind)
band = find(vars == '10V');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10V(1:length(A),1) = A(1,1,:);
ERA5_10V_tt = timetable(dates,ERA5_10V);
clear A bands dates ERA5_10V

% grab wind gust data, proxy for turbulence (10m wind gust since previous post-processing)
band = find(vars == 'var49 of table 128 of center ECMWF');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_Turb(1:length(A),1) = A(1,1,:);
ERA5_Turb_tt = timetable(dates,ERA5_Turb);
clear A bands dates ERA5_Turb

% grab TP data (total precip)
band = find(vars == 'TP');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_TP(1:length(A),1) = A(1,1,:)*1000; %convert m to mm
ERA5_TP_tt = timetable(dates,ERA5_TP);
clear A bands dates ERA5_TP


%join timetables
ERA5_data = synchronize(ERA5_2T_tt,ERA5_2D_tt,ERA5_ST_tt,ERA5_10U_tt,ERA5_10V_tt,ERA5_Turb_tt,ERA5_SW_IN_tt,ERA5_SW_Tot_tt,ERA5_LW_Tot_tt,ERA5_TP_tt);
clear ERA5_2T_tt ERA5_2D_tt ERA5_ST_tt ERA5_SW_IN_tt ERA5_TP_tt ERA5_10U_tt ERA5_10V_tt ERA5_Turb_tt ERA5_SW_Tot_tt ERA5_LW_Tot_tt
clear band dates metadata vars



%%% calculate VPD
ERA5_data.ERA5_RH=100-(5.*(ERA5_data.ERA5_2T-ERA5_data.ERA5_2D));
ERA5_data.ERA5_VPD = (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))) - ((ERA5_data.ERA5_RH/100).* (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))));

%%% calculate WS
ERA5_data.ERA5_WS = sqrt(ERA5_data.ERA5_10U.^2 + ERA5_data.ERA5_10V.^2);

%%% calcuate NetRad
ERA5_data.ERA5_NetRad = ERA5_data.ERA5_SW_Tot + ERA5_data.ERA5_LW_Tot;

%clean up dew point temp, rh, u-wind, v-wind, solarRad, thermalRad
ERA5_data.ERA5_2D=[];
ERA5_data.ERA5_RH=[];
ERA5_data.ERA5_10U =[];
ERA5_data.ERA5_10V =[];
ERA5_data.ERA5_SW_Tot =[];
ERA5_data.ERA5_LW_Tot =[];


%%%% save data to site specific data
ERA5_data_Aojiang = ERA5_data;
clear ERA5_data







%%%%% Cauvery Vellar-Coleroon ERA5 data
%%% manually request and download ERA5 data for site
%%% data: 2m dewpoint temperature, 2m temperature, Surface pressure, Total precipitation, Surface net solar radiation, Surface solar radiation downwards, Soil temperature level 1


%%% read in ERA5 metadata
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Cauvery Vellar-Coleroon\2017\5a6714ae1d060b1ff11449e02bdfd262.grib');
metadata2017 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Cauvery Vellar-Coleroon\2018\9ecc713b4f8521d697dfeaf5e7ca6a0c.grib');
metadata2018 = info.Metadata;


metadata = [metadata2017;metadata2018];
clear info metadata2017 metadata2018


%%% read in ERA5 data
[ERA5_2017] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Cauvery Vellar-Coleroon\2017\5a6714ae1d060b1ff11449e02bdfd262.grib');
[ERA5_2018] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Cauvery Vellar-Coleroon\2018\9ecc713b4f8521d697dfeaf5e7ca6a0c.grib');

ERA5_data = cat(3,ERA5_2017,ERA5_2018);
clear ERA5_2017 ERA5_2018


%%% grab data from ERA file
vars = string(metadata.Element);

% grab 2T data (2m air temp)
band = find(vars == '2T');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2T(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2T_tt = timetable(dates,ERA5_2T);
clear A bands dates ERA5_2T


% grab 2D data (2m dew point temp)
band = find(vars == '2D');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2D(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2D_tt = timetable(dates,ERA5_2D);
clear A bands dates ERA5_2D


% grab ST data (0 - 7cm soil temp)
band = find(vars == 'ST');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_ST(1:length(A),1) = A(1,1,:)-273.15;
ERA5_ST_tt = timetable(dates,ERA5_ST);
clear A bands dates ERA5_ST


% grab SSRD data (Surface solar radition downward (SW_IN))
band = find(vars == 'SSRD');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_IN(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_IN_tt = timetable(dates,ERA5_SW_IN);
clear A bands dates ERA5_SW_IN


% grab SSR data (Surface solar radition downward (SW_Tot))
band = find(vars == 'SSR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_Tot_tt = timetable(dates,ERA5_SW_Tot);
clear A bands dates ERA5_SW_Tot

% grab STS data (Surface thermal radition downward (LW_Tot))
band = find(vars == 'STR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_LW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_LW_Tot_tt = timetable(dates,ERA5_LW_Tot);
clear A bands dates ERA5_LW_Tot

% grab wind data (10m u-component of wind)
band = find(vars == '10U');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10U(1:length(A),1) = A(1,1,:);
ERA5_10U_tt = timetable(dates,ERA5_10U);
clear A bands dates ERA5_10U

% grab wind data (10m v-component of wind)
band = find(vars == '10V');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10V(1:length(A),1) = A(1,1,:);
ERA5_10V_tt = timetable(dates,ERA5_10V);
clear A bands dates ERA5_10V

% grab wind gust data, proxy for turbulence (10m wind gust since previous post-processing)
band = find(vars == 'var49 of table 128 of center ECMWF');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_Turb(1:length(A),1) = A(1,1,:);
ERA5_Turb_tt = timetable(dates,ERA5_Turb);
clear A bands dates ERA5_Turb

% grab TP data (total precip)
band = find(vars == 'TP');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_TP(1:length(A),1) = A(1,1,:)*1000; %convert m to mm
ERA5_TP_tt = timetable(dates,ERA5_TP);
clear A bands dates ERA5_TP


%join timetables
ERA5_data = synchronize(ERA5_2T_tt,ERA5_2D_tt,ERA5_ST_tt,ERA5_10U_tt,ERA5_10V_tt,ERA5_Turb_tt,ERA5_SW_IN_tt,ERA5_SW_Tot_tt,ERA5_LW_Tot_tt,ERA5_TP_tt);
clear ERA5_2T_tt ERA5_2D_tt ERA5_ST_tt ERA5_SW_IN_tt ERA5_TP_tt ERA5_10U_tt ERA5_10V_tt ERA5_Turb_tt ERA5_SW_Tot_tt ERA5_LW_Tot_tt
clear band dates metadata vars



%%% calculate VPD
ERA5_data.ERA5_RH=100-(5.*(ERA5_data.ERA5_2T-ERA5_data.ERA5_2D));
ERA5_data.ERA5_VPD = (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))) - ((ERA5_data.ERA5_RH/100).* (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))));

%%% calculate WS
ERA5_data.ERA5_WS = sqrt(ERA5_data.ERA5_10U.^2 + ERA5_data.ERA5_10V.^2);

%%% calcuate NetRad
ERA5_data.ERA5_NetRad = ERA5_data.ERA5_SW_Tot + ERA5_data.ERA5_LW_Tot;

%clean up dew point temp, rh, u-wind, v-wind, solarRad, thermalRad
ERA5_data.ERA5_2D=[];
ERA5_data.ERA5_RH=[];
ERA5_data.ERA5_10U =[];
ERA5_data.ERA5_10V =[];
ERA5_data.ERA5_SW_Tot =[];
ERA5_data.ERA5_LW_Tot =[];


%%%% save data to site specific data
ERA5_data_Cauvery = ERA5_data;
clear ERA5_data







%%%%% Nansha Wetland Park ERA5 data
%%% manually request and download ERA5 data for site
%%% data: 2m dewpoint temperature, 2m temperature, Surface pressure, Total precipitation, Surface net solar radiation, Surface solar radiation downwards, Soil temperature level 1


%%% read in ERA5 metadata
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nansha Wetland Park\2019\5761099340a9ba14ef2e61b5e890971.grib');
metadata2019 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nansha Wetland Park\2020\8dcc6ee8936e63a60beb4ab5fa624b36.grib');
metadata2020 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nansha Wetland Park\2021\5fc72610dfae4dd053f6f8661412b4bd.grib');
metadata2021 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nansha Wetland Park\2022\c8d07fa1bb0a74264ca4ebf8e543d58e.grib');
metadata2022 = info.Metadata;

metadata = [metadata2019;metadata2020;metadata2021;metadata2022];
clear info metadata2019 metadata2020 metadata2021 metadata2022


%%% read in ERA5 data
[ERA5_2019] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nansha Wetland Park\2019\5761099340a9ba14ef2e61b5e890971.grib');
[ERA5_2020] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nansha Wetland Park\2020\8dcc6ee8936e63a60beb4ab5fa624b36.grib');
[ERA5_2021] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nansha Wetland Park\2021\5fc72610dfae4dd053f6f8661412b4bd.grib');
[ERA5_2022] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nansha Wetland Park\2022\c8d07fa1bb0a74264ca4ebf8e543d58e.grib');

ERA5_data = cat(3,ERA5_2019,ERA5_2020,ERA5_2021,ERA5_2022);
clear ERA5_2019 ERA5_2020 ERA5_2021 ERA5_2022


%%% grab data from ERA file
vars = string(metadata.Element);

% grab 2T data (2m air temp)
band = find(vars == '2T');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2T(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2T_tt = timetable(dates,ERA5_2T);
clear A bands dates ERA5_2T


% grab 2D data (2m dew point temp)
band = find(vars == '2D');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2D(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2D_tt = timetable(dates,ERA5_2D);
clear A bands dates ERA5_2D


% grab ST data (0 - 7cm soil temp)
band = find(vars == 'ST');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_ST(1:length(A),1) = A(1,1,:)-273.15;
ERA5_ST_tt = timetable(dates,ERA5_ST);
clear A bands dates ERA5_ST


% grab SSRD data (Surface solar radition downward (SW_IN))
band = find(vars == 'SSRD');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_IN(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_IN_tt = timetable(dates,ERA5_SW_IN);
clear A bands dates ERA5_SW_IN


% grab SSR data (Surface solar radition downward (SW_Tot))
band = find(vars == 'SSR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_Tot_tt = timetable(dates,ERA5_SW_Tot);
clear A bands dates ERA5_SW_Tot

% grab STS data (Surface thermal radition downward (LW_Tot))
band = find(vars == 'STR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_LW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_LW_Tot_tt = timetable(dates,ERA5_LW_Tot);
clear A bands dates ERA5_LW_Tot

% grab wind data (10m u-component of wind)
band = find(vars == '10U');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10U(1:length(A),1) = A(1,1,:);
ERA5_10U_tt = timetable(dates,ERA5_10U);
clear A bands dates ERA5_10U

% grab wind data (10m v-component of wind)
band = find(vars == '10V');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10V(1:length(A),1) = A(1,1,:);
ERA5_10V_tt = timetable(dates,ERA5_10V);
clear A bands dates ERA5_10V

% grab wind gust data, proxy for turbulence (10m wind gust since previous post-processing)
band = find(vars == 'var49 of table 128 of center ECMWF');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_Turb(1:length(A),1) = A(1,1,:);
ERA5_Turb_tt = timetable(dates,ERA5_Turb);
clear A bands dates ERA5_Turb

% grab TP data (total precip)
band = find(vars == 'TP');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_TP(1:length(A),1) = A(1,1,:)*1000; %convert m to mm
ERA5_TP_tt = timetable(dates,ERA5_TP);
clear A bands dates ERA5_TP


%join timetables
ERA5_data = synchronize(ERA5_2T_tt,ERA5_2D_tt,ERA5_ST_tt,ERA5_10U_tt,ERA5_10V_tt,ERA5_Turb_tt,ERA5_SW_IN_tt,ERA5_SW_Tot_tt,ERA5_LW_Tot_tt,ERA5_TP_tt);
clear ERA5_2T_tt ERA5_2D_tt ERA5_ST_tt ERA5_SW_IN_tt ERA5_TP_tt ERA5_10U_tt ERA5_10V_tt ERA5_Turb_tt ERA5_SW_Tot_tt ERA5_LW_Tot_tt
clear band dates metadata vars



%%% calculate VPD
ERA5_data.ERA5_RH=100-(5.*(ERA5_data.ERA5_2T-ERA5_data.ERA5_2D));
ERA5_data.ERA5_VPD = (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))) - ((ERA5_data.ERA5_RH/100).* (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))));

%%% calculate WS
ERA5_data.ERA5_WS = sqrt(ERA5_data.ERA5_10U.^2 + ERA5_data.ERA5_10V.^2);

%%% calcuate NetRad
ERA5_data.ERA5_NetRad = ERA5_data.ERA5_SW_Tot + ERA5_data.ERA5_LW_Tot;

%clean up dew point temp, rh, u-wind, v-wind, solarRad, thermalRad
ERA5_data.ERA5_2D=[];
ERA5_data.ERA5_RH=[];
ERA5_data.ERA5_10U =[];
ERA5_data.ERA5_10V =[];
ERA5_data.ERA5_SW_Tot =[];
ERA5_data.ERA5_LW_Tot =[];


%%%% save data to site specific data
ERA5_data_Nansha = ERA5_data;
clear ERA5_data







%%%%% Sundarbans ERA5 data
%%% manually request and download ERA5 data for site
%%% data: 2m dewpoint temperature, 2m temperature, Surface pressure, Total precipitation, Surface net solar radiation, Surface solar radiation downwards, Soil temperature level 1


%%% read in ERA5 metadata
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2012\297d2b4e702ee04d4831e5e922d36988.grib');
metadata2012 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2013\fc343070414ad231014fa99da81432cd.grib');
metadata2013 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2014\6717a0509a6693897381cf27c537d7b8.grib');
metadata2014 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2015\bcacedd37624455fa0499cfd4e025511.grib');
metadata2015 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2016\8ce937e98191fc2545f588c6d2d4546a.grib');
metadata2016 = info.Metadata;

metadata = [metadata2012;metadata2013;metadata2014;metadata2015;metadata2016];
clear info metadata2012 metadata2013 metadata2014 metadata2015 metadata2016


%%% read in ERA5 data
[ERA5_2012] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2012\297d2b4e702ee04d4831e5e922d36988.grib');
[ERA5_2013] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2013\fc343070414ad231014fa99da81432cd.grib');
[ERA5_2014] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2014\6717a0509a6693897381cf27c537d7b8.grib');
[ERA5_2015] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2015\bcacedd37624455fa0499cfd4e025511.grib');
[ERA5_2016] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Sundarbans\2016\8ce937e98191fc2545f588c6d2d4546a.grib');

ERA5_data = cat(3,ERA5_2012,ERA5_2013,ERA5_2014,ERA5_2015,ERA5_2016);
clear ERA5_2012 ERA5_2013 ERA5_2014 ERA5_2015 ERA5_2016


%%% grab data from ERA file
vars = string(metadata.Element);

% grab 2T data (2m air temp)
band = find(vars == '2T');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2T(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2T_tt = timetable(dates,ERA5_2T);
clear A bands dates ERA5_2T


% grab 2D data (2m dew point temp)
band = find(vars == '2D');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2D(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2D_tt = timetable(dates,ERA5_2D);
clear A bands dates ERA5_2D


% grab ST data (0 - 7cm soil temp)
band = find(vars == 'ST');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_ST(1:length(A),1) = A(1,1,:)-273.15;
ERA5_ST_tt = timetable(dates,ERA5_ST);
clear A bands dates ERA5_ST


% grab SSRD data (Surface solar radition downward (SW_IN))
band = find(vars == 'SSRD');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_IN(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_IN_tt = timetable(dates,ERA5_SW_IN);
clear A bands dates ERA5_SW_IN


% grab SSR data (Surface solar radition downward (SW_Tot))
band = find(vars == 'SSR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_Tot_tt = timetable(dates,ERA5_SW_Tot);
clear A bands dates ERA5_SW_Tot

% grab STS data (Surface thermal radition downward (LW_Tot))
band = find(vars == 'STR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_LW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_LW_Tot_tt = timetable(dates,ERA5_LW_Tot);
clear A bands dates ERA5_LW_Tot

% grab wind data (10m u-component of wind)
band = find(vars == '10U');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10U(1:length(A),1) = A(1,1,:);
ERA5_10U_tt = timetable(dates,ERA5_10U);
clear A bands dates ERA5_10U

% grab wind data (10m v-component of wind)
band = find(vars == '10V');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10V(1:length(A),1) = A(1,1,:);
ERA5_10V_tt = timetable(dates,ERA5_10V);
clear A bands dates ERA5_10V

% grab wind gust data, proxy for turbulence (10m wind gust since previous post-processing)
band = find(vars == 'var49 of table 128 of center ECMWF');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_Turb(1:length(A),1) = A(1,1,:);
ERA5_Turb_tt = timetable(dates,ERA5_Turb);
clear A bands dates ERA5_Turb

% grab TP data (total precip)
band = find(vars == 'TP');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_TP(1:length(A),1) = A(1,1,:)*1000; %convert m to mm
ERA5_TP_tt = timetable(dates,ERA5_TP);
clear A bands dates ERA5_TP


%join timetables
ERA5_data = synchronize(ERA5_2T_tt,ERA5_2D_tt,ERA5_ST_tt,ERA5_10U_tt,ERA5_10V_tt,ERA5_Turb_tt,ERA5_SW_IN_tt,ERA5_SW_Tot_tt,ERA5_LW_Tot_tt,ERA5_TP_tt);
clear ERA5_2T_tt ERA5_2D_tt ERA5_ST_tt ERA5_SW_IN_tt ERA5_TP_tt ERA5_10U_tt ERA5_10V_tt ERA5_Turb_tt ERA5_SW_Tot_tt ERA5_LW_Tot_tt
clear band dates metadata vars



%%% calculate VPD
ERA5_data.ERA5_RH=100-(5.*(ERA5_data.ERA5_2T-ERA5_data.ERA5_2D));
ERA5_data.ERA5_VPD = (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))) - ((ERA5_data.ERA5_RH/100).* (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))));

%%% calculate WS
ERA5_data.ERA5_WS = sqrt(ERA5_data.ERA5_10U.^2 + ERA5_data.ERA5_10V.^2);

%%% calcuate NetRad
ERA5_data.ERA5_NetRad = ERA5_data.ERA5_SW_Tot + ERA5_data.ERA5_LW_Tot;

%clean up dew point temp, rh, u-wind, v-wind, solarRad, thermalRad
ERA5_data.ERA5_2D=[];
ERA5_data.ERA5_RH=[];
ERA5_data.ERA5_10U =[];
ERA5_data.ERA5_10V =[];
ERA5_data.ERA5_SW_Tot =[];
ERA5_data.ERA5_LW_Tot =[];


%%%% save data to site specific data
ERA5_data_Sundarbans = ERA5_data;
clear ERA5_data







%%%%% Yunxiao ERA5 data
%%% manually request and download ERA5 data for site
%%% data: 2m dewpoint temperature, 2m temperature, Surface pressure, Total precipitation, Surface net solar radiation, Surface solar radiation downwards, Soil temperature level 1


%%% read in ERA5 metadata
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Yunxiao\2019\7fbbeaa764dabd7b4ce6ce5e8dee0332.grib');
metadata2019 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Yunxiao\2020\8307f155c8f87cf3e756b7c3922c4a3a.grib');
metadata2020 = info.Metadata;

metadata = [metadata2019;metadata2020];
clear info metadata2019 metadata2020 


%%% read in ERA5 data
[ERA5_2019] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Yunxiao\2019\7fbbeaa764dabd7b4ce6ce5e8dee0332.grib');
[ERA5_2020] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Yunxiao\2020\8307f155c8f87cf3e756b7c3922c4a3a.grib');

ERA5_data = cat(3,ERA5_2019,ERA5_2020);
clear ERA5_2019 ERA5_2020


%%% grab data from ERA file
vars = string(metadata.Element);

% grab 2T data (2m air temp)
band = find(vars == '2T');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2T(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2T_tt = timetable(dates,ERA5_2T);
clear A bands dates ERA5_2T


% grab 2D data (2m dew point temp)
band = find(vars == '2D');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2D(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2D_tt = timetable(dates,ERA5_2D);
clear A bands dates ERA5_2D


% grab ST data (0 - 7cm soil temp)
band = find(vars == 'ST');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_ST(1:length(A),1) = A(1,1,:)-273.15;
ERA5_ST_tt = timetable(dates,ERA5_ST);
clear A bands dates ERA5_ST


% grab SSRD data (Surface solar radition downward (SW_IN))
band = find(vars == 'SSRD');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_IN(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_IN_tt = timetable(dates,ERA5_SW_IN);
clear A bands dates ERA5_SW_IN


% grab SSR data (Surface solar radition downward (SW_Tot))
band = find(vars == 'SSR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_Tot_tt = timetable(dates,ERA5_SW_Tot);
clear A bands dates ERA5_SW_Tot

% grab STS data (Surface thermal radition downward (LW_Tot))
band = find(vars == 'STR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_LW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_LW_Tot_tt = timetable(dates,ERA5_LW_Tot);
clear A bands dates ERA5_LW_Tot

% grab wind data (10m u-component of wind)
band = find(vars == '10U');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10U(1:length(A),1) = A(1,1,:);
ERA5_10U_tt = timetable(dates,ERA5_10U);
clear A bands dates ERA5_10U

% grab wind data (10m v-component of wind)
band = find(vars == '10V');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10V(1:length(A),1) = A(1,1,:);
ERA5_10V_tt = timetable(dates,ERA5_10V);
clear A bands dates ERA5_10V

% grab wind gust data, proxy for turbulence (10m wind gust since previous post-processing)
band = find(vars == 'var49 of table 128 of center ECMWF');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_Turb(1:length(A),1) = A(1,1,:);
ERA5_Turb_tt = timetable(dates,ERA5_Turb);
clear A bands dates ERA5_Turb

% grab TP data (total precip)
band = find(vars == 'TP');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_TP(1:length(A),1) = A(1,1,:)*1000; %convert m to mm
ERA5_TP_tt = timetable(dates,ERA5_TP);
clear A bands dates ERA5_TP


%join timetables
ERA5_data = synchronize(ERA5_2T_tt,ERA5_2D_tt,ERA5_ST_tt,ERA5_10U_tt,ERA5_10V_tt,ERA5_Turb_tt,ERA5_SW_IN_tt,ERA5_SW_Tot_tt,ERA5_LW_Tot_tt,ERA5_TP_tt);
clear ERA5_2T_tt ERA5_2D_tt ERA5_ST_tt ERA5_SW_IN_tt ERA5_TP_tt ERA5_10U_tt ERA5_10V_tt ERA5_Turb_tt ERA5_SW_Tot_tt ERA5_LW_Tot_tt
clear band dates metadata vars



%%% calculate VPD
ERA5_data.ERA5_RH=100-(5.*(ERA5_data.ERA5_2T-ERA5_data.ERA5_2D));
ERA5_data.ERA5_VPD = (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))) - ((ERA5_data.ERA5_RH/100).* (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))));

%%% calculate WS
ERA5_data.ERA5_WS = sqrt(ERA5_data.ERA5_10U.^2 + ERA5_data.ERA5_10V.^2);

%%% calcuate NetRad
ERA5_data.ERA5_NetRad = ERA5_data.ERA5_SW_Tot + ERA5_data.ERA5_LW_Tot;

%clean up dew point temp, rh, u-wind, v-wind, solarRad, thermalRad
ERA5_data.ERA5_2D=[];
ERA5_data.ERA5_RH=[];
ERA5_data.ERA5_10U =[];
ERA5_data.ERA5_10V =[];
ERA5_data.ERA5_SW_Tot =[];
ERA5_data.ERA5_LW_Tot =[];


%%%% save data to site specific data
ERA5_data_Yunxiao = ERA5_data;
clear ERA5_data










%%%%% Nanji Island ERA5 data
%%% manually request and download ERA5 data for site
%%% data: 2m dewpoint temperature, 2m temperature, Surface pressure, Total precipitation, Surface net solar radiation, Surface solar radiation downwards, Soil temperature level 1


%%% read in ERA5 metadata
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nanji Island\2020\287defec5ecd481c34a1e09c67c8545e.grib');
metadata2020 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nanji Island\2021\221af9ba828ba8edcdfec5de0cef103.grib');
metadata2021 = info.Metadata;
info = georasterinfo('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nanji Island\2022\6e6578a5027b601c9492668ae2be8c11.grib');
metadata2022 = info.Metadata;


metadata = [metadata2020;metadata2021;metadata2022];
clear info metadata2020 metadata2021 metadata2022 


%%% read in ERA5 data
[ERA5_2020] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nanji Island\2020\287defec5ecd481c34a1e09c67c8545e.grib');
[ERA5_2021] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nanji Island\2021\221af9ba828ba8edcdfec5de0cef103.grib');
[ERA5_2022] = readgeoraster('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\ERA5 data\Nanji Island\2022\6e6578a5027b601c9492668ae2be8c11.grib');

ERA5_data = cat(3,ERA5_2020,ERA5_2021,ERA5_2022);
clear ERA5_2020 ERA5_2021 ERA5_2022


%%% grab data from ERA file
vars = string(metadata.Element);

% grab 2T data (2m air temp)
band = find(vars == '2T');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2T(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2T_tt = timetable(dates,ERA5_2T);
clear A bands dates ERA5_2T


% grab 2D data (2m dew point temp)
band = find(vars == '2D');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_2D(1:length(A),1) = A(1,1,:)-273.15;
ERA5_2D_tt = timetable(dates,ERA5_2D);
clear A bands dates ERA5_2D


% grab ST data (0 - 7cm soil temp)
band = find(vars == 'ST');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_ST(1:length(A),1) = A(1,1,:)-273.15;
ERA5_ST_tt = timetable(dates,ERA5_ST);
clear A bands dates ERA5_ST


% grab SSRD data (Surface solar radition downward (SW_IN))
band = find(vars == 'SSRD');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_IN(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_IN_tt = timetable(dates,ERA5_SW_IN);
clear A bands dates ERA5_SW_IN


% grab SSR data (Surface solar radition downward (SW_Tot))
band = find(vars == 'SSR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_SW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_SW_Tot_tt = timetable(dates,ERA5_SW_Tot);
clear A bands dates ERA5_SW_Tot

% grab STS data (Surface thermal radition downward (LW_Tot))
band = find(vars == 'STR');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_LW_Tot(1:length(A),1) = A(1,1,:)/60/60; %convert from J m-2 to W m-2
ERA5_LW_Tot_tt = timetable(dates,ERA5_LW_Tot);
clear A bands dates ERA5_LW_Tot

% grab wind data (10m u-component of wind)
band = find(vars == '10U');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10U(1:length(A),1) = A(1,1,:);
ERA5_10U_tt = timetable(dates,ERA5_10U);
clear A bands dates ERA5_10U

% grab wind data (10m v-component of wind)
band = find(vars == '10V');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_10V(1:length(A),1) = A(1,1,:);
ERA5_10V_tt = timetable(dates,ERA5_10V);
clear A bands dates ERA5_10V

% grab wind gust data, proxy for turbulence (10m wind gust since previous post-processing)
band = find(vars == 'var49 of table 128 of center ECMWF');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_Turb(1:length(A),1) = A(1,1,:);
ERA5_Turb_tt = timetable(dates,ERA5_Turb);
clear A bands dates ERA5_Turb

% grab TP data (total precip)
band = find(vars == 'TP');
dates = datetime(metadata.ValidTime(band));
[A] = ERA5_data(band);
ERA5_TP(1:length(A),1) = A(1,1,:)*1000; %convert m to mm
ERA5_TP_tt = timetable(dates,ERA5_TP);
clear A bands dates ERA5_TP


%join timetables
ERA5_data = synchronize(ERA5_2T_tt,ERA5_2D_tt,ERA5_ST_tt,ERA5_10U_tt,ERA5_10V_tt,ERA5_Turb_tt,ERA5_SW_IN_tt,ERA5_SW_Tot_tt,ERA5_LW_Tot_tt,ERA5_TP_tt);
clear ERA5_2T_tt ERA5_2D_tt ERA5_ST_tt ERA5_SW_IN_tt ERA5_TP_tt ERA5_10U_tt ERA5_10V_tt ERA5_Turb_tt ERA5_SW_Tot_tt ERA5_LW_Tot_tt
clear band dates metadata vars



%%% calculate VPD
ERA5_data.ERA5_RH=100-(5.*(ERA5_data.ERA5_2T-ERA5_data.ERA5_2D));
ERA5_data.ERA5_VPD = (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))) - ((ERA5_data.ERA5_RH/100).* (0.6108.*exp(17.27.*ERA5_data.ERA5_2T./(ERA5_data.ERA5_2T + 237.3))));

%%% calculate WS
ERA5_data.ERA5_WS = sqrt(ERA5_data.ERA5_10U.^2 + ERA5_data.ERA5_10V.^2);

%%% calcuate NetRad
ERA5_data.ERA5_NetRad = ERA5_data.ERA5_SW_Tot + ERA5_data.ERA5_LW_Tot;

%clean up dew point temp, rh, u-wind, v-wind, solarRad, thermalRad
ERA5_data.ERA5_2D=[];
ERA5_data.ERA5_RH=[];
ERA5_data.ERA5_10U =[];
ERA5_data.ERA5_10V =[];
ERA5_data.ERA5_SW_Tot =[];
ERA5_data.ERA5_LW_Tot =[];


%%%% save data to site specific data
ERA5_data_Nanji = ERA5_data;
clear ERA5_data










%%%%% write out data as CSV files
ERA5_data_Aojiang.dates.Format='yyyyMMddHHmm';
ERA5_data_Cauvery.dates.Format='yyyyMMddHHmm';
ERA5_data_HKMPM.dates.Format='yyyyMMddHHmm';
ERA5_data_Nansha.dates.Format='yyyyMMddHHmm';
ERA5_data_SRS6.dates.Format='yyyyMMddHHmm';
ERA5_data_Sundarbans.dates.Format='yyyyMMddHHmm';
ERA5_data_Yunxiao.dates.Format='yyyyMMddHHmm';
ERA5_data_Nanji.dates.Format='yyyyMMddHHmm';

writetimetable(ERA5_data_Aojiang,'ERA5_data_Aojiang.csv')
writetimetable(ERA5_data_Cauvery,'ERA5_data_Cauvery.csv')
writetimetable(ERA5_data_HKMPM,'ERA5_data_HKMPM.csv')
writetimetable(ERA5_data_Nansha,'ERA5_data_Nansha.csv')
writetimetable(ERA5_data_SRS6,'ERA5_data_SRS6.csv')
writetimetable(ERA5_data_Sundarbans,'ERA5_data_Sundarbans.csv')
writetimetable(ERA5_data_Yunxiao,'ERA5_data_Yunxiao.csv')
writetimetable(ERA5_data_Nanji,'ERA5_data_Nanji.csv')

