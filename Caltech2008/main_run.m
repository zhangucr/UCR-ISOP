dbstop if error
% clear; clc; close all;

%%  Caltech Chamber
clear; clc; close all;
test_dat = [1 294 5.1 101.6 1000 68.1 23.8
            2 293 4.7 30.2  1000 11.5 13.5
            3 294 5.4 67.1  1000 39.3 20.8
            4 293 6.0 51.7  1000 26.7 18.2
            5 294 5.7 18.4  1000 2.2  4.3
            6 294 5.5 21.8  1000 4.8  7.8
            7 293 5.5 39.5  1000 7.9  7.1
            8 294 6.4 42.0  1000 16.6 14.1];
                 
Caltech_2008_vars = {'Expt','T_avg_C','RH_avg','ISOP_ppbv','N2O5_ppb',...
    'SOA_ugm^3','SOA_yield (%)'};

% id=[8,7,6,5,4,3,2,1];
% id=1:1:8;

for expt=1:8
    expt
    [S1]=ISOP_Caltech2008_UCR_sim(test_dat(expt,:),1);
    % [S2]=ISOP_Caltech2008_Caltech_sim(test_dat(expt,:),1);
    % [S3]=ISOP_Caltech2008_MCM_sim(test_dat(expt,:),1);
    % [S4]=ISOP_Caltech2008_UW_sim(test_dat(expt,:),1);
end
figname=['figures/GP_Caltech2008Expt',num2str(expt),'.jpg'];
%%
close all;
fig1=figure('units','normalized','position',[.1 .05 .85 .85]);
subfig=M_SubFigPos([4,1],'GapY',0.01);
dt=24*3600;
tickdata=0:1/24:5/24;

ax1=axes('position',subfig(1,1).position);
ip=S.Conc.ISOP;
plot(S.Time/dt,ip,'linewidth',2,'color','b');
hold on;
% plot(S2.Time/dt,S2.Conc.ISOP,'b--','linewidth',2);
myplot();
ylabel('isoprene (ppb)');
legend({'UCR'});
% title(['PNNL2018 Expt',num2str(expt)],'fontweight','bold','fontsize',14);

ax2=axes('position',subfig(2,1).position);
% plot(S.Time/dt,S.Conc.ICPE,'r','linewidth',2);
hold on;
plot(S.Time/dt,S.Conc.INPE,'b','linewidth',2);
% plot(S.Time/dt,S.Conc.ICNE,'k','linewidth',2);
% plot(S.Time/dt,S.Conc.ICHE,'g','linewidth',2);
% set(gca,'yscale','log');ylim([0.1,1e2]);
myplot();
ylabel('Conc (ppb)');
legend({'INPE'});
% 

ax3=axes('position',subfig(3,1).position);
plot(S.Time/dt,S.Conc.C10dimer,'c','linewidth',2);
hold on;
plot(S.Time/dt,S.Conc.IHNE,'m','linewidth',2);
% h1=plot(S.Time/dt,S.Conc.NO,'k');hold on;
% h2=plot(S.Time/dt,S.Conc.NO2,'r');
ylabel('Conc (ppb)');
myplot();
legend({'C10dimer','IHNE'});

ax5=axes('position',subfig(4,1).position);
spn=S.particle.names;
PlotConcGroup(spn,S,5);
ylabel('Conc (ug/m^3)');

% ax4=axes('position',subfig(4,1).position);
% m1 = mr_to_ugm3(S.Conc.ICPE,132,1,test_dat(expt,2)).*1e-9; %ppb. assume average MW of OA constituents 175g/mol
% m2 = mr_to_ugm3(S.Conc.INPE,179.13,1,test_dat(expt,2)).*1e-9;
% m3 = mr_to_ugm3(S.Conc.IHNE,163.13,1,test_dat(expt,2)).*1e-9;
% m4 = mr_to_ugm3(S.Conc.ICNE,161.11,1,test_dat(expt,2)).*1e-9;
% m5 = mr_to_ugm3(S.Conc.ICHE,116.13,1,test_dat(expt,2)).*1e-9;
% m6 = mr_to_ugm3(S.Conc.C10dimer,250,1,test_dat(expt,2)).*1e-9;
% m=m1+m2+m3+m4+m5+m6;
% plot(S.Time/dt,m6,'b','linewidth',2);hold on;
% ylabel('C10dimer mass (ug/m^3)');

xlabel('Time');
% myplot();
set(gca,'xtick',tickdata,'xticklabel',datestr(tickdata,'HH'));
xlim([0,5*3600]);
set(gca,'xtick',[0:1:10]*3600);
set(gca,'fontsize',8,'linewidth',2);
% legend({'UCR: ICPDH','C57OOH,C58OOH,C59OOH,C57AOOH,C58AOOH','Caltech: ICPDH'},'fontsize',12);
saveas(gcf,figname);

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
xlim([0,5/24]);

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

