% dbstop if error
% clear; clc; close all;

%%  Caltech2019 Chamber: High-NOx condition
clear; clc; close all;
test_dat = [1 59 585 6 118 0 0 25.6 5.0 2.6e6 0
            2 58 526 20 117 54 1170 26.4 5.6 2.5e6 0.04
            3 57 519 17 117 183 3420 25.9 7.5 2.5e6 0.17
            4 58 518 18 116 337 5770 26.4 7.9 2.4e6 0.16
            5 55 506 20 117 159 2830 12.8 16.4 1.7e6 0.15
            6 56 541 16 118 152 2660 32.4 5.9 2.7e6 0.16
            7 40 527 18 117 197 3580 25.9 8.1 2.6e6 0.18
            8 60 519 20 118 109 1790 25.5 44.7 2.3e6 nan
            9 55 489 20 119 166 2750 25.6 78.1 2.5e6 nan
            10 58 516 17 111 85 1580 25.8 5.1 2.2e6 0.04
            11 56 490 17 115 264 4770 25.8 5.2 2.4e6 0.16];
                 
Caltech_2019_vars = {'Expt','ISOP_ppbv','NO_ppb','NO2_ppbv',...
    'CH3ONO_ppbv','Aero_vol_um3_cm3','Aero_SA_um2_cm3',...
    'T_avg_C','RH_avg','OH_molec_cc','SOA_yield'};

% id=[8,7,6,5,4,3,2,1];
id=1:1:11;
expt=1;
for expt=1:11
    [S1]=ISOP_Caltech2019_UCR_sim(test_dat(expt,:),0);
    % [S2]=ISOP_Caltech2019_Caltech_sim(test_dat(expt,:),0);
    % [S3]=ISOP_Caltech2019_MCM_sim(test_dat(expt,:),0);
    % [S4]=ISOP_Caltech2019_UW_sim(test_dat(expt,:),0);
end
% figname=['model_figures/0922_Gas_PNNL2018Expt',num2str(expt),'.jpg'];
%%
close all;
fig1=figure('units','normalized','position',[.1 .05 .85 .85]);
subfig=M_SubFigPos([5,1],'GapY',0.01);
dt=24*3600;
tickdata=0:1/24:10/24;

ax1=axes('position',subfig(1,1).position);
ip=S1.Conc.ISOP;
plot(S.Time/dt,ip,'linewidth',2,'color','b');
hold on;
plot(S2.Time/dt,S2.Conc.ISOP,'b--','linewidth',2);
myplot();
ylabel('isoprene (ppb)');
legend({'UCR','Caltech'});
% title(['PNNL2018 Expt',num2str(expt)],'fontweight','bold','fontsize',14);

ax2=axes('position',subfig(2,1).position);
plot(S.Time/dt,S.Conc.O3,'linewidth',2,'color','b');
hold on;
plot(S2.Time/dt,S2.Conc.O3,'b--','linewidth',2);
% plot(S3.Time/dt,S3.Conc.O3,'linewidth',2,'color','m');
% plot(S4.Time/dt,S4.Conc.O3,'linewidth',2,'color','m');
myplot();
ylabel('O3 (ppb)');

ax3=axes('position',subfig(3,1).position);
y=S.Conc.MVK+S.Conc.MACR;
y2=S2.Conc.MVK+S2.Conc.MACR;
plot(S.Time/dt,y,'linewidth',2,'color','b'); hold on;
plot(S2.Time/dt,y2,'b--','linewidth',2);
myplot();
ylabel('MVK+MACR (ppb)');
% 

ax4=axes('position',subfig(4,1).position);
% plot(S.Time/dt,S.Conc.IEPOXB+S.Conc.IEPOXD,'linewidth',2,'color','b'); hold on;
h1=plot(S.Time/dt,S.Conc.NO,'k');hold on;
plot(S2.Time/dt,S2.Conc.NO,'k--');
h2=plot(S.Time/dt,S.Conc.NO2,'r');
plot(S2.Time/dt,S2.Conc.NO2,'r--');
ylabel('NO/NO2 (ppb)');
myplot();
legend([h1,h2],{'NO','NO2'});

% ax5=axes('position',subfig(5,1).position);
% spn=S.particle.names;
% PlotConcGroup(spn,S,5);
% ylabel('Conc (ug/m^3)');

ax5=axes('position',subfig(5,1).position);
m1 = mr_to_ugm3(S.Conc.IDHDN,226,1,26+273).*1e-9; %ppb. assume average MW of OA constituents 175g/mol
m2 = mr_to_ugm3(S.Conc.IDHPN,197,1,26+273).*1e-9;
m3 = mr_to_ugm3(S.Conc.ICHDN,224,1,26+273).*1e-9;
m4 = mr_to_ugm3(S.Conc.ICHNP,195,1,26+273).*1e-9;
m5 = mr_to_ugm3(S.Conc.IDHCN,179,1,26+273).*1e-9;
m6 = mr_to_ugm3(S.Conc.C10dimer,250,1,26+273).*1e-9;
m=m1+m2+m3+m4+m5+m6;

m1 = mr_to_ugm3(S2.Conc.IDHDN,226,1,26+273).*1e-9; %ppb. assume average MW of OA constituents 175g/mol
m2 = mr_to_ugm3(S2.Conc.IDHPN,197,1,26+273).*1e-9;
m3 = mr_to_ugm3(S2.Conc.ICHDN,224,1,26+273).*1e-9;
m4 = mr_to_ugm3(S2.Conc.ICHNP,195,1,26+273).*1e-9;
m5 = mr_to_ugm3(S2.Conc.IDHCN,179,1,26+273).*1e-9;
mm=m1+m2+m3+m4+m5;

% plot(S.Time/dt,S.Conc.IDHDN,'linewidth',2);hold on;
% plot(S.Time/dt,S.Conc.IDHPN,'r','linewidth',2);
% plot(S.Time/dt,S.Conc.ICHDN,'b','linewidth',2);
% plot(S.Time/dt,S.Conc.ICHNP,'c','linewidth',2);
% plot(S.Time/dt,S.Conc.IDHCN,'g','linewidth',2);
% plot(S.Time/dt,S.Conc.C10dimer,'m','linewidth',2);
% plot(S.Time/dt,m,'k','linewidth',2);hold on;
% plot(S2.Time/dt,mm,'k--','linewidth',2);
plot(S.Time/dt,S.Conc.IDHDN,'r','linewidth',2);hold on;
plot(S2.Time/dt,S2.Conc.IDHDN,'r--','linewidth',2);
plot(S.Time/dt,S.Conc.IDHCN,'b','linewidth',2);
plot(S2.Time/dt,S2.Conc.IDHCN,'b--','linewidth',2);
myplot()
ylabel('Conc ');
legend({'IDHDN UCR','IDHDN Caltech','IDHCN UCR','IDHCN Caltech'})
% ylim([0,2]);
% legend({'IDHDN','IDHPN','ICHDN','ICHNP','IDHCN','C10dimer','total mass'});


xlabel('Time');
myplot();
set(gca,'xtick',tickdata,'xticklabel',datestr(tickdata,'HH'));
% legend({'UCR: ICPDH','C57OOH,C58OOH,C59OOH,C57AOOH,C58AOOH','Caltech: ICPDH'},'fontsize',12);
% saveas(gcf,figname);

function myplot
% function purtyPlot
% Contains preferred stylings for plots.
% Operates on all axes in the current figure.
% Tweak to your preference.
% 20151101 GMW
fs=8;
ax = findobj(gcf,'Type','axes');
set(ax,'FontSize',fs,'FontWeight','bold','box','on');
set(findobj(gcf,'Type','line'),'LineWidth',2,'MarkerSize',8);
% set(findobj(gcf,'Type','line'),'LineWidth',2);
xlim([0,10/24]);

grid on;
set(gca,'linewidth',2);

for i=1:length(ax)
    axnow = ax(i);
    set(get(axnow,'Xlabel'),'FontSize',fs,'FontWeight','bold');
    set(get(axnow,'Ylabel'),'FontSize',fs,'FontWeight','bold');
    set(get(axnow,'Title'),'FontSize',fs,'FontWeight','bold');
end
tickdata=0:1/24:13/24;

set(gca,'xtick',tickdata,'xticklabel',{});


end

