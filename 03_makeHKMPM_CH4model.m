%%% mangrove ch4 multisite project
%%% starting Aug 2024
%%% file for HKMPM, make RF CH4 model

clear all
close all





%%%%%%%%%%%%%%%%%%%%%%% read in FLUX data
flux_data = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\NEE_gapfilled_data_HKMPM.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
flux_data = standardizeMissing(flux_data, -9999);

%%% make datetime variable
flux_data.Time = datetime(compose("%d",flux_data.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');

flux_data = table2timetable(flux_data);

%%% start/end dates
start_day = flux_data.Time(4);
end_day = flux_data.Time(end)+duration(1,30,0);
time_step = duration(0,30,0);
time_array = (start_day:time_step:end_day)';








%%%%%%%%%%%%%%%%%%%%%%% read in ERA5 data
ERA5_data = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\ERA5_data_HKMPM.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
%%% make datetime variable
ERA5_data.Time = datetime(compose("%d",ERA5_data.dates),'InputFormat','yyyyMMddHHmm');

ERA5_data = table2timetable(ERA5_data);
ERA5_data.dates = [];



%%% interplote ERA5 and FLUX data to hourly
ERA5_data_30min = retime(ERA5_data, time_array,'linear');
flux_data_30min = retime(flux_data, time_array,'fillwithmissing');









%%% gapfill flux met data with ERA5 data
model_input_flux = timetable(flux_data_30min.Time,flux_data_30min.TA,flux_data_30min.TS_1,flux_data_30min.SW_IN,flux_data_30min.NETRAD,flux_data_30min.VPD,flux_data_30min.P,'VariableNames',{'TA','TS','SW_IN','NetRad','VPD','P'});


%TA
model_input_flux.TA_gf = model_input_flux.TA;
TA_gaps = flux_data_30min.Time(isnan(model_input_flux.TA_gf));
model_input_flux.TA_gf(TA_gaps) = ERA5_data_30min.ERA5_2T(TA_gaps);

%TS
model_input_flux.TS_gf = model_input_flux.TS;
TS_gaps = flux_data_30min.Time(isnan(model_input_flux.TS_gf));
model_input_flux.TS_gf(TS_gaps) = ERA5_data_30min.ERA5_ST(TS_gaps);

%SW_IN
model_input_flux.SW_IN_gf = model_input_flux.SW_IN;
SW_IN_gaps = flux_data_30min.Time(isnan(model_input_flux.SW_IN_gf));
model_input_flux.SW_IN_gf(SW_IN_gaps) = ERA5_data_30min.ERA5_SW_IN(SW_IN_gaps);

%VPD
model_input_flux.VPD_gf = model_input_flux.VPD;
VPD_gaps = flux_data_30min.Time(isnan(model_input_flux.VPD_gf));
model_input_flux.VPD_gf(VPD_gaps) = ERA5_data_30min.ERA5_ST(VPD_gaps);
model_input_flux.VPD_gf = ERA5_data_30min.ERA5_VPD;

%P
model_input_flux.P_gf = model_input_flux.P;
P_gaps = flux_data_30min.Time(isnan(model_input_flux.P_gf));
model_input_flux.P_gf(P_gaps) = ERA5_data_30min.ERA5_TP(P_gaps);

%WS
model_input_flux.WS = ERA5_data_30min.ERA5_WS;

%Turb
model_input_flux.Turb = ERA5_data_30min.ERA5_Turb;

%NetRad
model_input_flux.NetRad_gf = model_input_flux.NetRad;
NetRad_gaps = flux_data_30min.Time(isnan(model_input_flux.NetRad_gf));
model_input_flux.NetRad_gf(NetRad_gaps) = ERA5_data_30min.ERA5_NetRad(NetRad_gaps);
%model_input_flux.NetRad = ERA5_data_30min.ERA5_NetRad;



%%% create running sum of precipitation data
% 30 day moving sum
model_input_flux.P_gf_runningsum = movsum(model_input_flux.P_gf,(30*48));








%%%%%%%%%%%%%%%%%%%%%%% read in MODIS data

MODIS_data = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\MODIS_data_HKMPM.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
%%% make datetime variable
MODIS_data.Time = datetime(compose("%d",MODIS_data.Time),'InputFormat','yyyyMMddHHmm');

MODIS_data = table2timetable(MODIS_data);




MODIS_data_30min = retime(MODIS_data, time_array,'nearest');




%%%%%%%%%%%%%%%%%%%%%%% make DOY varaible
DOY = day(time_array,'dayofyear');
DOY = timetable(time_array,DOY);














%%% complex RF model for CH4 using NEE and met variables


%all data
%X_input_CH4_complex = table(NEE_model_complex,model_input_flux.TA_gf,model_input_flux.TS_gf,model_input_flux.WS,model_input_flux.Turb,model_input_flux.VPD_gf,model_input_flux.SW_IN_gf,model_input_flux.NetRad,model_input_flux.P_gf,complex_model_variables.DOY,complex_model_variables.LAI,complex_model_variables.NDVI,'VariableNames',["NEE","TA","TS","WS","Turb","VPD","SW_IN","NetRad","P","DOY","LAI","NDVI"]);
%no P
%X_input_CH4_complex = table(NEE_model_complex,model_input_flux.TA_gf,model_input_flux.TS_gf,model_input_flux.WS,model_input_flux.Turb,model_input_flux.VPD_gf,model_input_flux.SW_IN_gf,model_input_flux.NetRad,complex_model_variables.DOY,complex_model_variables.LAI,complex_model_variables.NDVI,'VariableNames',["NEE","TA","TS","WS","Turb","VPD","SW_IN","NetRad","DOY","LAI","NDVI"]);
%no P, SW_IN, LAI, add back running sum P
X_input_CH4_complex = table(flux_data_30min.NEE_gf,model_input_flux.TA_gf,model_input_flux.TS_gf,model_input_flux.WS,model_input_flux.Turb,model_input_flux.VPD_gf,model_input_flux.NetRad_gf,DOY.DOY,MODIS_data_30min.NDVI,model_input_flux.P_gf_runningsum,'VariableNames',["NEE","TA","TS","WS","Turb","VPD","NetRad","DOY","NDVI","P"]);

model_target_CH4_complex = flux_data.FCH4;



%code to auto optimize paramaters
%fitrensemble(X_input_CH4_complex,model_target_CH4_complex,'OptimizeHyperparameters',{'NumLearningCycles','MaxNumSplits','MinLeafSize'},'Method','Bag')


%%%%% run complex CH4 model
%%%
%%% optimize paramaters stat results
%%%                470 learning cycles, 12664 splits, 1 min leaf size, all variables: oobR2=0.4100, ibR2=0.8980
%%%                346 learning cycles, 43610 splits, 1 min leaf size, all variables: oobR2=0.4087, ibR2=0.8977
%%%
%%%                346 learning cycles, 43610 splits, 1 min leaf size, no P: oobR2=0.4095, ibR2=0.8979
%%%                346 learning cycles, 43610 splits, 1 min leaf size, no P, SW_IN, LAI: oobR2=0.4026, ibR2=0.8931
%%% OptimizeHyperparameters
t_CH4_complex = templateTree('NumVariablesToSample','all','PredictorSelection','interaction-curvature','Surrogate','off','MaxNumSplits',43610,'MinLeafSize',1);
rng(1); % For reproducibility
Mdl_CH4_complex = fitrensemble(X_input_CH4_complex,model_target_CH4_complex,'Method','Bag','NumLearningCycles',346,'Learners',t_CH4_complex);%,'CrossVal','on');



%Predictor Importance Estimation

impOOB_CH4 = oobPermutedPredictorImportance(Mdl_CH4_complex);




figure
bar(impOOB_CH4)
title('Unbiased Predictor Importance Estimates')
xlabel('Predictor variable')
ylabel('Importance')
h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';



%%% complex RF CH4 model gapfilling used for model stats
CH4_model_complex = predict(Mdl_CH4_complex,X_input_CH4_complex);



%%% complex RF CH4 model stats
yHat_complex = oobPredict(Mdl_CH4_complex);
CH4_complex_R2_oob = corr(Mdl_CH4_complex.Y,yHat_complex)^2
CH4_complex_R2 = corr(model_target_CH4_complex,CH4_model_complex,'rows','complete')^2



%%% complex CH4 model and CH4 data plot
%figure
%hold on
%plot(flux_data_30min.Time,model_target_CH4_complex,'k')
%plot(flux_data_30min.Time,CH4_model_complex,'r')
%box on








%%%% output RF NEE Mdl file

saveLearnerForCoder(Mdl_CH4_complex,'Mdl_CH4_HKMPM');


