clear; clc; close all;
load('./SOAS_data_clean.mat');

% cd('/Users/cyshen/Documents/ucr/isoprene/F0AM-WAM-2020-distribute/Setups/Isoprene mechanism');


Do_GP=1;
SZA=Dclean.zenith;
SZA(SZA>90)=90;

iC5H8 = Dclean.isop;%ppb

iNO = Dclean.NO;%ppb
iNO2 = Dclean.NO2; %ppb
iO3= Dclean.O3;
iHO2= 10^-3*Dclean.HO2_final;
iRO2=10.^-3*Dclean.RO2_cmaq;
iOA=Dclean.OA;% ug/m^3

KT = Dclean.T;
KP = 1013; %ASSUME 1ATM pressure
RH = Dclean.RH;

% iOH=10^-3*Dclean.OH;
M=NumberDensity(KP,KT);
iOH=Dclean.OH./M.*1e9; % to ppb;

Nc=Dclean.totn;
totv=Dclean.totv+Dclean.LWC;
Rp = 1e-4*(3*totv./(4*pi*Nc)).^(1/3); % cm
% % Rp=3*10^-4*totv./Dclean.tots; % cm  ambient radius including water
% SAi=Dclean.tots*10^-8; % cm^2/cc
SAi = Nc.*4.*pi.*Rp.^2;

lwc_org=0.1*Dclean.LWC;
lwc_inorg=0.9*Dclean.LWC;
Vinorg=nansum(Dclean.GTams(:,[1,2,3,5]),2)./1.6+lwc_inorg;
Vorg=Dclean.GTams(:,4)./1.2+lwc_org;
Vt=Vinorg+Vorg;
Rcore=Rp.*(Vinorg./Vt).^(1/3);
Rshell=Rp-Rcore;

%% calculate the reactive uptake rate of IEPOX
Cdata=load('SOAS_isorropia.mat');

ah=Cdata.ah;
ah2=10.^(-D.pH);

nuc=Cdata.nuc;
ga=Cdata.ga;

% [Khet,gamma_iepox]=F0AM_isop_Khet(KT,Rp,Rcore,SAi,ah,nuc,ga);
Q=interp1([15,30,50],[1,1.2,1.6]*1e-7,RH,'linear','extrap');

[Khet,gamma_iepox]=F0AM_isop_Khet(KT,Rp,Rcore,SAi,ah,nuc,ga,Q);
% [Khet2,gamma_iepox2]=F0AM_isop_Khet(KT,Rp,Rcore,SAi,ah2,nuc,ga);


kh=0.036; % reaction rate due to acid-catalyzed ring-opening. unit: M-1s-1;
knuc=2e-4; % reaction rate due to the presence of specific nucleophiles: /(M*S);
kga=7.3e-4; % reaction rate due to presence of general acids;
Kaq=kh.*ah+knuc.*nuc.*ah+kga.*ga; % Eddingsaas et al.
beta=knuc.*nuc.*ah./Kaq;

Khet_OS=Khet.*beta;
Khet_TT=Khet.*(1-beta);
Khet_OSclean=ReplaceNaN(Khet,D.time);
Khet_TTclean=ReplaceNaN(Khet,D.time);
%% determine the dilution rate day-by-day
val=200:1032;

% Hmax=max(Dclean.BLH);
% kdil=8*Dclean.BLH./Hmax;

time=D.time;
time_shift=time-6/24;
iday=floor(time_shift)-floor(time_shift(1))+1;

Hmax=nan(size(time));
for i=1:44
    cond=(iday==i);
    Hmax(cond)=max(Dclean.BLH(cond));
end
Cday=[8,8,8,8,8,8,8,8,8,4,...
      40,7,7,5,14,    40,20,10,5,8,...%0622
      12,9,15,20,20,  15,40,30,8,3,...%22;23;24;25;26;  27;28;29;30;1
      8,15,8,13,12,   10,8,6,15,12,...% 2,3,4,5,6; 7,8,9,10,11; 
      8,8,10,7]; %12,13,14,15;
  
 C=nan(size(time));
for i=1:44
    cond=(iday==i);
    C(cond)=Cday(i);
end
kdil=C.*Dclean.BLH./Hmax;

savename='E:\ucr\scy\SOAS\output\SOAS_UCR_0125_Qvary_isrp.mat';

% if Do_GP
%     savename=['/Users/cyshen/Documents/ucr/isoprene/SOAS/SOAS_UCR.mat'];
% else
%     savename=['C:\Users\tiann\Desktop\scy\Thornton_Matlab_Figures_Data\output\Gas_Expt',...
%         num2str(expt),'_UCR.mat'];
% end
%% METEOROLOGY

Met = {...
%   names       values          
    'P'         KP; %Pressure, mbar
    'T'         KT(val); %Temperature, K
    'RH'        RH(val); %Relative Humidity, percent
    'SZA'       SZA(val);
    'Nc'        Nc(val);
    'Rp'        Rp(val);  %cm
    'Sa'        SAi(val); % cm^2/cc
    'Khet_OS'   Khet_OSclean(val);
    'Khet_TT'   Khet_TTclean(val);
    'Cstar_threshold' 100;...   %Cstar threshold to filter compounds that can partition. ug/m3
    'kwall_loss'    0 ;... % default value of 2.5e-5;
    'kwall_lossV'   0 ;...
%     'LFlux'     'ExampleLightFlux.txt'; %Text file for radiation spectrum
%     'JNO2_06'   0.29./60; % J4 ' NO2 + hv = NO + O3P 'Source: "JL0309_SAP07U10", column 1.
%     'JNO3NO_06' 2E-4; % J5 ' NO3 + hv = NO ' Source: "JL0309_SAP07U10", column 4.
%     'JNO3NO2_6' 4.6E-4; %J6   NO3 + hv = NO2+ OH ' Source: "JL0309_SAP07U10", column 5.
%     'JH2O2'     0.000175./60;  %J3  H2O2 + hv= OH + OH '  Source: "JL0309_SAP07U10", column 9.
    'kdil'      kdil(val)./(24*3600);       %dilution constant, /s
    'JHNO4_06'  0;
    'JPAN'      0;
    'JBALD_06'  0;
    'JCL2'      0;
    'JPAA'      0;
    'JACRO_09'  0;
    'JCLNO_06'  0;
    'JCLONO'    0;
    'JCLNO2'    0;
    'JCLONO2_1' 0;
    'JCLONO2_2' 0;
    'JHOCL_06' 0;
    'JCLCCHO' 0;
    'JCLACET'    0;
%     'EF_C5H8'   0  ;...          %emission factor to supply isoprene, continuous flow
%     'EF_H2O2'   0  ;...          %emission factor to supply H2O2, continuous flow
%     'EF_NO'     0  ;...  
    };
Nseed=Nc;
%% CHEMICAL CONCENTRATIONS
% Rp=25e-7;% unit of cm, corresponds to 10nm
Vseed=Dclean.totv*10^-12; % cm^2/cc
MWoa_init = 175;
Coa_ugm3 = .002;
iCoa = ugm3_to_mr(Coa_ugm3,MWoa_init).*1e9; %ppb. assume average MW of OA constituents 175g/mol
iOA_ppb=ugm3_to_mr(iOA,MWoa_init).*1e9;

InitConc = {...
%   names       conc(ppb)           HoldMe
    'ISOP'      iC5H8(val)           1;
    'OH'        iOH(val)            1;
    'HO2'       iHO2(val)           1;
    'NO'        iNO(val)             1;
    'NO2'       iNO2(val)            1;
    'O3'        iO3(val)               1;
%     'RO2'       iRO2(val)              1;
%     'CO'        0               1;   % ?
    'OA'        iOA_ppb(val)        1;        
    'ttlOA'     iCoa            0;
    'OAinit'    iCoa            0;
    };

seedValues = {...
    'Rp'         Rp(val)                  0;...    %initial seed radius (cm)
    'SA'         SAi(val)                   0;...    %initial seed surface area (cm2/cm3)
    'Vseed'      Vseed(val)                 0;...    %initial seed volume (cm3/cm3)
    'Nseed'      Nseed(val)                 0;...    %initial number of seed particles
    'MWoa_init'   MWoa_init             0;...
    };
%% PARTICLE INITIALIZATION
%     Nseed = 1e3; %number seed per cm3
%     Rp = 25e-7; %seed particle radius (cm) (assuming 50nm diameter seed particles)
%     SAi = Nseed.*4*pi*(Rp)^2; %initial seed surface area cm2/cm3
%     Vseed = SAi.*Rp./3; %initial seed volume cm3/cm3
%     Dg = 0.05; % gas-phase diffusivity, cm2/s
%     MWoa_init = 175; %guess at average OA molecular mass (gets updated in model)
%     Coa_ugm3 = .002; %initial OA (ug/m3). going down to .001 throws errors, this is the lowest we can go    
%     gamma = 1;
%     %Note, if you change gamma (e.g. mass accommodation coefficient) you should also change ModelOptions.GPupdateTime to 10
%     %for gama = 1, recommed use ModelOptions.GPupdateTime = 10, otherwise computation errors result from stiff equations.
    
%% CHEMISTRY
ChemFiles = {...
    'SAPRC07tic_K(Met)';
    'SAPRC07tic_J(Met,0)'; %Jmethod flag of 1 specifies using "BottomUp" J-value method.
    %'SAPRC07tic_woisop'; %SAPRC07 basic reactions without isoprene chemistry
    %'SAPRC07tic_ISOP_UCR2021c4'; % condensed isoprene rxns
    'SAPRC07tic_UCR2022_isop_field';
%     'SAPRC07_UNCCHAM'; % UNC chamber specific reactions
%     'SAPRC07tic_ISOP_GP_partitioning';
    };
ParticleChemFiles= {'Isoprene_particle_chem_ucr2022_field'};
% ParticleChemFiles= {};
%% Vapor Pressures // Molecular Mass // SMILES
% To run gas-particle partitioning module, you will need to have a
% saturation vapor concentration ("Cstar") for each specie you want to
% participate in the gas-particle partitioning. You can set a threshold
% Cstar above which the species is excluded from gas-particle partitioning.
% This helps the model run faster by limiting the number of species requiring the more intensive
% calculations

%If this is the first time running the model, you will need to find and
% possibly create two files (1) a .mat file containing info on each species
% "...SpeciesInfo.mat" and (2) an excel file containing the vapor pressures for
% each species. For the latter you may need to run
% GetSMILESforVaporPressure.m first which will create a third file (SMILES.txt). These files are usually in
% ...\Tools\SMILES\.

% matfile='C:\Users\tiann\desktop\scy\F0AM-WAM-2020-distribute\Tools\SMILES\UCR2022_isop_SpeciesInfo_v2.mat';
% Vpfile = 'C:\Users\tiann\desktop\scy\F0AM-WAM-2020-distribute\Tools\SMILES\UCR2022_isop_VaporPressure_v2.xlsx'; %full path to the vapor pressure file

matfile='..\F0AM-WAM-2020-distribute\Tools\SMILES\UCR2022_isop_SpeciesInfo_v7.mat';
Vpfile = '..\F0AM-WAM-2020-distribute\Tools\SMILES\UCR2022_isop_VaporPressure_v7.xlsx'; %full path to the vapor pressure file


%% DILUTION CONCENTRATIONS
% We are not diluting the chamber air, so this input is irrelevant (but still necessary).
BkgdConc = {...
%   names           values
    'DEFAULT'       0;   %0 for all zeros, 1 to use InitConc
    };

%%
wall_params.wcstar_thresh = 1E6; %cstar threshold to invoke wall partitioning
%equivalent absorbing organic concentration of the wall material C_wall
%in ug/m3. 
%Use C_wall = [] if you want to use the Krechmer et al parameterization based on c*'s. See F0AM_WallPartitioning_Generator.m
%Otherwise the C_wall value you enter here will be used for all
%species.  
wall_params.C_wall = []; %30000; %equivalent wall absorbing mass concentration ug/m3  
wall_params.kwall_transport = 1e-5; %per second timescale to mix vapors to/from wall surface  default value 1e-5;
  

GPstruct.seedValues = seedValues;
GPstruct.gama = 1;
GPstruct.wall_params = wall_params;
GPstruct.Vpfile = Vpfile;
GPstruct.matfile = matfile;

%% OPTIONS
ModelOptions.Verbose       = 1;
ModelOptions.EndPointsOnly = 1;
ModelOptions.LinkSteps     = 1;
ModelOptions.IntTime       = 1*3600; % in seconds
ModelOptions.SavePath      = savename;
ModelOptions.GPupdateTime  = 10*60;
ModelOptions.SA            = 1;
ModelOptions.Do_Wall_Partitioning = 0;
ModelOptions.Do_Dry_Deposition=1;
% ModelOptions.GoParallel    = 0;
%% MODEL RUN
% SAPRC07tic_UCRisopc_output = F0AM_ModelCore(Met,InitConc,ChemFiles,BkgdConc,ModelOptions);
% Do GP;
if Do_GP
    S=F0AM_ModelCore_D_GP(GPstruct,Met,InitConc,ChemFiles,ParticleChemFiles,BkgdConc,ModelOptions);
else
% Do gas phase;
    ModelOptions = rmfield(ModelOptions,{'GPupdateTime','Do_Wall_Partitioning','SA'});
%     Met=rmfield(Met,{'Nc'});
    rmi = strmatch('kwall_loss',Met(:,1)); 
    rmj = strmatch('Cstar_threshold',Met(:,1)); 
    rmk = strmatch('Nc',Met(:,1));
    rm = union(rmi,rmj);
    rm = union(rm,rmk);
    Met = Met(~ismember(1:length(Met),rm),:);
    S = F0AM_ModelCore(Met,InitConc,ChemFiles,BkgdConc,ModelOptions);
end

%% plotting DATA
close all;

D=load('SOAS_data.mat');

time=Dclean.time1(:,1);
S.TimeRaw=S.Time;
S.Time=time(val);
timelim=[S.Time(1),S.Time(end)];

subpos=M_SubFigPos([6,1],'Head',.07,'Right',.12);
fig1=figure('unit','normalized','position',[.15 .05 .8 .85]);
ax1=axes('position',subpos(1,1).position);
% plot(time(val),iC5H8(val),'k');
plot(time(val),D.isop(val),'k');
hold on;
plot(time(val),iNO(val),'r');
plot(time(val),iNO2(val),'b');
myplot();
set(gca,'xaxislocation','top');
ylabel('Isop (ppb)');
legend({'isop','no','no2'});
xlim(timelim);
% title('kdil=1/6h');

ax2=axes('position',subpos(2,1).position);
plot(time(val),D.OH(val),'k','linewidth',2);
hold on;
% plot(time(val),iOH(val),'b','linewidth',1);
myplot();
ylabel('OH (ppb)');
set(gca,'xticklabel',{});
xlim(timelim);
% legend({'measured','fitted data'});

ax20=axes('position',subpos(2,1).position);
plot(time(val),kdil(val),'r','linewidth',2);
myplot();
set(gca,'color','none','yaxislocation','right');
ylabel('k');
set(gca,'xticklabel',{},'ycolor','r');
xlim(timelim);

% ax3=axes('position',subpos(3,1).position);
% plot(time(val),iOA(val),'k','linewidth',2);
% myplot();
% ylabel('OA (ug/m^3)');
% set(gca,'xticklabel',{});
% xlim(timelim);
ax3=axes('position',subpos(3,1).position);
plot(time(val),D.isopooh(val),'k+','linewidth',1,'markersize',1);
hold on;
y=S.Conc.ISOPOOH12+S.Conc.ISOPOOH43+S.Conc.ISOPOOHD;
plot(time(val),1000*y,'r-','linewidth',1);
% plot(time(val),D.MACR(val),'r+','linewidth',1,'markersize',1);
% plot(time(val),S.Conc.MACR,'r-','linewidth',1);
myplot();
ylabel('ISOPOOH (ppt)');
set(gca,'xticklabel',{});
xlim(timelim);
legend({'measured','modelled'});


% legend({'Org_AMS','ISOP-SOA'});

ax5=axes('position',subpos(5,1).position);
plot(time(val),D.MVK(val)+D.MACR(val),'k+','linewidth',1,'markersize',1);
hold on;
plot(time(val),S.Conc.MVK+S.Conc.MACR,'r-','linewidth',1);
% plot(time(val),D.MACR(val),'r+','linewidth',1,'markersize',1);
% plot(time(val),S.Conc.MACR,'r-','linewidth',1);
myplot();
ylabel('MVK+MACR');
set(gca,'xticklabel',{});
xlim(timelim);
% legend({'MVK+MACR measured','modelled'});


ax4=axes('position',subpos(4,1).position);
plot(time(val),D.iepox(val),'k+','linewidth',1,'markersize',1);
hold on;
plot(time(val),(S.Conc.IEPOXB+S.Conc.IEPOXD)*1000,'r-','linewidth',1);
% plot(time(val),D.MACR(val),'r+','linewidth',1,'markersize',1);
% plot(time(val),S.Conc.MACR,'r-','linewidth',1);
myplot();
ylabel('IEPOX (ppt)');
set(gca,'xticklabel',{},'ytick',[0:200:500]);
xlim(timelim);
ylim([0,500]);
% legend({'measured','modelled'});
% ax4=axes('position',subpos(4,1).position);
% % ax5=axes('position',subpos(5,1).position);
% % spn=S.particle.names;
% % spn{1}=[];spn{6}=[];spn{8}=[];spn{9}=[];
% % val=[2,3,4,5];
% % spn=spn{val};
% % num=numel(spn);
% % % spn{num+1}='IEPOXSOA';
% spn={'IDHPEp','ICPDHp','IDHDPp','ICTPp','IEPOXSOA'};
% PlotConcGroup(spn,S,4);
% myplot();
% ylabel('Conc (ug/m^3)');
% xlim(timelim);
% set(gca,'xticklabel',{});
% xlabel('');
% hold on;
t1=D.time2(:,1); t2=D.time2(:,2); dt=t2-t1;
% plot(t1+2/3*dt,D.SOA_isop,'r','linewidth',2);


ax6=axes('position',subpos(6,1).position);
% spn={'IEPOXSOA'};
spn={'IDHPEp','ICPDHp','IDHDPp','ICTPp','TETROLSp','IEPOXOS'};

PlotConcGroup(spn,S,6);
myplot();
ylabel('Conc (ug/m^3)');
xlim(timelim);
hold on; grid on;
plot(t1+1/2*dt,D.SOA_isop,'c','linewidth',2);
plot(time(val),D.iepox_ams(val),'k+','linewidth',2);
ylim([0,4]);
set(gca,'ytick',[0:2:6]);

hl=legend();
hl.String{7}='ipSOA (filter)';
hl.String{8}='iepox-SOA(AMS)';
hl.Position=[.91 .11 .05 .15];

