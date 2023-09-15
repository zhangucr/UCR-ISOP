
%%  PNNL 2018
clear; clc; close all;
test_dat = [1   43.5   7.5    0    0    0    0    0     NaN NaN     NaN NaN     10      1      24
                 2   65     7.5    0    0    0    0    0     NaN NaN     NaN NaN     10      1      24
                 3   69     7.5    0    0    0    0    0     NaN NaN     NaN NaN     10      1      24
                 4   56.5   7.5    0    0    0    0    0     NaN NaN     NaN NaN     10      1      24
                 5   51     7.5    0    0    0    0    0     NaN NaN     NaN NaN     10      1      24
                 6   57     7.5    0    0    0    0    0     NaN NaN     NaN NaN     10      1      24
                 7   48.0   7.5    0    0    0    0    0     NaN NaN     NaN NaN     10      1      24];

pnnl_2018_vars = {'Run','C5H8_ppbv','H2O2_ppmv','NO_ppbv','NOx_ppbv','AS_vol_um3_cm3','err_AS_vol','O3_max_ppbv','dOM_max','err_dOM','dOM_final','err_dOM_final','Y','err_Y','T_C'};

% id=[8,7,6,5,4,3,2,1];
id=1:1:7;
for expt=1:7
    [S]=ISOP_Gas_PNNL2018_UCR_sim(test_dat(expt,:),1);
end
% [S2]=ISOP_Gas_PNNL2018_Joel_sim(test_dat(expt,:),1);
% [S3]=ISOP_Gas_PNNL2018_Caltech_sim(test_dat(expt,:),1);
% [S4]=ISOP_Gas_PNNL2018_UCR2_sim(test_dat(expt,:),1);

