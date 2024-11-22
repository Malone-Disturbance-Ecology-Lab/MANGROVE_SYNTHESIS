%%% mangrove ch4 multisite project
%%% starting Aug 2024
%%% file for SRS and HKMPM, make RF NEE model

clear all
close all








%%%%%%%%%%%%%%%%%%%%%%% read in SRS6 FLUX data
flux_data_SRS6 = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\USTARfiltered_nongapfilled_data_SRS6.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
flux_data_SRS6 = standardizeMissing(flux_data_SRS6, -9999);

%%% make datetime variable
flux_data_SRS6.Time = datetime(compose("%d",flux_data_SRS6.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');

flux_data_SRS6 = table2timetable(flux_data_SRS6);

%%% start/end dates
start_day_SRS6 = flux_data_SRS6.Time(4);
end_day_SRS6 = flux_data_SRS6.Time(end)+duration(1,30,0);
time_step = duration(0,30,0);
time_array_SRS6 = (start_day_SRS6:time_step:end_day_SRS6)';







%%%%%%%%%%%%%%%%%%%%%%% read in HKMPM FLUX data
flux_data_HKMPM = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\USTARfiltered_nongapfilled_data_HKMPM.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
flux_data_HKMPM = standardizeMissing(flux_data_HKMPM, -9999);

%%% make datetime variable
flux_data_HKMPM.Time = datetime(compose("%d",flux_data_HKMPM.TIMESTAMP_START),'InputFormat','yyyyMMddHHmm');

flux_data_HKMPM = table2timetable(flux_data_HKMPM);

%%% start/end dates
start_day_HKMPM = flux_data_HKMPM.Time(4);
end_day_HKMPM = flux_data_HKMPM.Time(end)+duration(1,30,0);
time_step = duration(0,30,0);
time_array_HKMPM = (start_day_HKMPM:time_step:end_day_HKMPM)';










%%%%%%%%%%%%%%%%%%%%%%% read in SRS6 ERA5 data
ERA5_data_SRS6 = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\ERA5_data_SRS6.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
%%% make datetime variable
ERA5_data_SRS6.Time = datetime(compose("%d",ERA5_data_SRS6.dates),'InputFormat','yyyyMMddHHmm');

ERA5_data_SRS6 = table2timetable(ERA5_data_SRS6);
ERA5_data_SRS6.dates = [];



%%% interplote SRS6 ERA5 and FLUX data to hourly
ERA5_data_30min_SRS6 = retime(ERA5_data_SRS6, time_array_SRS6,'linear');
flux_data_30min_SRS6 = retime(flux_data_SRS6, time_array_SRS6,'fillwithmissing');





%%% gapfill flux met data with SRS6 ERA5 data
model_input_flux_SRS6 = timetable(flux_data_30min_SRS6.Time,flux_data_30min_SRS6.TA_1_1_1,flux_data_30min_SRS6.TS_1_1_1,flux_data_30min_SRS6.SW_IN,flux_data_30min_SRS6.VPD,flux_data_30min_SRS6.P,'VariableNames',{'TA','TS','SW_IN','VPD','P'});


%TA
model_input_flux_SRS6.TA_gf = model_input_flux_SRS6.TA;
TA_gaps = flux_data_30min_SRS6.Time(isnan(model_input_flux_SRS6.TA_gf));
model_input_flux_SRS6.TA_gf(TA_gaps) = ERA5_data_30min_SRS6.ERA5_2T(TA_gaps);

%TS
model_input_flux_SRS6.TS_gf = model_input_flux_SRS6.TS;
TS_gaps = flux_data_30min_SRS6.Time(isnan(model_input_flux_SRS6.TS_gf));
model_input_flux_SRS6.TS_gf(TS_gaps) = ERA5_data_30min_SRS6.ERA5_ST(TS_gaps);

%SW_IN
model_input_flux_SRS6.SW_IN_gf = model_input_flux_SRS6.SW_IN;
SW_IN_gaps = flux_data_30min_SRS6.Time(isnan(model_input_flux_SRS6.SW_IN_gf));
model_input_flux_SRS6.SW_IN_gf(SW_IN_gaps) = ERA5_data_30min_SRS6.ERA5_SW_IN(SW_IN_gaps);

%VPD
%model_input_flux.VPD_gf = model_input_flux.VPD;
%VPD_gaps = flux_data_30min.Time(isnan(model_input_flux.VPD_gf));
%model_input_flux.VPD_gf(VPD_gaps) = ERA5_data_30min.ERA5_ST(VPD_gaps);
%%%%%%%%%%%%%%%% there is a problem with the EC VPD
model_input_flux_SRS6.VPD_gf = ERA5_data_30min_SRS6.ERA5_VPD;

%P
model_input_flux_SRS6.P_gf = model_input_flux_SRS6.P;
P_gaps = flux_data_30min_SRS6.Time(isnan(model_input_flux_SRS6.P_gf));
model_input_flux_SRS6.P_gf(P_gaps) = ERA5_data_30min_SRS6.ERA5_TP(P_gaps);

%WS
model_input_flux_SRS6.WS = ERA5_data_30min_SRS6.ERA5_WS;

%Turb
model_input_flux_SRS6.Turb = ERA5_data_30min_SRS6.ERA5_Turb;

%NetRad
model_input_flux_SRS6.NetRad = ERA5_data_30min_SRS6.ERA5_NetRad;



%%% create running sum of precipitation data
% 30 day moving sum
model_input_flux_SRS6.P_gf_runningsum = movsum(model_input_flux_SRS6.P_gf,(30*48));


clear P_gaps SW_IN_gaps TS_gaps TA_gaps







%%%%%%%%%%%%%%%%%%%%%%% read in HKMPM ERA5 data
ERA5_data_HKMPM = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\ERA5_data_HKMPM.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
%%% make datetime variable
ERA5_data_HKMPM.Time = datetime(compose("%d",ERA5_data_HKMPM.dates),'InputFormat','yyyyMMddHHmm');

ERA5_data_HKMPM = table2timetable(ERA5_data_HKMPM);
ERA5_data_HKMPM.dates = [];



%%% interplote ERA5 and FLUX data to hourly
ERA5_data_30min_HKMPM = retime(ERA5_data_HKMPM, time_array_HKMPM,'linear');
flux_data_30min_HKMPM = retime(flux_data_HKMPM, time_array_HKMPM,'fillwithmissing');








%%% gapfill flux met data with HKMPM ERA5 data
model_input_flux_HKMPM = timetable(flux_data_30min_HKMPM.Time,flux_data_30min_HKMPM.TA,flux_data_30min_HKMPM.TS_1,flux_data_30min_HKMPM.SW_IN,flux_data_30min_HKMPM.NETRAD,flux_data_30min_HKMPM.VPD,flux_data_30min_HKMPM.P,'VariableNames',{'TA','TS','SW_IN','NetRad','VPD','P'});


%TA
model_input_flux_HKMPM.TA_gf = model_input_flux_HKMPM.TA;
TA_gaps = flux_data_30min_HKMPM.Time(isnan(model_input_flux_HKMPM.TA_gf));
model_input_flux_HKMPM.TA_gf(TA_gaps) = ERA5_data_30min_HKMPM.ERA5_2T(TA_gaps);

%TS
model_input_flux_HKMPM.TS_gf = model_input_flux_HKMPM.TS;
TS_gaps = flux_data_30min_HKMPM.Time(isnan(model_input_flux_HKMPM.TS_gf));
model_input_flux_HKMPM.TS_gf(TS_gaps) = ERA5_data_30min_HKMPM.ERA5_ST(TS_gaps);

%SW_IN
model_input_flux_HKMPM.SW_IN_gf = model_input_flux_HKMPM.SW_IN;
SW_IN_gaps = flux_data_30min_HKMPM.Time(isnan(model_input_flux_HKMPM.SW_IN_gf));
model_input_flux_HKMPM.SW_IN_gf(SW_IN_gaps) = ERA5_data_30min_HKMPM.ERA5_SW_IN(SW_IN_gaps);

%VPD
model_input_flux_HKMPM.VPD_gf = model_input_flux_HKMPM.VPD;
VPD_gaps = flux_data_30min_HKMPM.Time(isnan(model_input_flux_HKMPM.VPD_gf));
model_input_flux_HKMPM.VPD_gf(VPD_gaps) = ERA5_data_30min_HKMPM.ERA5_ST(VPD_gaps);
model_input_flux_HKMPM.VPD_gf = ERA5_data_30min_HKMPM.ERA5_VPD;

%P
model_input_flux_HKMPM.P_gf = model_input_flux_HKMPM.P;
P_gaps = flux_data_30min_HKMPM.Time(isnan(model_input_flux_HKMPM.P_gf));
model_input_flux_HKMPM.P_gf(P_gaps) = ERA5_data_30min_HKMPM.ERA5_TP(P_gaps);

%WS
model_input_flux_HKMPM.WS = ERA5_data_30min_HKMPM.ERA5_WS;

%Turb
model_input_flux_HKMPM.Turb = ERA5_data_30min_HKMPM.ERA5_Turb;

%NetRad
model_input_flux_HKMPM.NetRad_gf = model_input_flux_HKMPM.NetRad;
NetRad_gaps = flux_data_30min_HKMPM.Time(isnan(model_input_flux_HKMPM.NetRad_gf));
model_input_flux_HKMPM.NetRad_gf(NetRad_gaps) = ERA5_data_30min_HKMPM.ERA5_NetRad(NetRad_gaps);
%model_input_flux.NetRad = ERA5_data_30min.ERA5_NetRad;



%%% create running sum of precipitation data
% 30 day moving sum
model_input_flux_HKMPM.P_gf_runningsum = movsum(model_input_flux_HKMPM.P_gf,(30*48));

clear P_gaps SW_IN_gaps TS_gaps TA_gaps VPD_gaps NetRad_gaps







%%%%%%%%%%%%%%%%%%%%%%% read in SRS6 MODIS data

MODIS_data_SRS6 = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\MODIS_data_SRS6.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
%%% make datetime variable
MODIS_data_SRS6.Time = datetime(compose("%d",MODIS_data_SRS6.Time),'InputFormat','yyyyMMddHHmm');

MODIS_data_SRS6 = table2timetable(MODIS_data_SRS6);




MODIS_data_30min_SRS6 = retime(MODIS_data_SRS6, time_array_SRS6,'nearest');





%%%%%%%%%%%%%%%%%%%%%%% read in HKMPM MODIS data

MODIS_data_HKMPM = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\MODIS_data_HKMPM.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
%%% make datetime variable
MODIS_data_HKMPM.Time = datetime(compose("%d",MODIS_data_HKMPM.Time),'InputFormat','yyyyMMddHHmm');

MODIS_data_HKMPM = table2timetable(MODIS_data_HKMPM);




MODIS_data_30min_HKMPM = retime(MODIS_data_HKMPM, time_array_HKMPM,'nearest');




%%%%%%%%%%%%%%%%%%%%%%% make SRS6 DOY varaible
DOY_SRS6 = day(time_array_SRS6,'dayofyear');
DOY_SRS6 = timetable(time_array_SRS6,DOY_SRS6);





%%%%%%%%%%%%%%%%%%%%%%% make HKMPM DOY varaible
DOY_HKMPM = day(time_array_HKMPM,'dayofyear');
DOY_HKMPM = timetable(time_array_HKMPM,DOY_HKMPM);











%%%%%%%%%%%%%%%%%%%%%%% complex RF model for NEE


X_input_NEE_complex_SRS6 = table(model_input_flux_SRS6.TA_gf,model_input_flux_SRS6.TS_gf,model_input_flux_SRS6.SW_IN_gf,model_input_flux_SRS6.NetRad,MODIS_data_30min_SRS6.NDVI,'VariableNames',["TA","TS","SW_IN","NetRad","NDVI"]);
X_input_NEE_complex_HKMPM = table(model_input_flux_HKMPM.TA_gf,model_input_flux_HKMPM.TS_gf,model_input_flux_HKMPM.SW_IN_gf,model_input_flux_HKMPM.NetRad,MODIS_data_30min_HKMPM.NDVI,'VariableNames',["TA","TS","SW_IN","NetRad","NDVI"]);


model_target_NEE_complex_SRS6 = flux_data_SRS6.NEE;
model_target_NEE_complex_HKMPM = flux_data_HKMPM.NEE;


%%% join SRS6 and HKMPM data
X_input_NEE_complex = [X_input_NEE_complex_SRS6;X_input_NEE_complex_HKMPM];
model_target_NEE_complex = [model_target_NEE_complex_SRS6;model_target_NEE_complex_HKMPM];





%code to auto optimize paramaters
%Mdl_NEE =
%fitrensemble(X_input_NEE_complex,model_target_NEE_complex,'OptimizeHyperparameters',{'NumLearningCycles','MaxNumSplits','MinLeafSize'},'Method','Bag')

%%%%% run NEE model
t_NEE_complex = templateTree('NumVariablesToSample','all','PredictorSelection','interaction-curvature','Surrogate','off','MaxNumSplits',102030,'MinLeafSize',3);
rng(1); % For reproducibility
Mdl_NEE_complex = fitrensemble(X_input_NEE_complex,model_target_NEE_complex,'Method','Bag','NumLearningCycles',448,'Learners',t_NEE_complex)%,'CrossVal','on');





%Predictor Importance Estimation

impOOB_NEE = oobPermutedPredictorImportance(Mdl_NEE_complex);





figure
bar(impOOB_NEE)
title('Unbiased Predictor Importance Estimates')
xlabel('Predictor variable')
ylabel('Importance')
h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';




%%% RF NEE model gapfilling, used for model stats
NEE_model_complex = predict(Mdl_NEE_complex,X_input_NEE_complex);



%%% complex RF NEE model stats

%%% optimize paramaters stat results
%%%                184 learning cycles, 10430 splits, 3 min leaf size, all variables: oobR2=0.4449, ibR2=0.8278
%%%                300 learning cycles, 76025 splits, 4 min leaf size, all variables: oobR2=0.4491 ibR2=0.8094
%%%                448 learning cycles, 102030 splits, 3 min leaf size, all variables: oobR2=0.4496 ibR2=0.8291
%%%
%%%                448 learning cycles, 102030 splits, 3 min leaf size, no VPD and LAI: oobR2=0.4454 ibR2=0.8246
%%%                448 learning cycles, 102030 splits, 3 min leaf size, no VPD, LAI, WS, Turb, P, DOY: oobR2=0.4275 ibR2=0.8083


%%% RF NEE model stats
%%% ran OptimizeHyperparameters code using all varaibles
yHat_complex = oobPredict(Mdl_NEE_complex);
NEE_complex_R2_oob = corr(Mdl_NEE_complex.Y,yHat_complex)^2
NEE_complex_R2 = corr(model_target_NEE_complex,NEE_model_complex,'rows','complete')^2









%%% complex NEE model and NEE data plot
%figure
%hold on
%plot(model_target_NEE_complex)
%plot(NEE_model_complex)





%%%% output RF NEE Mdl file

saveLearnerForCoder(Mdl_NEE_complex,'Mdl_NEE_ALLFLUX');

