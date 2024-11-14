%%% mangrove ch4 multisite project
%%% starting Aug 2024
%%% USTAR filtering for sites with avaible 30-min flux data

clear all
close all



%%%%%%% HKMPM site
%%%%%%% this site starts with FLUXNET data, does not need to be USTAR filtered
%%%%%%% data is processed to match file formate with SRS6 data
%%% read in FLUX data
flux_data_HKMPM = readtable('C:\Users\der66\YSE Dropbox\David Reed\Yale\FCE projects\mangrove mulitsite\FLX_HK-MPM_FLUXNET-CH4_2016-2018_1-1\FLX_HK-MPM_FLUXNET-CH4_HH_2016-2018_1-1.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
flux_data_HKMPM = standardizeMissing(flux_data_HKMPM, -9999);

%%% make datetime variable
flux_data_HKMPM.Time = datetime(compose("%d",flux_data_HKMPM.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');

flux_data_HKMPM = table2timetable(flux_data_HKMPM);

%%% start/end dates
start_day = flux_data_HKMPM.Time(1);
end_day = flux_data_HKMPM.Time(end)+duration(0,30,0);
time_step = duration(0,30,0);
time_array = (start_day:time_step:end_day)';

clear start_day end_day time_step time_array


%%%% write out ustar filtered, non gapfilled data
%writetimetable(flux_data_HKMPM,'USTARfiltered_nongapfilled_data_HKMPM.csv')












%%%%%%% SRS6 site
%%%%%%% this site starts with AmeriFlux data, needs to be USTAR filtered

%%% read in FLUX data
flux_data_SRS6 = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\ameriflux data upload\US-Skr_HH_201612312230_202312312230.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
flux_data_SRS6 = standardizeMissing(flux_data_SRS6, -9999);

%%% make datetime variable
flux_data_SRS6.Time = datetime(compose("%d",flux_data_SRS6.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');

flux_data_SRS6 = table2timetable(flux_data_SRS6);

%%% start/end dates
start_day = flux_data_SRS6.Time(4);
end_day = flux_data_SRS6.Time(end)+duration(1,30,0);
time_step = duration(0,30,0);
time_array = (start_day:time_step:end_day)';

clear start_day end_day time_step time_array

%%% make flux NEE variable
flux_data_SRS6.NEE = flux_data_SRS6.FC+flux_data_SRS6.SC;


%%% make flux NEECH4 variable
flux_data_SRS6.NEECH4 = flux_data_SRS6.FCH4+flux_data_SRS6.SCH4;


%%%%%%%%%%%%%%%%%%%%%% FC and SC are screened at 100 and -100
%%%% I should screen NEE at 100/-100
%%%% or tigher thresholds?

flux_data_SRS6.NEE(flux_data_SRS6.NEE>100)=nan;
flux_data_SRS6.NEE(flux_data_SRS6.NEE<-100)=nan;





%%%%%%%%%%% USTAR filtering
%adapting code from Pastorello, G. et al (2020). https://doi.org/10.1038/s41597-020-0534-3
%based on method from Barr, A. G. et al. Agr. Forest Meteorol. (2013).


%input data
%t=time
%NEE
%uStar
%T = Ta

uStar = flux_data_SRS6.USTAR;
NEE = flux_data_SRS6.NEE;
T = flux_data_SRS6.TA_1_1_1;
Rg = flux_data_SRS6.SW_IN;



nrPerDay = mod(numel(uStar),365);
if nrPerDay == 0; nrPerDay = mod(numel(uStar),364);end
t = 1 + (1 / nrPerDay);
for n2 = 2:numel(uStar); t(n2,1) = t(n2-1,1)+ (1 / nrPerDay);end
clear n2

fNight=Rg<5; % flag nighttime periods

fPlot=0;
%cSiteYr=strrep(d(n).name,'.txt','');%'CACa1-2001';
%cSiteYr = strrep(cSiteYr, '_ut', '_barr');
cSiteYr = 'SRS6_ut';

nBoot=100;

warning('off','all')
[Cp2,Stats2,Cp3,Stats3] = cpdBootstrapUStarTh20100901(t,NEE,uStar,T,fNight,fPlot,cSiteYr,nBoot);

uStar_threshold_SRS6 = median(Cp2,[1 2 3],"omitmissing");


%%% filter NEE by uStar_threshold
flux_data_SRS6.NEE_ut = flux_data_SRS6.NEE;
flux_data_SRS6.NEE_ut(flux_data_SRS6.USTAR<uStar_threshold_SRS6)=nan;

%%% filter NEECH4 by uStar_threshold
flux_data_SRS6.NEECH4_ut = flux_data_SRS6.NEECH4;
flux_data_SRS6.NEECH4_ut(flux_data_SRS6.USTAR<uStar_threshold_SRS6)=nan;

%%% percent data removed by USTAR filter
USTAR_filter_percent_removed_SRS6 = sum(flux_data_SRS6.USTAR<uStar_threshold_SRS6)/sum(~isnan(flux_data_SRS6.USTAR))*100;


%%% clean uStar filtering variables
clear uStar NEE T Rg t fNight fPlot cSiteYr nBoot Stats2 Stats3 Cp2 Cp3 nrPerDay



%%%% write out ustar filtered, non gapfilled data
%writetimetable(flux_data,'USTARfiltered_nongapfilled_data_SRS6.csv')


