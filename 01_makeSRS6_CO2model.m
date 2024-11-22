%%% mangrove ch4 multisite project
%%% starting Aug 2024
%%% file for SRS6, make RF NEE model

clear all
close all




%%%%%%%%%%%%%%%%%%%%%%% read in FLUX data
flux_data = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\USTARfiltered_nongapfilled_data_SRS6.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
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
ERA5_data = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\ERA5_data_SRS6.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
%%% make datetime variable
ERA5_data.Time = datetime(compose("%d",ERA5_data.dates),'InputFormat','yyyyMMddHHmm');

ERA5_data = table2timetable(ERA5_data);
ERA5_data.dates = [];



%%% interplote ERA5 and FLUX data to hourly
ERA5_data_30min = retime(ERA5_data, time_array,'linear');
flux_data_30min = retime(flux_data, time_array,'fillwithmissing');








%%% gapfill flux met data with ERA5 data
model_input_flux = timetable(flux_data_30min.Time,flux_data_30min.TA_1_1_1,flux_data_30min.TS_1_1_1,flux_data_30min.SW_IN,flux_data_30min.VPD,flux_data_30min.P,'VariableNames',{'TA','TS','SW_IN','VPD','P'});


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
%model_input_flux.VPD_gf = model_input_flux.VPD;
%VPD_gaps = flux_data_30min.Time(isnan(model_input_flux.VPD_gf));
%model_input_flux.VPD_gf(VPD_gaps) = ERA5_data_30min.ERA5_ST(VPD_gaps);
%%%%%%%%%%%%%%%% there is a problem with the EC VPD
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
model_input_flux.NetRad = ERA5_data_30min.ERA5_NetRad;



%%% create running sum of precipitation data
% 30 day moving sum
model_input_flux.P_gf_runningsum = movsum(model_input_flux.P_gf,(30*48));








%%%%%%%%%%%%%%%%%%%%%%% read in MODIS data

MODIS_data = readtable('C:\Users\der66\Dropbox (YSE)\Yale\FCE projects\mangrove multisite\MODIS_data_SRS6.csv','VariableNamingRule','preserve',"TreatAsMissing","NA");
%%% make datetime variable
MODIS_data.Time = datetime(compose("%d",MODIS_data.Time),'InputFormat','yyyyMMddHHmm');

MODIS_data = table2timetable(MODIS_data);




MODIS_data_30min = retime(MODIS_data, time_array,'nearest');




%%%%%%%%%%%%%%%%%%%%%%% make DOY varaible
DOY = day(time_array,'dayofyear');
DOY = timetable(time_array,DOY);







%%%%%%%%%%%%%%%%%%%%%%% complex RF model for NEE


%all data
%X_input_NEE_complex = table(model_input_flux.TA_gf,model_input_flux.TS_gf,model_input_flux.WS,model_input_flux.Turb,model_input_flux.VPD_gf,model_input_flux.SW_IN_gf,model_input_flux.NetRad,model_input_flux.P_gf_runningsum,complex_model_variables.DOY,complex_model_variables.LAI,complex_model_variables.NDVI,'VariableNames',["TA","TS","WS","Turb","VPD","SW_IN","NetRad","P","DOY","LAI","NDVI"]);
% drop VPD and LAI
%X_input_NEE_complex = table(model_input_flux.TA_gf,model_input_flux.TS_gf,model_input_flux.WS,model_input_flux.Turb,model_input_flux.SW_IN_gf,model_input_flux.NetRad,model_input_flux.P_gf_runningsum,complex_model_variables.DOY,complex_model_variables.NDVI,'VariableNames',["TA","TS","WS","Turb","SW_IN","NetRad","P","DOY","NDVI"]);
% drop VPD and LAI, drop WS, Turb, P, DOY
X_input_NEE_complex = table(model_input_flux.TA_gf,model_input_flux.TS_gf,model_input_flux.SW_IN_gf,model_input_flux.NetRad,MODIS_data_30min.NDVI,'VariableNames',["TA","TS","SW_IN","NetRad","NDVI"]);


model_target_NEE_complex = flux_data.NEE_ut;




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
%NEE_complex_R2 = corr(model_target_NEE_complex,NEE_model_complex,'rows','complete')^2









%%% complex NEE model and NEE data plot
%figure
%hold on
%plot(model_target_NEE_complex)
%plot(NEE_model_complex)





%%%% output RF NEE Mdl file

saveLearnerForCoder(Mdl_NEE_complex,'Mdl_NEE_SRS6');
























