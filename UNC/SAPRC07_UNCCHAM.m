% SAPRC07_UNCCHAM.m
% UNC chamber dependent reactions. generated from UNCCHAM.RXN
% 20210628
% # of species = 
% # of reactions = 

WALLOH = 2.5E-3;
WALLNO2 = 0.0;
WH2O = RH./100.*exp(26.71264+(-0.0092004.*T)-(6113.89./T)).*6.02e23./83144.126./T.*(2e-3.*RH+403.43.*exp(-600./RH));

SpeciesToAdd = {...
'BVOC'; 'WHNO3'};

AddSpecies

i=i+1;
Rnames{i} = ' = 0.50*CO + 0.07*O3 + 0.55*H2 + 1.79*CH4 + 0.002*HCHO + 0.045*BVOC ';
k(:,i) =  1.0.* kdil.*P.*6.02e8/8.314./T;
%Gstr{i,1} = ''; 
fCO(i)=fCO(i)+0.5; fO3(i)=fO3(i)+0.07; fH2(i)=fH2(i)+0.55; fCH4(i)=fCH4(i)+1.79; fHCHO(i)=fHCHO(i)+0.002; fBVOC(i)=fBVOC(i)+0.045;

i=i+1;
Rnames{i} = ' OH +BVOC = 0.667*MEO2 + 0.167*MECO3 ';
k(:,i) =  3.0078e-12;
Gstr{i,1} = 'OH'; Gstr{i,2} = 'BVOC'; 
fOH(i)=fOH(i)-1; fBVOC(i)=fBVOC(i)-1; fMEO2(i)=fMEO2(i)+0.667; fMECO3(i)=fMECO3(i)+0.167;

i=i+1;
Rnames{i} = ' NO2 = HONO ';
k(:,i) =  WALLOH.*JNO2_06;
Gstr{i,1} = 'NO2';
fNO2(i)=fNO2(i)-1; fHONO(i)=fHONO(i)+1;

i=i+1;
Rnames{i} = ' NO2 = 0.50*HONO + 0.50*WHNO3 ';
k(:,i) =  2.6667E-6;
Gstr{i,1} = 'NO2';
fNO2(i)=fNO2(i)-1; fHONO(i)=fHONO(i)+0.5; fWHNO3(i)=fWHNO3(i)+0.5;

i=i+1;
Rnames{i} = ' WHNO3 = NO2 ';
k(:,i) =   WALLNO2.*JNO2_06;
Gstr{i,1} = 'WHNO3';
fWHNO3(i)=fWHNO3(i)-1; fNO2(i)=fNO2(i)+1; 

i=i+1;
Rnames{i} = ' N2O5 = 2.0*WHNO3 ';
k(:,i) =   4.167E-5;
Gstr{i,1} = 'N2O5';
fN2O5(i)=fN2O5(i)-1; fWHNO3(i)=fWHNO3(i)+2; 

i=i+1;
Rnames{i} = ' N2O5 = 2.0*WHNO3 ';
k(:,i) =   WH2O.* 1.557E-22.*exp(2000./T);
Gstr{i,1} = 'N2O5';
fN2O5(i)=fN2O5(i)-1; fWHNO3(i)=fWHNO3(i)+2; 

i=i+1;
Rnames{i} = ' HO2H =  ';
k(:,i) =   6.67E-4;
Gstr{i,1} = 'HO2H';
fHO2H(i)=fHO2H(i)-1; 

i=i+1;
Rnames{i} = ' O3 =  ';
k(:,i) =   2.33E-6;
Gstr{i,1} = 'O3';
fO3(i)=fO3(i)-1; 
