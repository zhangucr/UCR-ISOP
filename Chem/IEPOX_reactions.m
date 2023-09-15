
SpeciesToAdd = {...
'IEPOXOS';'TETROLS';'TETROLSp';'MGAOS'; % added by chuanyang; related to IEPOX SOA
};

AddSpecies

%% IEPOX-SOA formation
i=i+1;
Rnames{i} = 'IEPOXB = IEPOXOS';
% k(:,i)= F0AM_isop_Khet(T,Rp,Sa);
k(:,i)=Khet_OS;
Gstr{i,1}='IEPOXB';
fIEPOXB(i)=fIEPOXB(i)-1; fIEPOXOS(i)= fIEPOXOS(i)+1;

i=i+1;
Rnames{i} = 'IEPOXB = TETROLSp';
% k(:,i)= F0AM_isop_Khet(T,Rp,Sa);
k(:,i)=Khet_TT;
Gstr{i,1}='IEPOXB';
fIEPOXB(i)=fIEPOXB(i)-1; fTETROLSp(i)= fTETROLSp(i)+1;

i=i+1;
Rnames{i} = 'IEPOXD = IEPOXOS';
% k(:,i)= F0AM_isop_Khet(T,Rp,Sa);
k(:,i)=Khet_OS;
Gstr{i,1}='IEPOXD';
fIEPOXD(i)=fIEPOXD(i)-1; fIEPOXOS(i)= fIEPOXOS(i)+1;

i=i+1;
Rnames{i} = 'IEPOXD = TETROLSp';
% k(:,i)= F0AM_isop_Khet(T,Rp,Sa);
k(:,i)=Khet_TT;
Gstr{i,1}='IEPOXD';
fIEPOXD(i)=fIEPOXD(i)-1; fTETROLSp(i)= fTETROLSp(i)+1;

%% IHMML-SOA formation
i=i+1;
Rnames{i} = 'IHMML = MGAOS';
% k(:,i)= F0AM_isop_Khet(T,Rp,Sa);
k(:,i)=Khet_MGAOS;
Gstr{i,1}='IHMML';
fIHMML(i)=fIHMML(i)-1; fMGAOS(i)= fMGAOS(i)+1;

i=i+1;
Rnames{i} = 'IHMML = MGA';
% k(:,i)= F0AM_isop_Khet(T,Rp,Sa);
k(:,i)=Khet_MGA;
Gstr{i,1}='IHMML';
fIHMML(i)=fIHMML(i)-1; fMGA(i)= fMGA(i)+1;









