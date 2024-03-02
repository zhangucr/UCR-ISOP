% SAPRC07tic_UCR2023_isop_v9c.m
% The base mechanism was manually converted by Xiaoyan Yang (UCR), based on the saprc07tic_ae7i_aq
% https://github.com/USEPA/CMAQ/tree/0dcfe7b59c7f0d9b08f09a700d31891e237fc305/CCTM/src/MECHS/saprc07tic_ae7i_aq
% Rxns related to isoprene are all moved to the bottom of the
% mechanism. New isoprene rxns are implemented to replace original rxns (commented out)
% Update in v9c compared to v9: 
% (1) Assuming 100% of beta-1,2-INO2 follows FZJ, but other INO2 isomers do not. INO calculated rate
% constant times 0.01 (epoxidation still dominant).
% (2) lower HO2 yields from INO2+NO and INO2 + NO3.

SpeciesToAdd = {...
'NO2'; 'NO'; 'O3P'; 'O2'; 'M'; 'O3'; 'NO3'; 'N2O5'; 'H2O'; 'HNO3'; ...
'O1D'; 'OH'; 'HONO'; 'HO2'; 'CO'; 'CO2'; 'HNO4'; 'HO2H'; 'SO2'; 'SULF'; ...
'H2'; 'MEO2'; 'HCHO'; 'COOH'; 'MEOH'; 'RO2C'; 'RO2XC'; 'XN'; 'MECO3'; 'PAN'; ...
'RCO3'; 'PAN2'; 'xHO2'; 'yROOH'; 'xCCHO'; 'BZCO3'; 'PBZN'; 'BZO'; ...
'XC'; 'MACO3'; 'MAPAN'; 'TBUO'; 'RNO3'; 'ACET'; 'NPHE'; 'CRES'; 'CCHO';'RCHO'; ...
'xCO'; 'xMECO3'; 'xHCHO'; 'MEK'; 'zRNO3'; 'xRCO3'; 'xRCHO'; 'FACD'; 'xMGLY'; 'xBACL'; ...
'ROOH'; 'xOH'; 'xPROD2'; 'R6OOH'; 'PRD2'; 'yR6OOH'; 'RAOOH'; 'MGLY'; 'IPRD'; 'xGLY'; ...
'xMEK'; 'xAFG1'; 'xAFG2'; 'GLY'; 'AFG1'; 'AFG2'; 'BACL'; 'BALD'; 'AFG3'; 'xIPRD'; ...
'xRNO3'; 'xNO2'; 'xACET'; 'CH4'; 'ETHE';  ...
'xMACO3'; 'ACETYLENE'; 'BENZ'; 'yRAOOH'; 'ALK1'; 'ALK2'; 'ALK3'; 'xTBUO'; 'ALK4'; 'xMEO2'; ...
'ALK5'; 'OLE1'; 'OLE2'; 'ARO1'; 'xBALD'; 'xAFG3'; 'TERP'; 'CL2'; 'CL'; ...
'CLNO'; 'CLONO'; 'CLNO2'; 'HCL'; 'CLO'; 'CLONO2'; 'HOCL'; 'xCLCCHO'; 'xCLACET'; 'CLCCHO'; ...
'xCL'; 'CLACET'; 'CLCHO'; 'NONO3'; 'NO3MECO3'; 'MECO3RCO3'; 'RCO3BZCO3'; 'BZCO3MACO3'; 'MACO3MEO2'; 'MEO2RO2C'; ...
'RO2CRO2XC'; 'RO2XCHO2'; 'HO2MEO2'; 'RO2XCNO';'RCOOOH';'RCOOH';'HACET';'HCOCO3';...
'xHOCCHO';'HOCCHO';'ARO2MN'; ...
'BENZRO2';'SOAALK';'SVAVB2';'SVAVB3';'SVAVB4';'ACROLEIN';'CCOOOH';'CCOOH';'TOLRO2';'XYLRO2'; ...'xACROLEIN';
'PAHRO2';'NAPHTHAL';'TRPRXN';'zMTNO3';'TERPNRO2';'SESQ';'SESQRXN';'xACROLEIN';'PROPENE';'BUTADIENE13';'APIN'; ...
'TOLUENE';'MXYL';'OXYL';'PXYL';'TMBENZ124';'ETOH';'PROPNN';'ETHLN';'RNO3I';'MTNO3';'xMTNO3';'SVAVB1';...
% Below are original SAPRC07tic isoprene species that are retained.
'ISOP'; 'MACR'; 'MVK'; 'xMACR'; 'xMVK';'ISOPRXN';
'IEPOXOO';'NISOPO2';'NIT1NO3OOA';'NIT1OHOO';'IMACO3';'MACROO';'MVKOO';
'HC5';'NIT1';'NISOPOOH';
'MACRN';'MVKN';'IMPAA';'IMAPAN';'IMAE';'IHMML';'PYRUACD';
% below are original SAPRC07 species that are removed in this mechanism
% 'ISOPO2';'ISOPNB';'ISOPOOH';'HPALD';'ISPOND';'DIBOO';'DHMOB';'IEPOX';'NIT1NO3OOB';'ISOPNOOB';'ISOPNOOD';'ISOPNN';'ISOPND';'HC5OO'; ...
% below are the new species for the extended UCR isoprene mechanism
'HPALD1';'HPALD2';'ISOPOOH12';'ISOPOOH43';'ISOPOOHD';'IEPOXB';'IEPOXD';'ISOP1OH2N';'ISOP3N4OH';'ISOPHND';...
'IDH';'IDC';'IDN';...
'ICHE';'IDHPE';'IDNE';'IHPE';'IHNE';'INPE';'ICNE';'ICPE';'IHNPE';...% epoxides other than IEPOX and MAE
'ICPDH';'IDHDP';'IDCHP';'ITHP';'ITHC';...% these species are the C5HOM, C5H10O5, C5H12O6, C5H8O5, C5H12O5, C5H10O4, all w/ 4 functional groups
'ICHNP';'IDHDN';'IDHPN';'IDHCN';'ICHDN';'ICDPN';'IHPDN';'IHNDP';'IHNDC';'ITHN';'INPA';'INCA';...% these species are the C5NHOM, all w/ 4 functional groups
'C4HP';'C4HC';'C4DH';'C4ENOL';'C4PN';...% lumped MACR and MVK products
'HPETHNL';'HPAC';'MGA';'NMGA';'C10dimer';...% C10dimer, Mw=250, C* = 0.0001.
'ISOP1OHOO';'ISOP4OHOO';'ISOPOOHOO';'NIEPOXOO';'ISOPNOO';'IHDNOO';'IHPNOO';...% RO2
};

AddSpecies

%% SAPRC07tic mechanism from CMAQ
%1
i=i+1;
Rnames{i} = ' NO2 + hv = NO + O3P ';
k(:,i) =  1.0.*JNO2_06;
Gstr{i,1} = 'NO2'; 
fNO2(i)=fNO2(i)-1; fNO(i)=fNO(i)+1; fO3P(i)=fO3P(i)+1;

%2
i=i+1;
Rnames{i} = ' O3P + O2 + M = O3 ';
k(:,i) =  5.68e-34.*(T./300).^-2.60.*M.*0.21.*M;
Gstr{i,1} = 'O3P'; 
fO3P(i)=fO3P(i)-1; fO3(i)=fO3(i)+1; 

%3
i=i+1;
Rnames{i} = ' O3P + O3 =  ';
k(:,i) =  8.00e-12.*exp(-2060./ T);
Gstr{i,1} = 'O3P'; Gstr{i,2} = 'O3'; 
fO3P(i)=fO3P(i)-1; fO3(i)=fO3(i)-1; 

%4
i=i+1;
Rnames{i} = ' O3P + NO = NO2 ';
k(:,i) = K_O3P_NO;
Gstr{i,1} = 'O3P'; Gstr{i,2} = 'NO'; 
fO3P(i)=fO3P(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; 

%5
i=i+1;
Rnames{i} = ' O3P + NO2 = NO ';
k(:,i) =  5.50e-12.*exp(188./ T);
Gstr{i,1} = 'O3P'; Gstr{i,2} = 'NO2'; 
fO3P(i)=fO3P(i)-1; fNO2(i)=fNO2(i)-1; fNO(i)=fNO(i)+1; 

%6
i=i+1;
Rnames{i} = ' O3P + NO2 = NO3 ';
k(:,i) = K_O3P_NO2_NO3;
Gstr{i,1} = 'O3P'; Gstr{i,2} = 'NO2'; 
fO3P(i)=fO3P(i)-1; fNO2(i)=fNO2(i)-1; fNO3(i)=fNO3(i)+1; 

%7
i=i+1;
Rnames{i} = ' O3 + NO = NO2 ';
k(:,i) =  3.00e-12.*exp(-1500./ T);
Gstr{i,1} = 'O3'; Gstr{i,2} = 'NO'; 
fO3(i)=fO3(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; 

%8
i=i+1;
Rnames{i} = ' O3 + NO2 = NO3 ';
k(:,i) =  1.40e-13.*exp(-2470./ T);
Gstr{i,1} = 'O3'; Gstr{i,2} = 'NO2'; 
fO3(i)=fO3(i)-1; fNO2(i)=fNO2(i)-1; fNO3(i)=fNO3(i)+1; 

%9
i=i+1;
Rnames{i} = ' NO + NO3 = 2*NO2 ';
k(:,i) =  1.80e-11.*exp(110./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'NO3'; 
fNO(i)=fNO(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+2; 

%10
i=i+1;
Rnames{i} = ' NO + NO + O2 = 2*NO2 ';
k(:,i) =  3.30e-39.*exp(530./ T).*0.21.*M;
Gstr{i,1} = 'NO'; Gstr{i,2} = 'NO'; 
fNO(i)=fNO(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+2; 

%11 k changed
i=i+1;
Rnames{i} = ' NO2 + NO3 = N2O5 ';
k(:,i) = K_NO2_NO3;
Gstr{i,1} = 'NO2'; Gstr{i,2} = 'NO3'; 
fNO2(i)=fNO2(i)-1; fNO3(i)=fNO3(i)-1; fN2O5(i)=fN2O5(i)+1; 

%12 k changed
i=i+1;
Rnames{i} = ' N2O5 = NO2 + NO3 ';
k(:,i) = K_N2O5;
Gstr{i,1} = 'N2O5'; 
fN2O5(i)=fN2O5(i)-1; fNO2(i)=fNO2(i)+1; fNO3(i)=fNO3(i)+1; 

%13
i=i+1;
Rnames{i} = ' N2O5 + H2O = 2*HNO3 ';
k(:,i) =  2.50e-22.*H2O;
%k(:,i) = =1e-22；
Gstr{i,1} = 'N2O5'; 
fN2O5(i)=fN2O5(i)-1; fHNO3(i)=fHNO3(i)+2; 

%14
i=i+1;
Rnames{i} = ' N2O5 + H2O + H2O = 2*HNO3 ';
k(:,i) =  1.80e-39.*H2O.*H2O;
Gstr{i,1} = 'N2O5'; 
fN2O5(i)=fN2O5(i)-1; fHNO3(i)=fHNO3(i)+2; 

%15
i=i+1;
Rnames{i} = ' NO2 + NO3 = NO + NO2 ';
k(:,i) =  4.50e-14.*exp(-1260./ T);
Gstr{i,1} = 'NO2'; Gstr{i,2} = 'NO3'; 
fNO2(i)=fNO2(i)-1; fNO3(i)=fNO3(i)-1; fNO(i)=fNO(i)+1; fNO2(i)=fNO2(i)+1; 

%16
i=i+1;
Rnames{i} = ' NO3 + hv = NO ';
k(:,i) =  1.0.*JNO3NO_06;
Gstr{i,1} = 'NO3'; 
fNO3(i)=fNO3(i)-1; fNO(i)=fNO(i)+1; 

%17
i=i+1;
Rnames{i} = ' NO3 + hv = NO2 + O3P ';
k(:,i) =  1.0.*JNO3NO2_6;
Gstr{i,1} = 'NO3'; 
fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1; fO3P(i)=fO3P(i)+1; 

%18
i=i+1;
Rnames{i} = ' O3 + hv = O1D ';
k(:,i) =  1.0.*JO3O1D_06;
Gstr{i,1} = 'O3'; 
fO3(i)=fO3(i)-1; fO1D(i)=fO1D(i)+1; 

%19
i=i+1;
Rnames{i} = ' O3 + hv = O3P ';
k(:,i) =  1.0.*JO3O3P_06;
Gstr{i,1} = 'O3'; 
fO3(i)=fO3(i)-1; fO3P(i)=fO3P(i)+1; 

%20
i=i+1;
Rnames{i} = ' O1D + H2O = 2*OH ';
k(:,i) =  1.63e-10.*exp(60./ T).*H2O;
Gstr{i,1} = 'O1D'; 
fO1D(i)=fO1D(i)-1; fOH(i)=fOH(i)+2; 

%21
i=i+1;
Rnames{i} = ' O1D + M = O3P ';
k(:,i) =  2.38e-11.*exp(96./ T).*M;
Gstr{i,1} = 'O1D'; 
fO1D(i)=fO1D(i)-1; fO3P(i)=fO3P(i)+1; 

%22
i=i+1;
Rnames{i} = ' OH + NO = HONO ';
k(:,i) = K_OH_NO;
Gstr{i,1} = 'OH'; Gstr{i,2} = 'NO'; 
fOH(i)=fOH(i)-1; fNO(i)=fNO(i)-1; fHONO(i)=fHONO(i)+1; 

%23
i=i+1;
Rnames{i} = ' HONO + hv = OH + NO ';
k(:,i) =  1.0.*JHONO_06;
Gstr{i,1} = 'HONO'; 
fHONO(i)=fHONO(i)-1; fOH(i)=fOH(i)+1; fNO(i)=fNO(i)+1; 

%24
i=i+1;
Rnames{i} = ' OH + HONO = NO2 ';
k(:,i) =  2.50e-12.*exp(260./ T);
Gstr{i,1} = 'OH'; Gstr{i,2} = 'HONO'; 
fOH(i)=fOH(i)-1; fHONO(i)=fHONO(i)-1; fNO2(i)=fNO2(i)+1; 

%25 k changed
i=i+1;
Rnames{i} = ' OH + NO2 = HNO3 ';
k(:,i) = K_OH_NO2;
Gstr{i,1} = 'OH'; Gstr{i,2} = 'NO2'; 
fOH(i)=fOH(i)-1; fNO2(i)=fNO2(i)-1; fHNO3(i)=fHNO3(i)+1; 

%26
i=i+1;
Rnames{i} = ' OH + NO3 = HO2 + NO2 ';
k(:,i) =  2.00e-11;
Gstr{i,1} = 'OH'; Gstr{i,2} = 'NO3'; 
fOH(i)=fOH(i)-1; fNO3(i)=fNO3(i)-1; fHO2(i)=fHO2(i)+1; fNO2(i)=fNO2(i)+1; 

%27 k changed
i=i+1;
Rnames{i} = ' OH + HNO3 = NO3 ';
k(:,i) = K_OH_HNO3;
Gstr{i,1} = 'OH'; Gstr{i,2} = 'HNO3'; 
fOH(i)=fOH(i)-1; fHNO3(i)=fHNO3(i)-1; fNO3(i)=fNO3(i)+1; 

%28
i=i+1;
Rnames{i} = ' HNO3 + hv = OH + NO2 ';
k(:,i) =  1.0.*JHNO3;
Gstr{i,1} = 'HNO3'; 
fHNO3(i)=fHNO3(i)-1; fOH(i)=fOH(i)+1; fNO2(i)=fNO2(i)+1; 

%29
i=i+1;
Rnames{i} = ' OH + CO = HO2 + CO2 ';
k(:,i) = K_OH_CO;
Gstr{i,1} = 'OH'; Gstr{i,2} = 'CO'; 
fOH(i)=fOH(i)-1; fCO(i)=fCO(i)-1; fHO2(i)=fHO2(i)+1; fCO2(i)=fCO2(i)+1; 

%30
i=i+1;
Rnames{i} = ' OH + O3 = HO2 ';
k(:,i) =  1.70e-12.*exp(-940./ T);
Gstr{i,1} = 'OH'; Gstr{i,2} = 'O3'; 
fOH(i)=fOH(i)-1; fO3(i)=fO3(i)-1; fHO2(i)=fHO2(i)+1; 

%31
i=i+1;
Rnames{i} = ' HO2 + NO = OH + NO2 ';
k(:,i) =  3.60e-12.*exp(270./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'NO'; 
fHO2(i)=fHO2(i)-1; fNO(i)=fNO(i)-1; fOH(i)=fOH(i)+1; fNO2(i)=fNO2(i)+1; 

%32
i=i+1;
Rnames{i} = ' HO2 + NO2 = HNO4 ';
k(:,i) = K_HO2_NO2;
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'NO2'; 
fHO2(i)=fHO2(i)-1; fNO2(i)=fNO2(i)-1; fHNO4(i)=fHNO4(i)+1; 

%33 k changed
i=i+1;
Rnames{i} = ' HNO4 = HO2 + NO2 ';
k(:,i) = K_HNO4;
Gstr{i,1} = 'HNO4'; 
fHNO4(i)=fHNO4(i)-1; fHO2(i)=fHO2(i)+1; fNO2(i)=fNO2(i)+1; 

%34
i=i+1;
Rnames{i} = ' HNO4 + hv = 0.61*HO2 + 0.61*NO2 + 0.39*OH + 0.39*NO3 ';
k(:,i) =  1.0.*JHNO4_06;
Gstr{i,1} = 'HNO4'; 
fHNO4(i)=fHNO4(i)-1; fHO2(i)=fHO2(i)+0.61; fNO2(i)=fNO2(i)+0.61; fOH(i)=fOH(i)+0.39; fNO3(i)=fNO3(i)+0.39; 

%35
i=i+1;
Rnames{i} = ' HNO4 + OH = NO2 ';
k(:,i) =  1.30e-12.*exp(380./ T);
Gstr{i,1} = 'HNO4'; Gstr{i,2} = 'OH'; 
fHNO4(i)=fHNO4(i)-1; fOH(i)=fOH(i)-1; fNO2(i)=fNO2(i)+1; 

%36
i=i+1;
Rnames{i} = ' HO2 + O3 = OH ';
k(:,i) =  2.03e-16.*(T./300).^4.57.*exp(693./T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'O3'; 
fHO2(i)=fHO2(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+1; 

%37 k changed
i=i+1;
Rnames{i} = ' HO2 + HO2 = HO2H ';
k(:,i) = K_HO2_HO2;
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'HO2'; 
fHO2(i)=fHO2(i)-1; fHO2(i)=fHO2(i)-1; fHO2H(i)=fHO2H(i)+1; 

%38 k changed
i=i+1;
Rnames{i} = ' HO2 + HO2 + H2O = HO2H ';
k(:,i) = K_HO2_HO2_H2O.*H2O;
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'HO2'; 
fHO2(i)=fHO2(i)-1; fHO2(i)=fHO2(i)-1; fHO2H(i)=fHO2H(i)+1;

%39
i=i+1;
Rnames{i} = ' NO3 + HO2 = 0.8*OH + 0.8*NO2 + 0.2*HNO3 ';
k(:,i) =  4.00e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'HO2'; 
fNO3(i)=fNO3(i)-1; fHO2(i)=fHO2(i)-1; fOH(i)=fOH(i)+0.8; fNO2(i)=fNO2(i)+0.8; fHNO3(i)=fHNO3(i)+0.2; 

%40
i=i+1;
Rnames{i} = ' NO3 + NO3 = 2*NO2 ';
k(:,i) =  8.50e-13.*exp(-2450./ T);
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'NO3'; 
fNO3(i)=fNO3(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+2; 

%41
i=i+1;
Rnames{i} = ' HO2H + hv = 2*OH ';
k(:,i) =  1.0.*JH2O2;
Gstr{i,1} = 'HO2H'; 
fHO2H(i)=fHO2H(i)-1; fOH(i)=fOH(i)+2; 

%42
i=i+1;
Rnames{i} = ' HO2H + OH = HO2 ';
k(:,i) =  1.80e-12;
Gstr{i,1} = 'HO2H'; Gstr{i,2} = 'OH'; 
fHO2H(i)=fHO2H(i)-1; fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+1; 

%43
i=i+1;
Rnames{i} = ' OH + HO2 =  ';
k(:,i) =  4.80e-11.*exp(250./ T);
Gstr{i,1} = 'OH'; Gstr{i,2} = 'HO2'; 
fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)-1; 

%44
i=i+1;
Rnames{i} = ' OH + SO2 = HO2 + SULF ';
k(:,i) = K_OH_SO2;
Gstr{i,1} = 'OH'; Gstr{i,2} = 'SO2'; 
fOH(i)=fOH(i)-1; fSO2(i)=fSO2(i)-1; fHO2(i)=fHO2(i)+1; fSULF(i)=fSULF(i)+1; 

%45
i=i+1;
Rnames{i} = ' OH + H2 = HO2 ';
k(:,i) =  7.70e-12.*exp(-2100./ T);
Gstr{i,1} = 'OH'; Gstr{i,2} = 'H2'; 
fOH(i)=fOH(i)-1; fH2(i)=fH2(i)-1; fHO2(i)=fHO2(i)+1; 

%BR01
i=i+1;
Rnames{i} = ' MEO2 + NO = NO2 + HCHO + HO2 ';
k(:,i) =  2.30e-12.*exp(360./ T);
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'NO'; 
fMEO2(i)=fMEO2(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; 

%BR02
i=i+1;
Rnames{i} = ' MEO2 + HO2 = COOH ';
k(:,i) =  3.46e-13.*(T./300).^0.36.*exp(780./T);
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'HO2'; 
fMEO2(i)=fMEO2(i)-1; fHO2(i)=fHO2(i)-1; fCOOH(i)=fCOOH(i)+1; 

%BR03
i=i+1;
Rnames{i} = ' MEO2 + HO2 = HCHO ';
k(:,i) =  3.34e-14.*(T./300).^-3.53.*exp(780./T);
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'HO2'; 
fMEO2(i)=fMEO2(i)-1; fHO2(i)=fHO2(i)-1; fHCHO(i)=fHCHO(i)+1; 

%BR04
i=i+1;
Rnames{i} = ' MEO2 + NO3 = HCHO + HO2 + NO2 ';
k(:,i) =  1.30e-12;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'NO3'; 
fMEO2(i)=fMEO2(i)-1; fNO3(i)=fNO3(i)-1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; fNO2(i)=fNO2(i)+1; 

%BR05
i=i+1;
Rnames{i} = ' MEO2 + MEO2 = MEOH + HCHO ';
k(:,i) =  6.39e-14.*(T./300).^-1.80.*exp(365./T);
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'MEO2'; 
fMEO2(i)=fMEO2(i)-1; fMEO2(i)=fMEO2(i)-1; fMEOH(i)=fMEOH(i)+1; fHCHO(i)=fHCHO(i)+1; 

%BR06
i=i+1;
Rnames{i} = ' MEO2 + MEO2 = 2*HCHO + 2*HO2 ';
k(:,i) =  7.40e-13.*exp(-520./ T);
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'MEO2'; 
fMEO2(i)=fMEO2(i)-1; fMEO2(i)=fMEO2(i)-1; fHCHO(i)=fHCHO(i)+2; fHO2(i)=fHO2(i)+2; 

%BR07
i=i+1;
Rnames{i} = ' RO2C + NO = NO2 ';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'NO'; 
fRO2C(i)=fRO2C(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; 

%BR08
i=i+1;
Rnames{i} = ' RO2C + HO2 =  ';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'HO2'; 
fRO2C(i)=fRO2C(i)-1; fHO2(i)=fHO2(i)-1; 

%BR09
i=i+1;
Rnames{i} = ' RO2C + NO3 = NO2 ';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'NO3'; 
fRO2C(i)=fRO2C(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1; 

%BR10
i=i+1;
Rnames{i} = ' RO2C + MEO2 = 0.5*HO2 + 0.75*HCHO + 0.25*MEOH ';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'MEO2'; 
fRO2C(i)=fRO2C(i)-1; fMEO2(i)=fMEO2(i)-1; fHO2(i)=fHO2(i)+0.5; fHCHO(i)=fHCHO(i)+0.75; fMEOH(i)=fMEOH(i)+0.25; 

%BR11
i=i+1;
Rnames{i} = ' RO2C + RO2C =  ';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'RO2C'; 
fRO2C(i)=fRO2C(i)-1; fRO2C(i)=fRO2C(i)-1; 

%BR12
i=i+1;
Rnames{i} = ' RO2XC + NO = XN ';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'NO'; 
fRO2XC(i)=fRO2XC(i)-1; fNO(i)=fNO(i)-1; fXN(i)=fXN(i)+1; 

%BR13
i=i+1;
Rnames{i} = ' RO2XC + HO2 =  ';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'HO2'; 
fRO2XC(i)=fRO2XC(i)-1; fHO2(i)=fHO2(i)-1; 

%BR14
i=i+1;
Rnames{i} = ' RO2XC + NO3 = NO2 ';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'NO3'; 
fRO2XC(i)=fRO2XC(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1; 

%BR15
i=i+1;
Rnames{i} = ' RO2XC + MEO2 = 0.5*HO2 + 0.75*HCHO + 0.25*MEOH ';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'MEO2'; 
fRO2XC(i)=fRO2XC(i)-1; fMEO2(i)=fMEO2(i)-1; fHO2(i)=fHO2(i)+0.5; fHCHO(i)=fHCHO(i)+0.75; fMEOH(i)=fMEOH(i)+0.25; 

%BR16
i=i+1;
Rnames{i} = ' RO2XC + RO2C =  ';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'RO2C'; 
fRO2XC(i)=fRO2XC(i)-1; fRO2C(i)=fRO2C(i)-1; 

%BR17
i=i+1;
Rnames{i} = ' RO2XC + RO2XC =  ';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'RO2XC'; 
fRO2XC(i)=fRO2XC(i)-1; fRO2XC(i)=fRO2XC(i)-1; 

%BR18
i=i+1;
Rnames{i} = ' MECO3 + NO2 = PAN ';
k(:,i) = K_MECO3_NO2;
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'NO2'; 
fMECO3(i)=fMECO3(i)-1; fNO2(i)=fNO2(i)-1; fPAN(i)=fPAN(i)+1; 

%BR19
i=i+1;
Rnames{i} = ' PAN = MECO3 + NO2 ';
k(:,i) = K_PAN;
Gstr{i,1} = 'PAN'; 
fPAN(i)=fPAN(i)-1; fMECO3(i)=fMECO3(i)+1; fNO2(i)=fNO2(i)+1; 

%BR20
i=i+1;
Rnames{i} = ' PAN + hv = 0.6*MECO3 + 0.6*NO2 + 0.4*MEO2 + 0.4*CO2 + 0.4*NO3 ';
k(:,i) =  1.0.*JPAN;
Gstr{i,1} = 'PAN'; 
fPAN(i)=fPAN(i)-1; fMECO3(i)=fMECO3(i)+0.6; fNO2(i)=fNO2(i)+0.6; fMEO2(i)=fMEO2(i)+0.4; fCO2(i)=fCO2(i)+0.4; fNO3(i)=fNO3(i)+0.4; 

%BR21
i=i+1;
Rnames{i} = ' MECO3 + NO = MEO2 + CO2 + NO2 ';
k(:,i) =  7.50e-12.*exp(290./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'NO'; 
fMECO3(i)=fMECO3(i)-1; fNO(i)=fNO(i)-1; fMEO2(i)=fMEO2(i)+1; fCO2(i)=fCO2(i)+1; fNO2(i)=fNO2(i)+1; 

% BR22
% i=i+1;
% Rnames{i} = ' MECO3 + HO2 = AACD + 0.3*O3 ';
% k(:,i) =  5.20e-13.*exp(980./ T);
% Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'HO2'; 
% fMECO3(i)=fMECO3(i)-1; fHO2(i)=fHO2(i)-1; fAACD(i)=fAACD(i)+1; fO3(i)=fO3(i)+0.3; 

%BR22
i=i+1;
Rnames{i} = ' MECO3 + HO2 = 0.105*CCOOOH + 0.045*CCOOH + 0.15*O3 + 0.44*OH + 0.44*MEO2 + 0.44*CO2 ';
k(:,i) =  5.20e-13.*exp(980./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'HO2'; 
fMECO3(i)=fMECO3(i)-1; fHO2(i)=fHO2(i)-1; fCCOOOH(i)=fCCOOOH(i)+0.105; fO3(i)=fO3(i)+0.15; 
fCCOOH(i)=fCCOOH(i)+0.045;fOH(i)=fOH(i)+0.44;fMEO2(i)=fMEO2(i)+0.44;fCO2(i)=fCO2(i)+0.44;

%BR23
i=i+1;
Rnames{i} = ' MECO3 + NO3 = MEO2 + CO2 + NO2 ';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'NO3'; 
fMECO3(i)=fMECO3(i)-1; fNO3(i)=fNO3(i)-1; fMEO2(i)=fMEO2(i)+1; fCO2(i)=fCO2(i)+1; fNO2(i)=fNO2(i)+1; 

% BR24
% i=i+1;
% Rnames{i} = ' MECO3 + MEO2 = 0.1*AACD + 0.1*HCHO + 0.9*HCHO + 0.9*HO2 + 0.9*MEO2 +  0.9*CO2 ';
% k(:,i) =  2.00e-12.*exp(500./ T);
% Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'MEO2'; 
% fMECO3(i)=fMECO3(i)-1; fMEO2(i)=fMEO2(i)-1; fAACD(i)=fAACD(i)+0.1; fHCHO(i)=fHCHO(i)+0.1; fHCHO(i)=fHCHO(i)+0.9; fHO2(i)=fHO2(i)+0.9; fMEO2(i)=fMEO2(i)+0.9; fCO2(i)=fCO2(i)+0.9; 

%BR24
i=i+1;
Rnames{i} = ' MECO3 + MEO2 = 0.1*CCOOH + 0.1*HCHO + 0.9*HCHO + 0.9*HO2 + 0.9*MEO2 +0.9*CO2 ';
k(:,i) =  2.00e-12.*exp(500./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'MEO2'; 
fMECO3(i)=fMECO3(i)-1; fMEO2(i)=fMEO2(i)-1; fCCOOH(i)=fCCOOH(i)+0.1; 
fHCHO(i)=fHCHO(i)+0.1; fHCHO(i)=fHCHO(i)+0.9; fHO2(i)=fHO2(i)+0.9; fMEO2(i)=fMEO2(i)+0.9; fCO2(i)=fCO2(i)+0.9; 

%BR25
i=i+1;
Rnames{i} = ' MECO3 + RO2C = MEO2 + CO2 ';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'RO2C'; 
fMECO3(i)=fMECO3(i)-1; fRO2C(i)=fRO2C(i)-1; fMEO2(i)=fMEO2(i)+1; fCO2(i)=fCO2(i)+1; 

%BR26
i=i+1;
Rnames{i} = ' MECO3 + RO2XC = MEO2 + CO2 ';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'RO2XC'; 
fMECO3(i)=fMECO3(i)-1; fRO2XC(i)=fRO2XC(i)-1; fMEO2(i)=fMEO2(i)+1; fCO2(i)=fCO2(i)+1; 

%BR27
i=i+1;
Rnames{i} = ' MECO3 + MECO3 = 2*MEO2 + 2*CO2 ';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'MECO3'; 
fMECO3(i)=fMECO3(i)-1; fMECO3(i)=fMECO3(i)-1; fMEO2(i)=fMEO2(i)+2; fCO2(i)=fCO2(i)+2; 

%BR28
i=i+1;
Rnames{i} = ' RCO3 + NO2 = PAN2 ';
k(:,i) =  1.21e-11.*(T./300).^-1.07.*exp(0./T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'NO2'; 
fRCO3(i)=fRCO3(i)-1; fNO2(i)=fNO2(i)-1; fPAN2(i)=fPAN2(i)+1; 

%BR29
i=i+1;
Rnames{i} = ' PAN2 = RCO3 + NO2 ';
k(:,i) =  8.30e+16.*exp(-13940./ T);
Gstr{i,1} = 'PAN2'; 
fPAN2(i)=fPAN2(i)-1; fRCO3(i)=fRCO3(i)+1; fNO2(i)=fNO2(i)+1; 

%BR30
i=i+1;
Rnames{i} = ' PAN2 + hv = 0.6*RCO3 + 0.6*NO2 + 0.4*RO2C + 0.4*xHO2 + 0.4*yROOH + 0.4*xCCHO +  0.4*CO2 + 0.4*NO3 ';
k(:,i) =  1.0.*JPAN;
Gstr{i,1} = 'PAN2'; 
fPAN2(i)=fPAN2(i)-1; fRCO3(i)=fRCO3(i)+0.6; fNO2(i)=fNO2(i)+0.6; fRO2C(i)=fRO2C(i)+0.4; fxHO2(i)=fxHO2(i)+0.4; fyROOH(i)=fyROOH(i)+0.4; fxCCHO(i)=fxCCHO(i)+0.4; fCO2(i)=fCO2(i)+0.4; fNO3(i)=fNO3(i)+0.4; 

%BR31
i=i+1;
Rnames{i} = ' RCO3 + NO = NO2 + RO2C + xHO2 + yROOH + xCCHO + CO2 ';
k(:,i) =  6.70e-12.*exp(340./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'NO'; 
fRCO3(i)=fRCO3(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; fyROOH(i)=fyROOH(i)+1; fxCCHO(i)=fxCCHO(i)+1; fCO2(i)=fCO2(i)+1; 

% BR32
% i=i+1;
% Rnames{i} = ' RCO3 + HO2 = PACD + 0.25*O3 ';
% k(:,i) =  5.20e-13.*exp(980./ T);
% Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'HO2'; 
% fRCO3(i)=fRCO3(i)-1; fHO2(i)=fHO2(i)-1; fPACD(i)=fPACD(i)+1; fO3(i)=fO3(i)+0.25; 

% BR32
i=i+1;
Rnames{i} = ' RCO3 + HO2 = 0.3075*RCOOOH + 0.1025*RCOOH + 0.15*O3 + 0.44*OH + 0.44*xHO2 + 0.44*RO2C + 0.44*CO2 + 0.44*xCCHO + 0.44*yROOH ';
k(:,i) =  5.20e-13.*exp(980./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'HO2'; 
fRCO3(i)=fRCO3(i)-1; fHO2(i)=fHO2(i)-1; fRCOOOH(i)=fRCOOOH(i)+0.3075; fRCOOH(i)=fRCOOH(i)+0.1025; 
fxHO2(i)=fxHO2(i)+0.44; fO3(i)=fO3(i)+0.15; 
fRO2C(i)=fRO2C(i)+0.44;fOH(i)=fOH(i)+0.44;fCCHO(i)=fCCHO(i)+0.44;fCO2(i)=fCO2(i)+0.44;fyROOH(i)=fyROOH(i)+0.44;


%BR33
i=i+1;
Rnames{i} = ' RCO3 + NO3 = NO2 + RO2C + xHO2 + yROOH + xCCHO + CO2 ';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'NO3'; 
fRCO3(i)=fRCO3(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1; fRO2C(i)=fRO2C(i)+1; 
fxHO2(i)=fxHO2(i)+1; fyROOH(i)=fyROOH(i)+1; fxCCHO(i)=fxCCHO(i)+1; fCO2(i)=fCO2(i)+1; 

%BR34
i=i+1;
Rnames{i} = ' RCO3 + MEO2 = HCHO + HO2 + RO2C + xHO2 + xCCHO + yROOH + CO2';
k(:,i) =  2.00e-12.*exp(500./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'MEO2'; 
fRCO3(i)=fRCO3(i)-1; fMEO2(i)=fMEO2(i)-1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; 
fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; fxCCHO(i)=fxCCHO(i)+1; fyROOH(i)=fyROOH(i)+1; fCO2(i)=fCO2(i)+1; 

%BR35
i=i+1;
Rnames{i} = ' RCO3 + RO2C = RO2C + xHO2 + xCCHO + yROOH + CO2 ';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'RO2C'; 
fRCO3(i)=fRCO3(i)-1; fRO2C(i)=fRO2C(i)-1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; 
fxCCHO(i)=fxCCHO(i)+1; fyROOH(i)=fyROOH(i)+1; fCO2(i)=fCO2(i)+1; 

%BR36
i=i+1;
Rnames{i} = ' RCO3 + RO2XC = RO2C + xHO2 + xCCHO + yROOH + CO2 ';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'RO2XC'; 
fRCO3(i)=fRCO3(i)-1; fRO2XC(i)=fRO2XC(i)-1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; 
fxCCHO(i)=fxCCHO(i)+1; fyROOH(i)=fyROOH(i)+1; fCO2(i)=fCO2(i)+1; 

%BR37
i=i+1;
Rnames{i} = ' RCO3 + MECO3 = 2*CO2 + MEO2 + RO2C + xHO2 + yROOH + xCCHO ';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'MECO3'; 
fRCO3(i)=fRCO3(i)-1; fMECO3(i)=fMECO3(i)-1; fCO2(i)=fCO2(i)+2; fMEO2(i)=fMEO2(i)+1; fRO2C(i)=fRO2C(i)+1;
fxHO2(i)=fxHO2(i)+1; fyROOH(i)=fyROOH(i)+1; fxCCHO(i)=fxCCHO(i)+1; 

%BR38
i=i+1;
Rnames{i} = ' RCO3 + RCO3 = 2*RO2C + 2*xHO2 + 2*xCCHO + 2*yROOH + 2*CO2 ';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'RCO3'; 
fRCO3(i)=fRCO3(i)-1; fRCO3(i)=fRCO3(i)-1; fRO2C(i)=fRO2C(i)+2; fxHO2(i)=fxHO2(i)+2; 
fxCCHO(i)=fxCCHO(i)+2; fyROOH(i)=fyROOH(i)+2; fCO2(i)=fCO2(i)+2; 

%BR39
i=i+1;
Rnames{i} = ' BZCO3 + NO2 = PBZN ';
k(:,i) =  1.37e-11;
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'NO2'; 
fBZCO3(i)=fBZCO3(i)-1; fNO2(i)=fNO2(i)-1; fPBZN(i)=fPBZN(i)+1; 

%BR40
i=i+1;
Rnames{i} = ' PBZN = BZCO3 + NO2 ';
k(:,i) =  7.90e+16.*exp(-14000./ T);
Gstr{i,1} = 'PBZN'; 
fPBZN(i)=fPBZN(i)-1; fBZCO3(i)=fBZCO3(i)+1; fNO2(i)=fNO2(i)+1; 

%BR41
i=i+1;
Rnames{i} = ' PBZN + hv = 0.6*BZCO3 + 0.6*NO2 + 0.4*CO2 + 0.4*BZO + 0.4*RO2C + 0.4*NO3';
k(:,i) =  1.0.*JPAN;
Gstr{i,1} = 'PBZN'; 
fPBZN(i)=fPBZN(i)-1; fBZCO3(i)=fBZCO3(i)+0.6; fNO2(i)=fNO2(i)+0.6; fCO2(i)=fCO2(i)+0.4; fBZO(i)=fBZO(i)+0.4;
fRO2C(i)=fRO2C(i)+0.4; fNO3(i)=fNO3(i)+0.4; 

%BR42
i=i+1;
Rnames{i} = ' BZCO3 + NO = NO2 + CO2 + BZO + RO2C ';
k(:,i) =  6.70e-12.*exp(340./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'NO'; 
fBZCO3(i)=fBZCO3(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fCO2(i)=fCO2(i)+1; fBZO(i)=fBZO(i)+1; fRO2C(i)=fRO2C(i)+1; 

%BR43
i=i+1;
Rnames{i} = ' BZCO3 + HO2 = 0.3075*RCOOOH + 0.1025*RCOOH + 0.15*O3 + 0.44*OH + 0.44*BZO + 0.44*RO2C + 0.44*CO2 ';
k(:,i) =  5.20e-13.*exp(980./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'HO2'; 
fBZCO3(i)=fBZCO3(i)-1; fHO2(i)=fHO2(i)-1;fRCOOOH(i)=fRCOOOH(i)+0.3075; fRCOOH(i)=fRCOOH(i)+0.1025; 
fBZO(i)=fBZO(i)+0.44; fO3(i)=fO3(i)+0.15; 
fRO2C(i)=fRO2C(i)+0.44;fOH(i)=fOH(i)+0.44;fCO2(i)=fCO2(i)+0.44;

%BR44
i=i+1;
Rnames{i} = ' BZCO3 + NO3 = NO2 + CO2 + BZO + RO2C ';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'NO3'; 
fBZCO3(i)=fBZCO3(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1; fCO2(i)=fCO2(i)+1; fBZO(i)=fBZO(i)+1; fRO2C(i)=fRO2C(i)+1; 

%BR45
i=i+1;
Rnames{i} = ' BZCO3 + MEO2 = HCHO + HO2 + RO2C + BZO + CO2 ';
k(:,i) =  2.00e-12.*exp(500./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'MEO2'; 
fBZCO3(i)=fBZCO3(i)-1; fMEO2(i)=fMEO2(i)-1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; fRO2C(i)=fRO2C(i)+1;
fBZO(i)=fBZO(i)+1; fCO2(i)=fCO2(i)+1; 

%BR46
i=i+1;
Rnames{i} = ' BZCO3 + RO2C = RO2C + BZO + CO2 ';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'RO2C'; 
fBZCO3(i)=fBZCO3(i)-1; fRO2C(i)=fRO2C(i)-1; fRO2C(i)=fRO2C(i)+1; fBZO(i)=fBZO(i)+1; fCO2(i)=fCO2(i)+1; 

%BR47
i=i+1;
Rnames{i} = ' BZCO3 + RO2XC = RO2C + BZO + CO2 ';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'RO2XC'; 
fBZCO3(i)=fBZCO3(i)-1; fRO2XC(i)=fRO2XC(i)-1; fRO2C(i)=fRO2C(i)+1; fBZO(i)=fBZO(i)+1; fCO2(i)=fCO2(i)+1; 

%BR48
i=i+1;
Rnames{i} = ' BZCO3 + MECO3 = 2*CO2 + MEO2 + BZO + RO2C ';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'MECO3'; 
fBZCO3(i)=fBZCO3(i)-1; fMECO3(i)=fMECO3(i)-1; fCO2(i)=fCO2(i)+2; fMEO2(i)=fMEO2(i)+1; fBZO(i)=fBZO(i)+1; fRO2C(i)=fRO2C(i)+1; 

%BR49
i=i+1;
Rnames{i} = ' BZCO3 + RCO3 = 2*CO2 + RO2C + xHO2 + yROOH + xCCHO + BZO + RO2C';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'RCO3'; 
fBZCO3(i)=fBZCO3(i)-1; fRCO3(i)=fRCO3(i)-1; fCO2(i)=fCO2(i)+2; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; 
fyROOH(i)=fyROOH(i)+1; fxCCHO(i)=fxCCHO(i)+1; fBZO(i)=fBZO(i)+1; fRO2C(i)=fRO2C(i)+1; 

%BR50
i=i+1;
Rnames{i} = ' BZCO3 + BZCO3 = 2*BZO + 2*RO2C + 2*CO2 ';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'BZCO3'; 
fBZCO3(i)=fBZCO3(i)-1; fBZCO3(i)=fBZCO3(i)-1; fBZO(i)=fBZO(i)+2; fRO2C(i)=fRO2C(i)+2; fCO2(i)=fCO2(i)+2; 

%BR51
i=i+1;
Rnames{i} = ' MACO3 + NO2 = MAPAN '; % MAPAN, same as MPAN
k(:,i) =  1.21e-11.*(T./300).^-1.07.*exp(0./T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'NO2'; 
fMACO3(i)=fMACO3(i)-1; fNO2(i)=fNO2(i)-1; fMAPAN(i)=fMAPAN(i)+1; 

%BR52
i=i+1;
Rnames{i} = ' MAPAN = MACO3 + NO2 ';
k(:,i) =  1.60e+16.*exp(-13486./ T);
Gstr{i,1} = 'MAPAN'; 
fMAPAN(i)=fMAPAN(i)-1; fMACO3(i)=fMACO3(i)+1; fNO2(i)=fNO2(i)+1; 

%IS108 new rection added
i=i+1;
Rnames{i} = ' MAPAN + OH = HACET + CO + NO2 ';
k(:,i) =  2.9e-11;
Gstr{i,1} = 'MAPAN'; Gstr{i,2} = 'OH';
fMAPAN(i)=fMAPAN(i)-1; fOH(i)=fOH(i)-1;fHACET(i)=fHACET(i)+1; fNO2(i)=fNO2(i)+1; fCO(i)=fCO(i)+1;

%BR53
i=i+1;
Rnames{i} = ' MAPAN + hv = 0.6*MACO3 + 0.6*NO2 + 0.4*CO2 + 0.4*HCHO + 0.4*MECO3 + 0.4*NO3';
k(:,i) =  1.0.*JPAN;
Gstr{i,1} = 'MAPAN'; 
fMAPAN(i)=fMAPAN(i)-1; fMACO3(i)=fMACO3(i)+0.6; fNO2(i)=fNO2(i)+0.6; fCO2(i)=fCO2(i)+0.4; fHCHO(i)=fHCHO(i)+0.4; 
fMECO3(i)=fMECO3(i)+0.4; fNO3(i)=fNO3(i)+0.4; 

%IS69 
i=i+1;
Rnames{i} = ' MACO3 + NO = NO2 + CO2 + HCHO + MECO3 ';
k(:,i) =  6.70e-12.*exp(340./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'NO'; 
fMACO3(i)=fMACO3(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fCO2(i)=fCO2(i)+1; fHCHO(i)=fHCHO(i)+1; fMECO3(i)=fMECO3(i)+1; 
 
%IS70 
i=i+1;
Rnames{i} = 'MACO3 + HO2 = 0.3075*RCOOOH + 0.1025*RCOOH + 0.15*O3 + 0.44*OH + 0.44*HCHO + 0.44*MECO3 + 0.44*CO2'; 
k(:,i) =  5.20e-13.*exp(980./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'HO2'; 
fMACO3(i)=fMACO3(i)-1; fHO2(i)=fHO2(i)-1; fRCOOOH(i)=fRCOOOH(i)+0.3075; fRCOOH(i)=fRCOOH(i)+0.1025; 
fO3(i)=fO3(i)+0.15; fMECO3(i)=fMECO3(i)+0.44;fOH(i)=fOH(i)+0.44;fCO2(i)=fCO2(i)+0.44;fHCHO(i)=fHCHO(i)+0.44;

%IS71
i=i+1;
Rnames{i} = ' MACO3 + NO3 = NO2 + CO + CO2 + HCHO + MEO2 ';
k(:,i) =  4e-12;
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'NO3'; 
fMACO3(i)=fMACO3(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1; fCO2(i)=fCO2(i)+1; 
fHCHO(i)=fHCHO(i)+1; fMEO2(i)=fMEO2(i)+1; fCO(i)=fCO(i)+1;

%IS72
i=i+1;
Rnames{i} = ' MACO3 + MEO2 = HCHO + HO2 + CO + CO2 + HCHO + MEO2 ';
k(:,i) =  2.00e-12.*exp(500./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'MEO2'; 
fMACO3(i)=fMACO3(i)-1; fMEO2(i)=fMEO2(i)-1; fHCHO(i)=fHCHO(i)+2; fHO2(i)=fHO2(i)+1; 
fCO2(i)=fCO2(i)+1; fMEO2(i)=fMEO2(i)+1; fCO(i)=fCO(i)+1;

%IS73
i=i+1;
Rnames{i} = ' MACO3 + RO2C = CO + CO2 + HCHO + MEO2 ';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'RO2C'; 
fMACO3(i)=fMACO3(i)-1; fRO2C(i)=fRO2C(i)-1; fCO2(i)=fCO2(i)+1; 
fHCHO(i)=fHCHO(i)+1; fMEO2(i)=fMEO2(i)+1; fCO(i)=fCO(i)+1;

%IS74
i=i+1;
Rnames{i} = ' MACO3 + RO2XC = CO+ CO2 + HCHO + MEO2 ';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'RO2XC'; 
fMACO3(i)=fMACO3(i)-1; fRO2XC(i)=fRO2XC(i)-1; fCO2(i)=fCO2(i)+1; fHCHO(i)=fHCHO(i)+1; fMEO2(i)=fMEO2(i)+1;fCO(i)=fCO(i)+1; 

%IS75
i=i+1;
Rnames{i} = ' MACO3 + MECO3 = 2*CO2 + MEO2 + CO + HCHO + MEO2 ';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'MECO3'; 
fMACO3(i)=fMACO3(i)-1; fMECO3(i)=fMECO3(i)-1; fCO2(i)=fCO2(i)+2; fMEO2(i)=fMEO2(i)+2; fHCHO(i)=fHCHO(i)+1; fCO(i)=fCO(i)+1; 

%IS76
i=i+1;
Rnames{i} = ' MACO3 + RCO3 = CO + CO2 + HCHO + MEO2 + RO2C + xHO2 + yROOH + xCCHO + CO2';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'RCO3'; 
fMACO3(i)=fMACO3(i)-1; fRCO3(i)=fRCO3(i)-1; fHCHO(i)=fHCHO(i)+1; fMEO2(i)=fMEO2(i)+1;
fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; fyROOH(i)=fyROOH(i)+1; fxCCHO(i)=fxCCHO(i)+1; fCO2(i)=fCO2(i)+2;fCO(i)=fCO(i)+1; 

%IS77
i=i+1;
Rnames{i} = ' MACO3 + BZCO3 = HCHO + MEO2 + BZO + RO2C + 2*CO2 + CO ';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'BZCO3'; 
fMACO3(i)=fMACO3(i)-1; fBZCO3(i)=fBZCO3(i)-1; fHCHO(i)=fHCHO(i)+1; fMEO2(i)=fMEO2(i)+1; 
fBZO(i)=fBZO(i)+1; fRO2C(i)=fRO2C(i)+1; fCO2(i)=fCO2(i)+2; fCO(i)=fCO(i)+1;

%IS78
i=i+1;
Rnames{i} = ' MACO3 + MACO3 = 2*CO + 2*CO2 + 2*HCHO + 2*MEO2  ';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'MACO3'; 
fMACO3(i)=fMACO3(i)-1; fMACO3(i)=fMACO3(i)-1; fHCHO(i)=fHCHO(i)+2; fMEO2(i)=fMEO2(i)+2; fCO2(i)=fCO2(i)+2;fCO(i)=fCO(i)+2; 

%BR64
i=i+1;
Rnames{i} = ' TBUO + NO2 = RNO3 + -2*XC ';
k(:,i) =  2.40e-11;
Gstr{i,1} = 'TBUO'; Gstr{i,2} = 'NO2'; 
fTBUO(i)=fTBUO(i)-1; fNO2(i)=fNO2(i)-1; fRNO3(i)=fRNO3(i)+1; fXC(i)=fXC(i)+-2; 

%BR65
i=i+1;
Rnames{i} = ' TBUO = ACET + MEO2 ';
k(:,i) =  7.50e+14.*exp(-8152./ T);
Gstr{i,1} = 'TBUO'; 
fTBUO(i)=fTBUO(i)-1; fACET(i)=fACET(i)+1; fMEO2(i)=fMEO2(i)+1; 

%BR66
i=i+1;
Rnames{i} = ' BZO + NO2 = NPHE ';
k(:,i) =  2.30e-11.*exp(150./ T);
Gstr{i,1} = 'BZO'; Gstr{i,2} = 'NO2'; 
fBZO(i)=fBZO(i)-1; fNO2(i)=fNO2(i)-1; fNPHE(i)=fNPHE(i)+1; 

%BR67
i=i+1;
Rnames{i} = ' BZO + HO2 = CRES + -1*XC ';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'BZO'; Gstr{i,2} = 'HO2'; 
fBZO(i)=fBZO(i)-1; fHO2(i)=fHO2(i)-1; fCRES(i)=fCRES(i)+1; fXC(i)=fXC(i)+-1; 

%BR68
i=i+1;
Rnames{i} = ' BZO = CRES + RO2C + xHO2 + -1*XC ';
k(:,i) =  1.00e-03;
Gstr{i,1} = 'BZO'; 
fBZO(i)=fBZO(i)-1; fCRES(i)=fCRES(i)+1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; fXC(i)=fXC(i)+-1; 

%BP01
i=i+1;
Rnames{i} = ' HCHO + hv = 2*HO2 + CO ';
k(:,i) =  1.0.*JHCHOR_06;
Gstr{i,1} = 'HCHO'; 
fHCHO(i)=fHCHO(i)-1; fHO2(i)=fHO2(i)+2; fCO(i)=fCO(i)+1; 

%BP02
i=i+1;
Rnames{i} = ' HCHO + hv = CO ';
k(:,i) =  1.0.*JHCHOM_06;
Gstr{i,1} = 'HCHO'; 
fHCHO(i)=fHCHO(i)-1; fCO(i)=fCO(i)+1; 

%BP03
i=i+1;
Rnames{i} = ' HCHO + OH = HO2 + CO ';
k(:,i) =  5.40e-12.*exp(135./ T);
Gstr{i,1} = 'HCHO'; Gstr{i,2} = 'OH'; 
fHCHO(i)=fHCHO(i)-1; fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+1; fCO(i)=fCO(i)+1; 

%BP07
i=i+1;
Rnames{i} = ' HCHO + NO3 = HNO3 + HO2 + CO ';
k(:,i) =  2.00e-12.*exp(-2431./ T);
Gstr{i,1} = 'HCHO'; Gstr{i,2} = 'NO3'; 
fHCHO(i)=fHCHO(i)-1; fNO3(i)=fNO3(i)-1; fHNO3(i)=fHNO3(i)+1; fHO2(i)=fHO2(i)+1; fCO(i)=fCO(i)+1; 

%BP08
i=i+1;
Rnames{i} = ' CCHO + OH = MECO3 ';
k(:,i) =  4.40e-12.*exp(365./ T);
Gstr{i,1} = 'CCHO'; Gstr{i,2} = 'OH'; 
fCCHO(i)=fCCHO(i)-1; fOH(i)=fOH(i)-1; fMECO3(i)=fMECO3(i)+1; 

%BP09
i=i+1;
Rnames{i} = ' CCHO + hv = CO + HO2 + MEO2 ';
k(:,i) =  1.0.*JCCHO_R;
Gstr{i,1} = 'CCHO'; 
fCCHO(i)=fCCHO(i)-1; fCO(i)=fCO(i)+1; fHO2(i)=fHO2(i)+1; fMEO2(i)=fMEO2(i)+1; 

%BP10
i=i+1;
Rnames{i} = ' CCHO + NO3 = HNO3 + MECO3 ';
k(:,i) =  1.40e-12.*exp(-1860./ T);
Gstr{i,1} = 'CCHO'; Gstr{i,2} = 'NO3'; 
fCCHO(i)=fCCHO(i)-1; fNO3(i)=fNO3(i)-1; fHNO3(i)=fHNO3(i)+1; fMECO3(i)=fMECO3(i)+1; 

%BP11
i=i+1;
Rnames{i} = ' RCHO + OH = 0.965*RCO3 + 0.035*RO2C + 0.035*xHO2 + 0.035*xCO +  0.035*xCCHO + 0.035*yROOH ';
k(:,i) =  5.10e-12.*exp(405./ T);
Gstr{i,1} = 'RCHO'; Gstr{i,2} = 'OH'; 
fRCHO(i)=fRCHO(i)-1; fOH(i)=fOH(i)-1; fRCO3(i)=fRCO3(i)+0.965; fRO2C(i)=fRO2C(i)+0.035; fxHO2(i)=fxHO2(i)+0.035;
fxCO(i)=fxCO(i)+0.035; fxCCHO(i)=fxCCHO(i)+0.035; fyROOH(i)=fyROOH(i)+0.035; 

%BP12
i=i+1;
Rnames{i} = ' RCHO + hv = RO2C + xHO2 + yROOH + xCCHO + CO + HO2 ';
k(:,i) =  1.0.*JC2CHO;
Gstr{i,1} = 'RCHO'; 
fRCHO(i)=fRCHO(i)-1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; fyROOH(i)=fyROOH(i)+1; fxCCHO(i)=fxCCHO(i)+1;
fCO(i)=fCO(i)+1; fHO2(i)=fHO2(i)+1; 

%BP13
i=i+1;
Rnames{i} = ' RCHO + NO3 = HNO3 + RCO3 ';
k(:,i) =  1.40e-12.*exp(-1601./ T);
Gstr{i,1} = 'RCHO'; Gstr{i,2} = 'NO3'; 
fRCHO(i)=fRCHO(i)-1; fNO3(i)=fNO3(i)-1; fHNO3(i)=fHNO3(i)+1; fRCO3(i)=fRCO3(i)+1; 

%BP14
i=i+1;
Rnames{i} = ' ACET + OH = RO2C + xMECO3 + xHCHO + yROOH ';
k(:,i) =  4.56e-14.*(T./300).^3.65.*exp(429./T);
Gstr{i,1} = 'ACET'; Gstr{i,2} = 'OH'; 
fACET(i)=fACET(i)-1; fOH(i)=fOH(i)-1; fRO2C(i)=fRO2C(i)+1; fxMECO3(i)=fxMECO3(i)+1; fxHCHO(i)=fxHCHO(i)+1; fyROOH(i)=fyROOH(i)+1; 

%BP15
i=i+1;
Rnames{i} = ' ACET + hv = 0.62*MECO3 + 1.38*MEO2 + 0.38*CO ';
k(:,i) =  5.00e-1.*JACET_06;
Gstr{i,1} = 'ACET'; 
fACET(i)=fACET(i)-1; fMECO3(i)=fMECO3(i)+0.62; fMEO2(i)=fMEO2(i)+1.38; fCO(i)=fCO(i)+0.38; 

%BP16
i=i+1;
Rnames{i} = ' MEK + OH = 0.967*RO2C + 0.039*RO2XC + 0.039*zRNO3 + 0.376*xHO2 + 0.51*xMECO3 + 0.074*xRCO3 + 0.088*xHCHO + 0.504*xCCHO + 0.376*xRCHO +  yROOH + 0.3*XC ';
k(:,i) =  1.30e-12.*(T./300).^2.00.*exp(-25./T);
Gstr{i,1} = 'MEK'; Gstr{i,2} = 'OH'; 
fMEK(i)=fMEK(i)-1; fOH(i)=fOH(i)-1; fRO2C(i)=fRO2C(i)+0.967; fRO2XC(i)=fRO2XC(i)+0.039; fzRNO3(i)=fzRNO3(i)+0.039;
fxHO2(i)=fxHO2(i)+0.376; fxMECO3(i)=fxMECO3(i)+0.51; fxRCO3(i)=fxRCO3(i)+0.074; fxHCHO(i)=fxHCHO(i)+0.088; 
fxCCHO(i)=fxCCHO(i)+0.504; fxRCHO(i)=fxRCHO(i)+0.376; fyROOH(i)=fyROOH(i)+1; fXC(i)=fXC(i)+0.3; 

%BP17
i=i+1;
Rnames{i} = ' MEK + hv = MECO3 + RO2C + xHO2 + xCCHO + yROOH ';
k(:,i) =  1.75e-1.*JMEK_06;
Gstr{i,1} = 'MEK'; 
fMEK(i)=fMEK(i)-1; fMECO3(i)=fMECO3(i)+1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; fxCCHO(i)=fxCCHO(i)+1; 
fyROOH(i)=fyROOH(i)+1; 

%BP18
i=i+1;
Rnames{i} = ' MEOH + OH = HCHO + HO2 ';
k(:,i) =  2.85e-12.*exp(-345./ T);
Gstr{i,1} = 'MEOH'; Gstr{i,2} = 'OH'; 
fMEOH(i)=fMEOH(i)-1; fOH(i)=fOH(i)-1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; 

%BP19 name changed
i=i+1;
Rnames{i} = ' FACD + OH = HO2 + CO2 ';
k(:,i) =  4.50e-13;
Gstr{i,1} = 'FACD'; Gstr{i,2} = 'OH'; 
fFACD(i)=fFACD(i)-1; fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+1; fCO2(i)=fCO2(i)+1; 

%BP20 name changed
i=i+1;
Rnames{i} = ' FACD + OH = 0.509*MEO2 + 0.491*RO2C + 0.509*CO2 + 0.491*xHO2 +  0.491*xMGLY + 0.491*yROOH + -0.491*XC ';
k(:,i) =  4.20e-14.*exp(855./ T);
Gstr{i,1} = 'FACD'; Gstr{i,2} = 'OH'; 
fFACD(i)=fFACD(i)-1; fOH(i)=fOH(i)-1; fMEO2(i)=fMEO2(i)+0.509; fRO2C(i)=fRO2C(i)+0.491; fCO2(i)=fCO2(i)+0.509; 
fxHO2(i)=fxHO2(i)+0.491; fxMGLY(i)=fxMGLY(i)+0.491; fyROOH(i)=fyROOH(i)+0.491; fXC(i)=fXC(i)+-0.491; 

%BP21
i=i+1;
Rnames{i} = ' RCOOH + OH = RO2C + xHO2 + 0.143*CO2 + 0.142*xCCHO + 0.4*xRCHO +  0.457*xBACL + yROOH + -0.455*XC ';
k(:,i) =  1.20e-12;
Gstr{i,1} = 'RCOOH'; Gstr{i,2} = 'OH'; 
fRCOOH(i)=fRCOOH(i)-1; fOH(i)=fOH(i)-1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; fCO2(i)=fCO2(i)+0.143; 
fxCCHO(i)=fxCCHO(i)+0.142; fxRCHO(i)=fxRCHO(i)+0.4; fxBACL(i)=fxBACL(i)+0.457; fyROOH(i)=fyROOH(i)+1; fXC(i)=fXC(i)+-0.455; 

%BP22
i=i+1;
Rnames{i} = ' COOH + OH = 0.3*HCHO + 0.3*OH + 0.7*MEO2 ';
k(:,i) =  3.80e-12.*exp(200./ T);
Gstr{i,1} = 'COOH'; Gstr{i,2} = 'OH'; 
fCOOH(i)=fCOOH(i)-1; fOH(i)=fOH(i)-1; fHCHO(i)=fHCHO(i)+0.3; fOH(i)=fOH(i)+0.3; fMEO2(i)=fMEO2(i)+0.7; 

%BP23
i=i+1;
Rnames{i} = ' COOH + hv = HCHO + HO2 + OH ';
k(:,i) =  1.0.*JCOOH;
Gstr{i,1} = 'COOH'; 
fCOOH(i)=fCOOH(i)-1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; fOH(i)=fOH(i)+1; 

%BP24
i=i+1;
Rnames{i} = ' ROOH + OH = 0.744*OH + 0.251*RO2C + 0.004*RO2XC + 0.004*zRNO3 + 0.744*RCHO + 0.239*xHO2 + 0.012*xOH + 0.012*xHCHO + 0.012*xCCHO +  0.205*xRCHO + 0.034*xPROD2 + 0.256*yROOH + -0.115*XC ';
k(:,i) =  2.50e-11;
Gstr{i,1} = 'ROOH'; Gstr{i,2} = 'OH'; 
fROOH(i)=fROOH(i)-1; fOH(i)=fOH(i)-1; fOH(i)=fOH(i)+0.744; fRO2C(i)=fRO2C(i)+0.251; fRO2XC(i)=fRO2XC(i)+0.004; fzRNO3(i)=fzRNO3(i)+0.004;
fRCHO(i)=fRCHO(i)+0.744; fxHO2(i)=fxHO2(i)+0.239; fxOH(i)=fxOH(i)+0.012; fxHCHO(i)=fxHCHO(i)+0.012; fxCCHO(i)=fxCCHO(i)+0.012; 
fxRCHO(i)=fxRCHO(i)+0.205; fxPROD2(i)=fxPROD2(i)+0.034; fyROOH(i)=fyROOH(i)+0.256; fXC(i)=fXC(i)+-0.115; 

%BP25
i=i+1;
Rnames{i} = ' ROOH + hv = RCHO + HO2 + OH ';
k(:,i) =  1.0.*JCOOH;
Gstr{i,1} = 'ROOH'; 
fROOH(i)=fROOH(i)-1; fRCHO(i)=fRCHO(i)+1; fHO2(i)=fHO2(i)+1; fOH(i)=fOH(i)+1; 

%BP26
i=i+1;
Rnames{i} = ' R6OOH + OH = 0.84*OH + 0.222*RO2C + 0.029*RO2XC + 0.029*zRNO3 + 0.84*PRD2 + 0.09*xHO2 + 0.041*xOH + 0.02*xCCHO + 0.075*xRCHO +  0.084*xPROD2 + 0.16*yROOH + 0.02*XC ';
k(:,i) =  5.60e-11;
Gstr{i,1} = 'R6OOH'; Gstr{i,2} = 'OH'; 
fR6OOH(i)=fR6OOH(i)-1; fOH(i)=fOH(i)-1; fOH(i)=fOH(i)+0.84; fRO2C(i)=fRO2C(i)+0.222; fRO2XC(i)=fRO2XC(i)+0.029; 
fzRNO3(i)=fzRNO3(i)+0.029; fPRD2(i)=fPRD2(i)+0.84; fxHO2(i)=fxHO2(i)+0.09; fxOH(i)=fxOH(i)+0.041; fxCCHO(i)=fxCCHO(i)+0.02; 
fxRCHO(i)=fxRCHO(i)+0.075; fxPROD2(i)=fxPROD2(i)+0.084; fyROOH(i)=fyROOH(i)+0.16; fXC(i)=fXC(i)+0.02; 

%BP27
i=i+1;
Rnames{i} = ' R6OOH + hv = OH + 0.142*HO2 + 0.782*RO2C + 0.077*RO2XC + 0.077*zRNO3 + 0.085*RCHO + 0.142*PRD2 + 0.782*xHO2 + 0.026*xCCHO + 0.058*xRCHO +  0.698*xPROD2 + 0.858*yR6OOH + 0.017*XC ';
k(:,i) =  1.0.*JCOOH;
Gstr{i,1} = 'R6OOH'; 
fR6OOH(i)=fR6OOH(i)-1; fOH(i)=fOH(i)+1; fHO2(i)=fHO2(i)+0.142; fRO2C(i)=fRO2C(i)+0.782; fRO2XC(i)=fRO2XC(i)+0.077; 
fzRNO3(i)=fzRNO3(i)+0.077; fRCHO(i)=fRCHO(i)+0.085; fPRD2(i)=fPRD2(i)+0.142; fxHO2(i)=fxHO2(i)+0.782; fxCCHO(i)=fxCCHO(i)+0.026; 
fxRCHO(i)=fxRCHO(i)+0.058; fxPROD2(i)=fxPROD2(i)+0.698; fyR6OOH(i)=fyR6OOH(i)+0.858; fXC(i)=fXC(i)+0.017; 

%BP28
i=i+1;
Rnames{i} = ' RAOOH + OH = 0.139*OH + 0.148*HO2 + 0.589*RO2C + 0.124*RO2XC + 0.124*zRNO3 + 0.074*PRD2 + 0.147*MGLY + 0.139*IPRD + 0.565*xHO2 + 0.024*xOH + 0.448*xRCHO + 0.026*xGLY + 0.03*xMEK + 0.252*xMGLY +  0.073*xAFG1 + 0.073*xAFG2 + 0.713*yR6OOH + 2.674*XC ';
k(:,i) =  1.41e-10;
Gstr{i,1} = 'RAOOH'; Gstr{i,2} = 'OH'; 
fRAOOH(i)=fRAOOH(i)-1; fOH(i)=fOH(i)-1; fOH(i)=fOH(i)+0.139; fHO2(i)=fHO2(i)+0.148; fRO2C(i)=fRO2C(i)+0.589; fRO2XC(i)=fRO2XC(i)+0.124;
fzRNO3(i)=fzRNO3(i)+0.124; fPRD2(i)=fPRD2(i)+0.074; fMGLY(i)=fMGLY(i)+0.147; fIPRD(i)=fIPRD(i)+0.139; fxHO2(i)=fxHO2(i)+0.565; 
fxOH(i)=fxOH(i)+0.024; fxRCHO(i)=fxRCHO(i)+0.448; fxGLY(i)=fxGLY(i)+0.026; fxMEK(i)=fxMEK(i)+0.03; fxMGLY(i)=fxMGLY(i)+0.252;
fxAFG1(i)=fxAFG1(i)+0.073; fxAFG2(i)=fxAFG2(i)+0.073; fyR6OOH(i)=fyR6OOH(i)+0.713; fXC(i)=fXC(i)+2.674; 

%BP29
i=i+1;
Rnames{i} = ' RAOOH + hv = OH + HO2 + 0.5*GLY + 0.5*MGLY + 0.5*AFG1 + 0.5*AFG2 + 0.5*XC';
k(:,i) =  1.0.*JCOOH;
Gstr{i,1} = 'RAOOH'; 
fRAOOH(i)=fRAOOH(i)-1; fOH(i)=fOH(i)+1; fHO2(i)=fHO2(i)+1; fGLY(i)=fGLY(i)+0.5; fMGLY(i)=fMGLY(i)+0.5; fAFG1(i)=fAFG1(i)+0.5; 
fAFG2(i)=fAFG2(i)+0.5; fXC(i)=fXC(i)+0.5; 

%BP37
i=i+1;
Rnames{i} = ' BACL + hv = 2*MECO3 ';
k(:,i) =  1.0.*JBACL_07;
Gstr{i,1} = 'BACL'; 
fBACL(i)=fBACL(i)-1; fMECO3(i)=fMECO3(i)+2; 

%BP38
i=i+1;
Rnames{i} = ' CRES + OH = 0.2*BZO + 0.8*RO2C + 0.8*xHO2 + 0.8*yR6OOH + 0.25*xMGLY +  5.05*XC ';
k(:,i) =  1.70e-12.*exp(950./ T);
Gstr{i,1} = 'CRES'; Gstr{i,2} = 'OH'; 
fCRES(i)=fCRES(i)-1; fOH(i)=fOH(i)-1; fBZO(i)=fBZO(i)+0.2; fRO2C(i)=fRO2C(i)+0.8; fxHO2(i)=fxHO2(i)+0.8; fyR6OOH(i)=fyR6OOH(i)+0.8; 
fxMGLY(i)=fxMGLY(i)+0.25; fXC(i)=fXC(i)+5.05; 

%BP39
i=i+1;
Rnames{i} = ' CRES + NO3 = HNO3 + BZO + XC ';
k(:,i) =  1.40e-11;
Gstr{i,1} = 'CRES'; Gstr{i,2} = 'NO3'; 
fCRES(i)=fCRES(i)-1; fNO3(i)=fNO3(i)-1; fHNO3(i)=fHNO3(i)+1; fBZO(i)=fBZO(i)+1; fXC(i)=fXC(i)+1; 

%BP40
i=i+1;
Rnames{i} = ' NPHE + OH = BZO + XN ';
k(:,i) =  3.50e-12;
Gstr{i,1} = 'NPHE'; Gstr{i,2} = 'OH'; 
fNPHE(i)=fNPHE(i)-1; fOH(i)=fOH(i)-1; fBZO(i)=fBZO(i)+1; fXN(i)=fXN(i)+1; 

%BP41
i=i+1;
Rnames{i} = ' NPHE + hv = HONO + 6*XC ';
k(:,i) =  1.50e-3.*JNO2_06;
Gstr{i,1} = 'NPHE'; 
fNPHE(i)=fNPHE(i)-1; fHONO(i)=fHONO(i)+1; fXC(i)=fXC(i)+6; 

%BP42
i=i+1;
Rnames{i} = ' NPHE + hv = 6*XC + XN ';
k(:,i) =  1.50e-2.*JNO2_06;
Gstr{i,1} = 'NPHE'; 
fNPHE(i)=fNPHE(i)-1; fXC(i)=fXC(i)+6; fXN(i)=fXN(i)+1; 

%BP43
i=i+1;
Rnames{i} = ' BALD + OH = BZCO3 ';
k(:,i) =  1.20e-11;
Gstr{i,1} = 'BALD'; Gstr{i,2} = 'OH'; 
fBALD(i)=fBALD(i)-1; fOH(i)=fOH(i)-1; fBZCO3(i)=fBZCO3(i)+1; 

%BP44
i=i+1;
Rnames{i} = ' BALD + hv = 7*XC ';
k(:,i) =  6.00e-2.*JBALD_06;
Gstr{i,1} = 'BALD'; 
fBALD(i)=fBALD(i)-1; fXC(i)=fXC(i)+7; 

%BP45
i=i+1;
Rnames{i} = ' BALD + NO3 = HNO3 + BZCO3 ';
k(:,i) =  1.34e-12.*exp(-1860./ T);
Gstr{i,1} = 'BALD'; Gstr{i,2} = 'NO3'; 
fBALD(i)=fBALD(i)-1; fNO3(i)=fNO3(i)-1; fHNO3(i)=fHNO3(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%BP46
i=i+1;
Rnames{i} = ' AFG1 + OH = 0.217*MACO3 + 0.723*RO2C + 0.06*RO2XC + 0.06*zRNO3 + 0.521*xHO2 + 0.201*xMECO3 + 0.334*xCO + 0.407*xRCHO + 0.129*xMEK +  0.107*xGLY + 0.267*xMGLY + 0.783*yR6OOH + 0.284*XC ';
k(:,i) =  7.40e-11;
Gstr{i,1} = 'AFG1'; Gstr{i,2} = 'OH'; 
fAFG1(i)=fAFG1(i)-1; fOH(i)=fOH(i)-1; fMACO3(i)=fMACO3(i)+0.217; fRO2C(i)=fRO2C(i)+0.723; fRO2XC(i)=fRO2XC(i)+0.06; 
fzRNO3(i)=fzRNO3(i)+0.06; fxHO2(i)=fxHO2(i)+0.521; fxMECO3(i)=fxMECO3(i)+0.201; fxCO(i)=fxCO(i)+0.334; fxRCHO(i)=fxRCHO(i)+0.407; 
fxMEK(i)=fxMEK(i)+0.129; fxGLY(i)=fxGLY(i)+0.107; fxMGLY(i)=fxMGLY(i)+0.267; fyR6OOH(i)=fyR6OOH(i)+0.783; fXC(i)=fXC(i)+0.284; 

%BP47
i=i+1;
Rnames{i} = ' AFG1 + O3 = 0.826*OH + 0.522*HO2 + 0.652*RO2C + 0.522*CO + 0.174*CO2 + 0.432*GLY + 0.568*MGLY + 0.652*xRCO3 + 0.652*xHCHO + 0.652*yR6OOH +  -0.872*XC ';
k(:,i) =  9.66e-18;
Gstr{i,1} = 'AFG1'; Gstr{i,2} = 'O3'; 
fAFG1(i)=fAFG1(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.826; fHO2(i)=fHO2(i)+0.522; fRO2C(i)=fRO2C(i)+0.652; fCO(i)=fCO(i)+0.522; 
fCO2(i)=fCO2(i)+0.174; fGLY(i)=fGLY(i)+0.432; fMGLY(i)=fMGLY(i)+0.568; fxRCO3(i)=fxRCO3(i)+0.652; fxHCHO(i)=fxHCHO(i)+0.652; 
fyR6OOH(i)=fyR6OOH(i)+0.652; fXC(i)=fXC(i)+-0.872; 

%BP48
i=i+1;
Rnames{i} = ' AFG1 + hv = 1.023*HO2 + 0.173*MEO2 + 0.305*MECO3 + 0.5*MACO3 + 0.695*CO +  0.195*GLY + 0.305*MGLY + 0.217*XC ';
k(:,i) =  1.0.*JAFG1;
Gstr{i,1} = 'AFG1'; 
fAFG1(i)=fAFG1(i)-1; fHO2(i)=fHO2(i)+1.023; fMEO2(i)=fMEO2(i)+0.173; fMECO3(i)=fMECO3(i)+0.305; fMACO3(i)=fMACO3(i)+0.5; 
fCO(i)=fCO(i)+0.695; fGLY(i)=fGLY(i)+0.195; fMGLY(i)=fMGLY(i)+0.305; fXC(i)=fXC(i)+0.217; 

%BP49
i=i+1;
Rnames{i} = ' AFG2 + OH = 0.217*MACO3 + 0.723*RO2C + 0.06*RO2XC + 0.06*zRNO3 + 0.521*xHO2 + 0.201*xMECO3 + 0.334*xCO + 0.407*xRCHO + 0.129*xMEK +  0.107*xGLY + 0.267*xMGLY + 0.783*yR6OOH + 0.284*XC ';
k(:,i) =  7.40e-11;
Gstr{i,1} = 'AFG2'; Gstr{i,2} = 'OH'; 
fAFG2(i)=fAFG2(i)-1; fOH(i)=fOH(i)-1; fMACO3(i)=fMACO3(i)+0.217; fRO2C(i)=fRO2C(i)+0.723; fRO2XC(i)=fRO2XC(i)+0.06; 
fzRNO3(i)=fzRNO3(i)+0.06; fxHO2(i)=fxHO2(i)+0.521; fxMECO3(i)=fxMECO3(i)+0.201; fxCO(i)=fxCO(i)+0.334; fxRCHO(i)=fxRCHO(i)+0.407;
fxMEK(i)=fxMEK(i)+0.129; fxGLY(i)=fxGLY(i)+0.107; fxMGLY(i)=fxMGLY(i)+0.267; fyR6OOH(i)=fyR6OOH(i)+0.783; fXC(i)=fXC(i)+0.284; 

%BP50
i=i+1;
Rnames{i} = ' AFG2 + O3 = 0.826*OH + 0.522*HO2 + 0.652*RO2C + 0.522*CO + 0.174*CO2 + 0.432*GLY + 0.568*MGLY + 0.652*xRCO3 + 0.652*xHCHO + 0.652*yR6OOH +  -0.872*XC ';
k(:,i) =  9.66e-18;
Gstr{i,1} = 'AFG2'; Gstr{i,2} = 'O3'; 
fAFG2(i)=fAFG2(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.826; fHO2(i)=fHO2(i)+0.522; 
fRO2C(i)=fRO2C(i)+0.652; fCO(i)=fCO(i)+0.522; fCO2(i)=fCO2(i)+0.174; fGLY(i)=fGLY(i)+0.432; 
fMGLY(i)=fMGLY(i)+0.568; fxRCO3(i)=fxRCO3(i)+0.652; fxHCHO(i)=fxHCHO(i)+0.652; fyR6OOH(i)=fyR6OOH(i)+0.652; fXC(i)=fXC(i)+-0.872; 

%BP51
i=i+1;
Rnames{i} = ' AFG2 + hv = PRD2 + -1*XC ';
k(:,i) =  1.0.*JAFG1;
Gstr{i,1} = 'AFG2'; 
fAFG2(i)=fAFG2(i)-1; fPRD2(i)=fPRD2(i)+1; fXC(i)=fXC(i)+-1; 

%BP52
i=i+1;
Rnames{i} = ' AFG3 + OH = 0.206*MACO3 + 0.733*RO2C + 0.117*RO2XC + 0.117*zRNO3 + 0.561*xHO2 + 0.117*xMECO3 + 0.114*xCO + 0.274*xGLY + 0.153*xMGLY + 0.019*xBACL + 0.195*xAFG1 + 0.195*xAFG2 + 0.231*xIPRD + 0.794*yR6OOH +  0.938*XC ';
k(:,i) =  9.35e-11;
Gstr{i,1} = 'AFG3'; Gstr{i,2} = 'OH'; 
fAFG3(i)=fAFG3(i)-1; fOH(i)=fOH(i)-1; fMACO3(i)=fMACO3(i)+0.206; fRO2C(i)=fRO2C(i)+0.733; 
fRO2XC(i)=fRO2XC(i)+0.117; fzRNO3(i)=fzRNO3(i)+0.117; fxHO2(i)=fxHO2(i)+0.561; fxMECO3(i)=fxMECO3(i)+0.117;
fxCO(i)=fxCO(i)+0.114; fxGLY(i)=fxGLY(i)+0.274; fxMGLY(i)=fxMGLY(i)+0.153; fxBACL(i)=fxBACL(i)+0.019; fxAFG1(i)=fxAFG1(i)+0.195; fxAFG2(i)=fxAFG2(i)+0.195; fxIPRD(i)=fxIPRD(i)+0.231; fyR6OOH(i)=fyR6OOH(i)+0.794; fXC(i)=fXC(i)+0.938; 

%BP53
i=i+1;
Rnames{i} = ' AFG3 + O3 = 0.471*OH + 0.554*HO2 + 0.013*MECO3 + 0.258*RO2C + 0.007*RO2XC + 0.007*zRNO3 + 0.58*CO + 0.19*CO2 + 0.366*GLY + 0.184*MGLY + 0.35*AFG1 + 0.35*AFG2 + 0.139*AFG3 + 0.003*MACR + 0.004*MVK + 0.003*IPRD + 0.095*xHO2 + 0.163*xRCO3 + 0.163*xHCHO +  0.095*xMGLY + 0.264*yR6OOH + -0.575*XC ';
k(:,i) =  1.43e-17;
Gstr{i,1} = 'AFG3'; Gstr{i,2} = 'O3'; 
fAFG3(i)=fAFG3(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.471; fHO2(i)=fHO2(i)+0.554; 
fMECO3(i)=fMECO3(i)+0.013; fRO2C(i)=fRO2C(i)+0.258; fRO2XC(i)=fRO2XC(i)+0.007; fzRNO3(i)=fzRNO3(i)+0.007;
fCO(i)=fCO(i)+0.58; fCO2(i)=fCO2(i)+0.19; fGLY(i)=fGLY(i)+0.366; fMGLY(i)=fMGLY(i)+0.184; fAFG1(i)=fAFG1(i)+0.35;
fAFG2(i)=fAFG2(i)+0.35; fAFG3(i)=fAFG3(i)+0.139; fMACR(i)=fMACR(i)+0.003; fMVK(i)=fMVK(i)+0.004; fIPRD(i)=fIPRD(i)+0.003; 
fxHO2(i)=fxHO2(i)+0.095; fxRCO3(i)=fxRCO3(i)+0.163; fxHCHO(i)=fxHCHO(i)+0.163; fxMGLY(i)=fxMGLY(i)+0.095; 
fyR6OOH(i)=fyR6OOH(i)+0.264; fXC(i)=fXC(i)+-0.575; 

%BP64
i=i+1;
Rnames{i} = ' IPRD + OH = 0.289*MACO3 + 0.67*RO2C + 0.67*xHO2 + 0.041*RO2XC + 0.041*zRNO3 + 0.336*xCO + 0.055*xHCHO + 0.129*xCCHO + 0.013*xRCHO + 0.15*xMEK + 0.332*xPROD2 + 0.15*xGLY + 0.174*xMGLY + -0.504*XC +  0.711*yR6OOH ';
k(:,i) =  6.19e-11;
Gstr{i,1} = 'IPRD'; Gstr{i,2} = 'OH'; 
fIPRD(i)=fIPRD(i)-1; fOH(i)=fOH(i)-1; fMACO3(i)=fMACO3(i)+0.289; fRO2C(i)=fRO2C(i)+0.67; fxHO2(i)=fxHO2(i)+0.67; fRO2XC(i)=fRO2XC(i)+0.041; fzRNO3(i)=fzRNO3(i)+0.041; fxCO(i)=fxCO(i)+0.336; fxHCHO(i)=fxHCHO(i)+0.055; fxCCHO(i)=fxCCHO(i)+0.129; fxRCHO(i)=fxRCHO(i)+0.013; fxMEK(i)=fxMEK(i)+0.15; fxPROD2(i)=fxPROD2(i)+0.332; fxGLY(i)=fxGLY(i)+0.15; fxMGLY(i)=fxMGLY(i)+0.174; fXC(i)=fXC(i)+-0.504; fyR6OOH(i)=fyR6OOH(i)+0.711; 

%BP65 products changed
i=i+1;
Rnames{i} = ' IPRD + O3 = 0.285*OH + 0.4*HO2 + 0.048*RO2C + 0.048*xRCO3 + 0.498*CO + 0.14*CO2 + 0.124*HCHO + 0.21*MEK + 0.023*GLY + 0.742*MGLY + 0.1*FACD + 0.372*RCOOH + 0.047*xHOCCHO + 0.001*xHCHO + 0.048*yR6OOH + -0.329*XC';
k(:,i) =  4.18e-18;
Gstr{i,1} = 'IPRD'; Gstr{i,2} = 'O3'; 
fIPRD(i)=fIPRD(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.285; fHO2(i)=fHO2(i)+0.4; 
fRO2C(i)=fRO2C(i)+0.048; fxRCO3(i)=fxRCO3(i)+0.048; fCO(i)=fCO(i)+0.498; fCO2(i)=fCO2(i)+0.14; 
fHCHO(i)=fHCHO(i)+0.124; fMEK(i)=fMEK(i)+0.21; fGLY(i)=fGLY(i)+0.023; fMGLY(i)=fMGLY(i)+0.742; 
fFACD(i)=fFACD(i)+0.1; fRCOOH(i)=fRCOOH(i)+0.372; fxHOCCHO(i)=fxHOCCHO(i)+0.047; fxHCHO(i)=fxHCHO(i)+0.001; fyR6OOH(i)=fyR6OOH(i)+0.048; fXC(i)=fXC(i)+-0.329; 

%BP66
i=i+1;
Rnames{i} = ' IPRD + NO3 = 0.15*MACO3 + 0.15*HNO3 + 0.799*RO2C + 0.799*xHO2 + 0.051*RO2XC + 0.051*zRNO3 + 0.572*xCO + 0.227*xHCHO + 0.218*xRCHO + 0.008*xMGLY + 0.572*xRNO3 + 0.85*yR6OOH + 0.278*XN + -0.815*XC';
k(:,i) =  1.00e-13;
Gstr{i,1} = 'IPRD'; Gstr{i,2} = 'NO3'; 
fIPRD(i)=fIPRD(i)-1; fNO3(i)=fNO3(i)-1; fMACO3(i)=fMACO3(i)+0.15; fHNO3(i)=fHNO3(i)+0.15; fRO2C(i)=fRO2C(i)+0.799; fxHO2(i)=fxHO2(i)+0.799; fRO2XC(i)=fRO2XC(i)+0.051; fzRNO3(i)=fzRNO3(i)+0.051; fxCO(i)=fxCO(i)+0.572; fxHCHO(i)=fxHCHO(i)+0.227; fxRCHO(i)=fxRCHO(i)+0.218; fxMGLY(i)=fxMGLY(i)+0.008; fxRNO3(i)=fxRNO3(i)+0.572; fyR6OOH(i)=fyR6OOH(i)+0.85; fXN(i)=fXN(i)+0.278; fXC(i)=fXC(i)+-0.815; 

%BP67
i=i+1;
Rnames{i} = ' IPRD + hv = 1.233*HO2 + 0.467*MECO3 + 0.3*RCO3 + 1.233*CO + 0.3*HCHO +  0.467*HOCCHO + 0.233*MEK + -0.233*XC ';
k(:,i) =  1.0.*JMACR_06;
Gstr{i,1} = 'IPRD'; 
fIPRD(i)=fIPRD(i)-1; fHO2(i)=fHO2(i)+1.233; fMECO3(i)=fMECO3(i)+0.467; fRCO3(i)=fRCO3(i)+0.3;
fCO(i)=fCO(i)+1.233; fHCHO(i)=fHCHO(i)+0.3; fHOCCHO(i)=fHOCCHO(i)+0.467; fMEK(i)=fMEK(i)+0.233; fXC(i)=fXC(i)+-0.233; 

%BP68
i=i+1;
Rnames{i} = ' PRD2 + OH = 0.472*HO2 + 0.379*xHO2 + 0.029*xMECO3 + 0.049*xRCO3 + 0.473*RO2C + 0.071*RO2XC + 0.071*zRNO3 + 0.002*HCHO + 0.211*xHCHO + 0.001*CCHO + 0.083*xCCHO + 0.143*RCHO + 0.402*xRCHO + 0.115*xMEK +  0.329*PRD2 + 0.007*xPROD2 + 0.528*yR6OOH + 0.877*XC ';
k(:,i) =  1.55e-11;
Gstr{i,1} = 'PRD2'; Gstr{i,2} = 'OH'; 
fPRD2(i)=fPRD2(i)-1; fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+0.472; fxHO2(i)=fxHO2(i)+0.379; fxMECO3(i)=fxMECO3(i)+0.029; fxRCO3(i)=fxRCO3(i)+0.049; fRO2C(i)=fRO2C(i)+0.473; fRO2XC(i)=fRO2XC(i)+0.071; fzRNO3(i)=fzRNO3(i)+0.071; fHCHO(i)=fHCHO(i)+0.002; fxHCHO(i)=fxHCHO(i)+0.211; fCCHO(i)=fCCHO(i)+0.001; fxCCHO(i)=fxCCHO(i)+0.083; fRCHO(i)=fRCHO(i)+0.143; fxRCHO(i)=fxRCHO(i)+0.402; fxMEK(i)=fxMEK(i)+0.115; fPRD2(i)=fPRD2(i)+0.329; fxPROD2(i)=fxPROD2(i)+0.007; fyR6OOH(i)=fyR6OOH(i)+0.528; fXC(i)=fXC(i)+0.877; 

%BP69
i=i+1;
Rnames{i} = ' PRD2 + hv = 0.913*xHO2 + 0.4*MECO3 + 0.6*RCO3 + 1.59*RO2C + 0.087*RO2XC + 0.087*zRNO3 + 0.303*xHCHO + 0.163*xCCHO + 0.78*xRCHO + yR6OOH +  -0.091*XC ';
k(:,i) =  4.86e-3.*JMEK_06;
Gstr{i,1} = 'PRD2'; 
fPRD2(i)=fPRD2(i)-1; fxHO2(i)=fxHO2(i)+0.913; fMECO3(i)=fMECO3(i)+0.4; fRCO3(i)=fRCO3(i)+0.6; fRO2C(i)=fRO2C(i)+1.59; fRO2XC(i)=fRO2XC(i)+0.087; fzRNO3(i)=fzRNO3(i)+0.087; fxHCHO(i)=fxHCHO(i)+0.303; fxCCHO(i)=fxCCHO(i)+0.163; fxRCHO(i)=fxRCHO(i)+0.78; fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+-0.091; 

%BP70
i=i+1;
Rnames{i} = ' RNO3 + OH = 0.189*HO2 + 0.305*xHO2 + 0.019*NO2 + 0.313*xNO2 + 0.976*RO2C + 0.175*RO2XC + 0.175*zRNO3 + 0.011*xHCHO + 0.429*xCCHO + 0.001*RCHO + 0.036*xRCHO + 0.004*xACET + 0.01*MEK + 0.17*xMEK + 0.008*PRD2 + 0.031*xPROD2 + 0.189*RNO3 + 0.305*xRNO3 + 0.157*yROOH +  0.636*yR6OOH + 0.174*XN + 0.04*XC ';
k(:,i) =  7.20e-12;
Gstr{i,1} = 'RNO3'; Gstr{i,2} = 'OH'; 
fRNO3(i)=fRNO3(i)-1; fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+0.189; fxHO2(i)=fxHO2(i)+0.305; fNO2(i)=fNO2(i)+0.019; fxNO2(i)=fxNO2(i)+0.313; fRO2C(i)=fRO2C(i)+0.976; fRO2XC(i)=fRO2XC(i)+0.175; fzRNO3(i)=fzRNO3(i)+0.175; fxHCHO(i)=fxHCHO(i)+0.011; fxCCHO(i)=fxCCHO(i)+0.429; fRCHO(i)=fRCHO(i)+0.001; fxRCHO(i)=fxRCHO(i)+0.036; fxACET(i)=fxACET(i)+0.004; fMEK(i)=fMEK(i)+0.01; fxMEK(i)=fxMEK(i)+0.17; fPRD2(i)=fPRD2(i)+0.008; fxPROD2(i)=fxPROD2(i)+0.031; fRNO3(i)=fRNO3(i)+0.189; fxRNO3(i)=fxRNO3(i)+0.305; fyROOH(i)=fyROOH(i)+0.157; fyR6OOH(i)=fyR6OOH(i)+0.636; fXN(i)=fXN(i)+0.174; fXC(i)=fXC(i)+0.04; 

%BP71
i=i+1;
Rnames{i} = ' RNO3 + hv = 0.344*HO2 + 0.554*xHO2 + NO2 + 0.721*RO2C + 0.102*RO2XC + 0.102*zRNO3 + 0.074*HCHO + 0.061*xHCHO + 0.214*CCHO + 0.23*xCCHO + 0.074*RCHO + 0.063*xRCHO + 0.008*xACET + 0.124*MEK + 0.083*xMEK + 0.19*PRD2 + 0.261*xPROD2 + 0.066*yROOH + 0.591*yR6OOH + 0.396*XC';
k(:,i) =  1.0.*JIC3ONO2;
Gstr{i,1} = 'RNO3'; 
fRNO3(i)=fRNO3(i)-1; fHO2(i)=fHO2(i)+0.344; fxHO2(i)=fxHO2(i)+0.554; fNO2(i)=fNO2(i)+1; fRO2C(i)=fRO2C(i)+0.721; fRO2XC(i)=fRO2XC(i)+0.102; fzRNO3(i)=fzRNO3(i)+0.102; fHCHO(i)=fHCHO(i)+0.074; fxHCHO(i)=fxHCHO(i)+0.061; fCCHO(i)=fCCHO(i)+0.214; fxCCHO(i)=fxCCHO(i)+0.23; fRCHO(i)=fRCHO(i)+0.074; fxRCHO(i)=fxRCHO(i)+0.063; fxACET(i)=fxACET(i)+0.008; fMEK(i)=fMEK(i)+0.124; fxMEK(i)=fxMEK(i)+0.083; fPRD2(i)=fPRD2(i)+0.19; fxPROD2(i)=fxPROD2(i)+0.261; fyROOH(i)=fyROOH(i)+0.066; fyR6OOH(i)=fyR6OOH(i)+0.591; fXC(i)=fXC(i)+0.396; 

%BP75 new added
i=i+1;
Rnames{i} = ' ACROLEIN + OH = 0.25*xHO2 + 0.75*MACO3 + 0.25*RO2C + 0.167*xCO + 0.083*xHCHO + 0.167*xCCHO + 0.083*xGLY + 0.25*yROOH - 0.75*XC ';
k(:,i) =  1.99e-11;
Gstr{i,1} = 'ACROLEIN'; Gstr{i,2} = 'OH';
fACROLEIN(i)=fACROLEIN(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+0.25; fMACO3(i)=fMACO3(i)+0.75; 
fRO2C(i)=fRO2C(i)+0.25;fxCO(i)=fxCO(i)+0.167;fxHCHO(i)=fxHCHO(i)+0.083;fxCCHO(i)=fxCCHO(i)+0.167;
fxGLY(i)=fxGLY(i)+0.083;fyROOH(i)=fyROOH(i)+0.25;fXC(i)=fXC(i)-0.75;

%BP76 new added
i=i+1;
Rnames{i} = ' ACROLEIN + O3 = 0.83*HO2 + 0.33*OH + 1.005*CO + 0.31*CO2 + 0.5*HCHO + 0.185*FACD + 0.5*GLY ';
k(:,i) =   1.40e-15.*exp(-2528./ T);
Gstr{i,1} = 'ACROLEIN'; Gstr{i,2} = 'O3';
fACROLEIN(i)=fACROLEIN(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.33;fHO2(i)=fHO2(i)+0.83; fCO(i)=fCO(i)+1.005;
fHCHO(i)=fHCHO(i)+0.5;fGLY(i)=fGLY(i)+0.5;fCO2(i)=fCO2(i)+0.31;
fFACD(i)=fFACD(i)+0.185;

%BP77 new added
i=i+1;
Rnames{i} = ' ACROLEIN + NO3 = 0.031*xHO2 + 0.967*MACO3 + 0.031*RO2C + 0.002*RO2XC + 0.002*zRNO3 + 0.967*HNO3 + 0.031*xCO + 0.031*xRNO3 + 0.033*yROOH + 0.002*XN - 1.097*XC  ';
k(:,i) =   1.18e-15;
Gstr{i,1} = 'ACROLEIN'; Gstr{i,2} = 'NO3';
fACROLEIN(i)=fACROLEIN(i)-1; fNO3(i)=fNO3(i)-1; fxHO2(i)=fxHO2(i)+0.031; fMACO3(i)=fMACO3(i)+0.967; 
fRO2C(i)=fRO2C(i)+0.02;fxCO(i)=fxCO(i)+0.031;fzRNO3(i)=fzRNO3(i)+0.002;fHNO3(i)=fHNO3(i)+0.967;
fxRNO3(i)=fxRNO3(i)+0.031;fyROOH(i)=fyROOH(i)+0.033;fXN(i)=fXN(i)+0.002;fXC(i)=fXC(i)-1.097;

%BP78 new added
i=i+1;
Rnames{i} = ' ACROLEIN + O3P = RCHO ';
k(:,i) =   2.37e-12;
Gstr{i,1} = 'ACROLEIN'; Gstr{i,2} = 'O3P';
fACROLEIN(i)=fACROLEIN(i)-1; fO3P(i)=fO3P(i)-1; fRCHO(i)=fRCHO(i)+1;

%BP79 new added
i=i+1;
Rnames{i} = ' ACROLEIN + hv = 1.066*HO2 + 0.178*OH + 0.234*MEO2 + 0.33*MACO3 + 1.188*CO + 0.102*CO2 + 0.34*HCHO + 0.05*CCOOH - 0.284*XC ';
k(:,i) =  JACRO_09;
Gstr{i,1} = 'ACROLEIN'; 
fACROLEIN(i)=fACROLEIN(i)-1; fHO2(i)=fHO2(i)+1.066; fOH(i)=fOH(i)+0.178;fMACO3(i)=fMACO3(i)+0.33;fCO(i)=fCO(i)+1.188;
fCO2(i)=fCO2(i)+0.102;fHCHO(i)=fHCHO(i)+0.34;fCCOOH(i)=fCCOOH(i)+0.05;fXC(i)=fXC(i)-0.284;

%BP80 new added
i=i+1;
Rnames{i} = ' CCOOOH + OH = 0.98*MECO3 + 0.02*RO2C + 0.02*CO2 + 0.02*xOH + 0.02*xHCHO + 0.02*yROOH  ';
k(:,i) = 5.28e-12;
Gstr{i,1} = 'CCOOOH'; Gstr{i,2} = 'OH';
fCCOOOH(i)=fCCOOOH(i)-1; fOH(i)=fOH(i)-1; fMECO3(i)=fMECO3(i)+0.98;fRO2C(i)=fRO2C(i)+0.02;fCO2(i)=fCO2(i)+0.02;
fxOH(i)=fxOH(i)+0.02;fxHCHO(i)=fxHCHO(i)+0.02;fyROOH(i)=fyROOH(i)+0.02;

%BP81 new added
i=i+1;
Rnames{i} = ' CCOOOH = MEO2 + CO2 + OH  ';
k(:,i) = JPAA;
Gstr{i,1} = 'CCOOOH'; 
fCCOOOH(i)=fCCOOOH(i)-1; fMEO2(i)=fMEO2(i)+1; fCO2(i)=fCO2(i)+1;fOH(i)=fOH(i)+1;

%BP82 new added
i=i+1;
Rnames{i} = '  RCOOOH + OH = 0.806*RCO3 + 0.194*RO2C + 0.194*yROOH + 0.11*CO2 + 0.11*xOH + 0.11*xCCHO + 0.084*xHO2 + 0.084*xRCHO   ';
k(:,i) = 6.42e-12;
Gstr{i,1} = 'RCOOOH'; Gstr{i,2} = 'OH';
fRCOOOH(i)=fRCOOOH(i)-1; fOH(i)=fOH(i)-1;fRCO3(i)=fRCO3(i)+0.806; fCO2(i)=fCO2(i)+0.11;fxOH(i)=fxOH(i)+0.11;
fRO2C(i)=fRO2C(i)+0.194;fyROOH(i)=fyROOH(i)+0.194;fxCCHO(i)=fxCCHO(i)+0.11;fxHO2(i)=fxHO2(i)+0.084;fRCHO(i)=fRCHO(i)+0.084;

%BP83 new added
i=i+1;
Rnames{i} = '  RCOOOH = xHO2 + xCCHO + yROOH + CO2 + OH ';
k(:,i) = JPAA;
Gstr{i,1} = 'RCOOOH'; 
fRCOOOH(i)=fRCOOOH(i)-1; fCO2(i)=fCO2(i)+1;fOH(i)=fOH(i)+1;
fxHO2(i)=fxHO2(i)+1;fxCCHO(i)=fxCCHO(i)+1;fyROOH(i)=fyROOH(i)+1;

%BP84 new added
i=i+1;
Rnames{i} = '  HCOCO3 + NO  = HO2 + CO + CO2 + NO2  ';
k(:,i) =  6.70e-12.*exp(340./ T);
Gstr{i,1} = 'HCOCO3'; Gstr{i,2} = 'NO';
fHCOCO3(i)=fHCOCO3(i)-1;fNO(i)=fNO(i)-1; fCO2(i)=fCO2(i)+1;fHO2(i)=fHO2(i)+1;
fCO(i)=fCO(i)+1;fNO2(i)=fNO2(i)+1;

%BP85 new added
i=i+1;
Rnames{i} = '  HCOCO3 + NO2 = HO2 + CO + CO2 + NO3 ';
k(:,i) = 1.21e-11.*(T./300).^-1.07.*exp(0./T);
Gstr{i,1} = 'HCOCO3'; Gstr{i,2} = 'NO2';
fHCOCO3(i)=fHCOCO3(i)-1;fNO2(i)=fNO2(i)-1; fCO2(i)=fCO2(i)+1;fHO2(i)=fHO2(i)+1;
fCO(i)=fCO(i)+1;fNO3(i)=fNO3(i)+1;

%BP86 new added
i=i+1;
Rnames{i} = ' HCOCO3 + HO2 = 0.44*OH + 0.44*HO2 + 0.44*CO + 0.44*CO2 + 0.56*GLY + 0.15*O3 ';
k(:,i) = 5.20e-13.*exp(980./ T);
Gstr{i,1} = 'HCOCO3'; Gstr{i,2} = 'HO2';
fHCOCO3(i)=fHCOCO3(i)-1;fHO2(i)=fHO2(i)-1; fCO2(i)=fCO2(i)+0.44;fHO2(i)=fHO2(i)+0.44;fOH(i)=fOH(i)+0.44;
fCO(i)=fCO(i)+0.44;fO3(i)=fO3(i)+0.15;fGLY(i)=fGLY(i)+0.56;

%BE01
i=i+1;
Rnames{i} = ' CH4 + OH = MEO2 ';
k(:,i) =  1.85e-12.*exp(-1690./ T);
Gstr{i,1} = 'CH4'; Gstr{i,2} = 'OH'; 
fCH4(i)=fCH4(i)-1; fOH(i)=fOH(i)-1; fMEO2(i)=fMEO2(i)+1; 

%BE02
i=i+1;
Rnames{i} = ' ETHE + OH = RO2C + xHO2 + 1.61*xHCHO + 0.195*xCCHO + yROOH';
k(:,i) = K_ETHE_OH;
Gstr{i,1} = 'ETHE'; Gstr{i,2} = 'OH'; 
fETHE(i)=fETHE(i)-1; fOH(i)=fOH(i)-1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; 
fxHCHO(i)=fxHCHO(i)+1.61; fxCCHO(i)=fxCCHO(i)+0.195; fyROOH(i)=fyROOH(i)+1; 

%BE03
i=i+1;
Rnames{i} = ' ETHE + O3 = 0.16*OH + 0.16*HO2 + 0.51*CO + 0.12*CO2 + HCHO + 0.37*FACD';
k(:,i) =  9.14e-15.*exp(-2580./ T);
Gstr{i,1} = 'ETHE'; Gstr{i,2} = 'O3'; 
fETHE(i)=fETHE(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.16; fHO2(i)=fHO2(i)+0.16; 
fCO(i)=fCO(i)+0.51; fCO2(i)=fCO2(i)+0.12; fHCHO(i)=fHCHO(i)+1; fFACD(i)=fFACD(i)+0.37; 

%BE04
i=i+1;
Rnames{i} = ' ETHE + NO3 = RO2C + xHO2 + xRCHO + yROOH + -1*XC + XN';
%k(:,i) =  3.30e-12.*(T./300).^2.00.*exp(-2880./T);
k(:,i) =  3.30e-12.*exp(-2880./T);
Gstr{i,1} = 'ETHE'; Gstr{i,2} = 'NO3'; 
fETHE(i)=fETHE(i)-1; fNO3(i)=fNO3(i)-1; fRO2C(i)=fRO2C(i)+1; fxHO2(i)=fxHO2(i)+1; fxRCHO(i)=fxRCHO(i)+1; 
fyROOH(i)=fyROOH(i)+1; fXC(i)=fXC(i)+-1; fXN(i)=fXN(i)+1; 

%BE05
i=i+1;
Rnames{i} = ' ETHE + O3P = 0.8*HO2 + 0.51*MEO2 + 0.29*RO2C + 0.51*CO + 0.1*CCHO + 0.29*xHO2 + 0.278*xCO + 0.278*xHCHO + 0.012*xGLY + 0.29*yROOH + 0.2*XC';
k(:,i) =  1.07e-11.*exp(-800./ T);
Gstr{i,1} = 'ETHE'; Gstr{i,2} = 'O3P'; 
fETHE(i)=fETHE(i)-1; fO3P(i)=fO3P(i)-1; fHO2(i)=fHO2(i)+0.8; fMEO2(i)=fMEO2(i)+0.51; fRO2C(i)=fRO2C(i)+0.29; 
fCO(i)=fCO(i)+0.51; fCCHO(i)=fCCHO(i)+0.1; fxHO2(i)=fxHO2(i)+0.29; fxCO(i)=fxCO(i)+0.278; fxHCHO(i)=fxHCHO(i)+0.278; 
fxGLY(i)=fxGLY(i)+0.012; fyROOH(i)=fyROOH(i)+0.29; fXC(i)=fXC(i)+0.2; 

% BE10  use ACETYLENE (ACYE) and rate changed
i=i+1;
Rnames{i} = ' ACETYLENE + OH = 0.7*OH + 0.3*HO2 + 0.3*CO + 0.7*GLY + 0.3*FACD';
k(:,i) = K_ACYE_OH;
Gstr{i,1} = 'ACETYLENE'; Gstr{i,2} = 'OH'; 
fACETYLENE(i)=fACETYLENE(i)-1; fOH(i)=fOH(i)-1; fOH(i)=fOH(i)+0.7; fHO2(i)=fHO2(i)+0.3; 
fCO(i)=fCO(i)+0.3; fGLY(i)=fGLY(i)+0.7; fFACD(i)=fFACD(i)+0.3;

%BE11
i=i+1;
Rnames{i} = ' ACETYLENE + O3 = 0.5*OH + 1.5*HO2 + 1.5*CO + 0.5*CO2 ';
k(:,i) =  1.00e-14.*exp(-4100./ T);
Gstr{i,1} = 'ACETYLENE'; Gstr{i,2} = 'O3'; 
fACETYLENE(i)=fACETYLENE(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.5; fHO2(i)=fHO2(i)+1.5; fCO(i)=fCO(i)+1.5; fCO2(i)=fCO2(i)+0.5; 

%BE12 (BENZENE)
i=i+1;
Rnames{i} = ' BENZ + OH = 0.116*OH + 0.29*RO2C + 0.29*xHO2 + 0.024*RO2XC + 0.024*zRNO3 + 0.57*HO2 + 0.57*CRES + 0.116*AFG3 + 0.29*xGLY +  0.029*xAFG1 + 0.261*xAFG2 + 0.314*yRAOOH + -0.976*XC + BENZRO2';
k(:,i) =  2.33e-12.*exp(-193./ T);
Gstr{i,1} = 'BENZ'; Gstr{i,2} = 'OH'; 
fBENZ(i)=fBENZ(i)-1; fOH(i)=fOH(i)-1; fOH(i)=fOH(i)+0.116; fRO2C(i)=fRO2C(i)+0.29; 
fxHO2(i)=fxHO2(i)+0.29; fRO2XC(i)=fRO2XC(i)+0.024; fzRNO3(i)=fzRNO3(i)+0.024; fHO2(i)=fHO2(i)+0.57; 
fCRES(i)=fCRES(i)+0.57; fAFG3(i)=fAFG3(i)+0.116; fxGLY(i)=fxGLY(i)+0.29; fxAFG1(i)=fxAFG1(i)+0.029; 
fxAFG2(i)=fxAFG2(i)+0.261; fyRAOOH(i)=fyRAOOH(i)+0.314; fXC(i)=fXC(i)+-0.976; 
fBENZRO2(i)=fBENZRO2(i)+1;

%BL01
i=i+1;
Rnames{i} = ' ALK1 + OH = xHO2 + RO2C + xCCHO + yROOH ';
k(:,i) =  1.34e-12.*(T./300).^2.00.*exp(-499./T);
Gstr{i,1} = 'ALK1'; Gstr{i,2} = 'OH'; 
fALK1(i)=fALK1(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+1; fRO2C(i)=fRO2C(i)+1; fxCCHO(i)=fxCCHO(i)+1; fyROOH(i)=fyROOH(i)+1; 

%BL02
i=i+1;
Rnames{i} = ' ALK2 + OH = 0.965*xHO2 + 0.965*RO2C + 0.035*RO2XC + 0.035*zRNO3 +  0.261*xRCHO + 0.704*xACET + yROOH + -0.105*XC ';
k(:,i) =  1.49e-12.*(T./300).^2.00.*exp(-87./T);
Gstr{i,1} = 'ALK2'; Gstr{i,2} = 'OH'; 
fALK2(i)=fALK2(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+0.965; fRO2C(i)=fRO2C(i)+0.965; fRO2XC(i)=fRO2XC(i)+0.035; fzRNO3(i)=fzRNO3(i)+0.035; fxRCHO(i)=fxRCHO(i)+0.261; fxACET(i)=fxACET(i)+0.704; fyROOH(i)=fyROOH(i)+1; fXC(i)=fXC(i)+-0.105; 

%BL03
i=i+1;
Rnames{i} = ' ALK3 + OH = 0.695*xHO2 + 0.236*xTBUO + 1.253*RO2C + 0.07*RO2XC + 0.07*zRNO3 + 0.026*xHCHO + 0.445*xCCHO + 0.122*xRCHO + 0.024*xACET +  0.332*xMEK + 0.983*yROOH + 0.017*yR6OOH + -0.046*XC ';
k(:,i) =  1.51e-12.*exp(126./ T);
Gstr{i,1} = 'ALK3'; Gstr{i,2} = 'OH'; 
fALK3(i)=fALK3(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+0.695; fxTBUO(i)=fxTBUO(i)+0.236; fRO2C(i)=fRO2C(i)+1.253; fRO2XC(i)=fRO2XC(i)+0.07; fzRNO3(i)=fzRNO3(i)+0.07; fxHCHO(i)=fxHCHO(i)+0.026; fxCCHO(i)=fxCCHO(i)+0.445; fxRCHO(i)=fxRCHO(i)+0.122; fxACET(i)=fxACET(i)+0.024; fxMEK(i)=fxMEK(i)+0.332; fyROOH(i)=fyROOH(i)+0.983; fyR6OOH(i)=fyR6OOH(i)+0.017; fXC(i)=fXC(i)+-0.046; 

%BL04
i=i+1;
Rnames{i} = ' ALK4 + OH = 0.83*xHO2 + 0.01*xMEO2 + 0.011*xMECO3 + 1.763*RO2C + 0.149*RO2XC + 0.149*zRNO3 + 0.002*xCO + 0.029*xHCHO + 0.438*xCCHO + 0.236*xRCHO + 0.426*xACET + 0.106*xMEK + 0.146*xPROD2 + yR6OOH +  -0.119*XC ';
k(:,i) =  3.75e-12.*exp(44./ T);
Gstr{i,1} = 'ALK4'; Gstr{i,2} = 'OH'; 
fALK4(i)=fALK4(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+0.83; fxMEO2(i)=fxMEO2(i)+0.01; fxMECO3(i)=fxMECO3(i)+0.011; fRO2C(i)=fRO2C(i)+1.763; fRO2XC(i)=fRO2XC(i)+0.149; fzRNO3(i)=fzRNO3(i)+0.149; fxCO(i)=fxCO(i)+0.002; fxHCHO(i)=fxHCHO(i)+0.029; fxCCHO(i)=fxCCHO(i)+0.438; fxRCHO(i)=fxRCHO(i)+0.236; fxACET(i)=fxACET(i)+0.426; fxMEK(i)=fxMEK(i)+0.106; fxPROD2(i)=fxPROD2(i)+0.146; fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+-0.119; 

%BL05
i=i+1;
Rnames{i} = ' ALK5 + OH = 0.647*xHO2 + 1.605*RO2C + 0.353*RO2XC + 0.353*zRNO3 + 0.04*xHCHO + 0.106*xCCHO + 0.209*xRCHO + 0.071*xACET + 0.086*xMEK +  0.407*xPROD2 + yR6OOH + 2.004*XC ';
k(:,i) =  2.70e-12.*exp(374./ T);
Gstr{i,1} = 'ALK5'; Gstr{i,2} = 'OH'; 
fALK5(i)=fALK5(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+0.647; fRO2C(i)=fRO2C(i)+1.605; fRO2XC(i)=fRO2XC(i)+0.353; fzRNO3(i)=fzRNO3(i)+0.353; fxHCHO(i)=fxHCHO(i)+0.04; fxCCHO(i)=fxCCHO(i)+0.106; fxRCHO(i)=fxRCHO(i)+0.209; fxACET(i)=fxACET(i)+0.071; fxMEK(i)=fxMEK(i)+0.086; fxPROD2(i)=fxPROD2(i)+0.407; fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+2.004; 

%AALK
i=i+1;
Rnames{i} =   'SOAALK + OH  = OH + 0.006*SVAVB2 + 0.052*SVAVB3 + 0.081*SVAVB4   ';
k(:,i) = 2.7e-12.*exp(374./T);
Gstr{i,1} = 'SOAALK';Gstr{i,1} = 'OH';
fSOAALK(i)=fSOAALK(i)-1;fOH(i)=fOH(i)+1;fOH(i)=fOH(i)-1;fSVAVB2(i)=fSVAVB2(i)+0.006;
fSVAVB3(i)=fSVAVB3(i)+0.052;fSVAVB4(i)=fSVAVB4(i)+0.081;

%BL06
i=i+1;
Rnames{i} = ' OLE1 + OH = 0.871*xHO2 + 0.001*xMEO2 + 1.202*RO2C + 0.128*RO2XC +0.128*zRNO3 + 0.582*xHCHO + 0.01*xCCHO + 0.007*xHOCCHO + 0.666*xRCHO +0.007*xACET + 0.036*xACROLEIN + 0.001*xMACR + 0.012*xMVK +0.009*xIPRD + 0.168*xPROD2 + 0.169*yROOH + 0.831*yR6OOH +0.383*XC';
k(:,i) =  6.72e-12.*exp(501./ T);
Gstr{i,1} = 'OLE1'; Gstr{i,2} = 'OH'; 
fOLE1(i)=fOLE1(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+0.871; fxMEO2(i)=fxMEO2(i)+0.001; fRO2C(i)=fRO2C(i)+1.202;
fRO2XC(i)=fRO2XC(i)+0.128; fzRNO3(i)=fzRNO3(i)+0.128; fxHCHO(i)=fxHCHO(i)+0.582; fxCCHO(i)=fxCCHO(i)+0.01;fxHOCCHO(i)=fxHOCCHO(i)+0.007;
fxRCHO(i)=fxRCHO(i)+0.666; fxACET(i)=fxACET(i)+0.007; fxMACR(i)=fxMACR(i)+0.001; fxMVK(i)=fxMVK(i)+0.012; 
fxIPRD(i)=fxIPRD(i)+0.009; fxPROD2(i)=fxPROD2(i)+0.168; fyROOH(i)=fyROOH(i)+0.169; fyR6OOH(i)=fyR6OOH(i)+0.831; 
fXC(i)=fXC(i)+0.383; fxACROLEIN(i)=fxACROLEIN(i)+0.036; 

%BL07
i=i+1;
Rnames{i} = ' OLE1 + O3 = 0.095*HO2 + 0.057*xHO2 + 0.128*OH + 0.09*RO2C + 0.005*RO2XC + 0.005*zRNO3 + 0.303*CO + 0.088*CO2 + 0.5*HCHO +0.011*xCCHO + 0.5*RCHO + 0.044*xRCHO + 0.003*xACET + 0.009*MEK +0.185*FACD + 0.159*RCOOH + 0.268*PRD2 + 0.011*yROOH + 0.052*yR6OOH +0.11*XC ';
k(:,i) =  3.19e-15.*exp(-1701./ T);
Gstr{i,1} = 'OLE1'; Gstr{i,2} = 'O3'; 
fOLE1(i)=fOLE1(i)-1; fO3(i)=fO3(i)-1; fHO2(i)=fHO2(i)+0.095; fxHO2(i)=fxHO2(i)+0.057; 
fOH(i)=fOH(i)+0.128; fRO2C(i)=fRO2C(i)+0.09; fRO2XC(i)=fRO2XC(i)+0.005; 
fzRNO3(i)=fzRNO3(i)+0.005; fCO(i)=fCO(i)+0.303; fCO2(i)=fCO2(i)+0.088; fHCHO(i)=fHCHO(i)+0.5; 
fxCCHO(i)=fxCCHO(i)+0.011; fRCHO(i)=fRCHO(i)+0.5; 
fxRCHO(i)=fxRCHO(i)+0.044; fxACET(i)=fxACET(i)+0.003; fMEK(i)=fMEK(i)+0.009; 
fFACD(i)=fFACD(i)+0.185; fRCOOH(i)=fRCOOH(i)+0.159; 
fPRD2(i)=fPRD2(i)+0.268; fyROOH(i)=fyROOH(i)+0.011; fyR6OOH(i)=fyR6OOH(i)+0.052; fXC(i)=fXC(i)+0.11; 

% BL08
i=i+1;
Rnames{i} = ' OLE1 + NO3 = 0.772*xHO2 + 1.463*RO2C + 0.228*RO2XC + 0.228*zRNO3 +0.013*xCCHO + 0.003*xRCHO + 0.034*xACET + 0.774*xRNO3 +0.169*yROOH + 0.831*yR6OOH + 0.226*XN - 1.149*XC';
k(:,i) =  5.37e-13.*exp(-1047./ T);
Gstr{i,1} = 'OLE1'; Gstr{i,2} = 'NO3'; 
fOLE1(i)=fOLE1(i)-1; fNO3(i)=fNO3(i)-1; fxHO2(i)=fxHO2(i)+0.772; fRO2C(i)=fRO2C(i)+1.463; 
fRO2XC(i)=fRO2XC(i)+0.228; fzRNO3(i)=fzRNO3(i)+0.228; fxCCHO(i)=fxCCHO(i)+0.013; 
fxRCHO(i)=fxRCHO(i)+0.003; fxACET(i)=fxACET(i)+0.034; fxRNO3(i)=fxRNO3(i)+0.774; 
fyROOH(i)=fyROOH(i)+0.169; fyR6OOH(i)=fyR6OOH(i)+0.831; fXN(i)=fXN(i)+0.226; fXC(i)=fXC(i)-1.149; 

%BL09
i=i+1;
Rnames{i} = ' OLE1 + O3P = 0.45*RCHO + 0.39*MEK + 0.16*PRD2 + 1.13*XC';
k(:,i) =  1.61e-11.*exp(-326./ T);
Gstr{i,1} = 'OLE1'; Gstr{i,2} = 'O3P'; 
fOLE1(i)=fOLE1(i)-1; fO3P(i)=fO3P(i)-1; fRCHO(i)=fRCHO(i)+0.45; fMEK(i)=fMEK(i)+0.39; 
fPRD2(i)=fPRD2(i)+0.16; fXC(i)=fXC(i)+1.13; 

% BL10
i=i+1;
Rnames{i} = ' OLE2 + OH = 0.912*xHO2 + 0.953*RO2C + 0.088*RO2XC + 0.088*zRNO3 + 0.179*xHCHO + 0.835*xCCHO + 0.51*xRCHO + 0.144*xACET + 0.08*xMEK +0.002*xMVK + 0.012*xIPRD + 0.023*xPROD2 + 0.319*yROOH + 0.681*yR6OOH +0.135*XC  ';
k(:,i) =  1.26e-11.*exp(488./ T);
Gstr{i,1} = 'OLE2'; Gstr{i,2} = 'OH'; 
fOLE2(i)=fOLE2(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+0.912; fRO2C(i)=fRO2C(i)+0.953; 
fRO2XC(i)=fRO2XC(i)+0.088; fzRNO3(i)=fzRNO3(i)+0.088; fxHCHO(i)=fxHCHO(i)+0.179; fxCCHO(i)=fxCCHO(i)+0.835;
fxRCHO(i)=fxRCHO(i)+0.51; fxACET(i)=fxACET(i)+0.144; fxMEK(i)=fxMEK(i)+0.08;
fxMVK(i)=fxMVK(i)+0.002; fxIPRD(i)=fxIPRD(i)+0.012; fxPROD2(i)=fxPROD2(i)+0.023; fyROOH(i)=fyROOH(i)+0.319; 
fyR6OOH(i)=fyR6OOH(i)+0.681; fXC(i)=fXC(i)+0.135; 

% BL11
i=i+1;
Rnames{i} = ' OLE2 + O3 = 0.094*HO2 + 0.041*xHO2 + 0.443*OH + 0.307*MEO2 + 0.156*xMECO3 + 0.008*xRCO3 + 0.212*RO2C + 0.003*RO2XC + 0.003*zRNO3 +0.299*CO + 0.161*CO2 + 0.131*HCHO + 0.114*xHCHO + 0.453*CCHO + 0.071*xCCHO + 0.333*RCHO + 0.019*xRCHO + 0.051*ACET + 0.033*MEK +0.001*xMEK + 0.024*FACD + 0.065*CCOOH + 0.235*RCOOH + 0.037*PRD2 +0.073*yROOH + 0.136*yR6OOH + 0.16*XC';
k(:,i) =  8.59e-15.*exp(-1255./ T);
Gstr{i,1} = 'OLE2'; Gstr{i,2} = 'O3'; 
fOLE2(i)=fOLE2(i)-1; fO3(i)=fO3(i)-1; fHO2(i)=fHO2(i)+0.094; fxHO2(i)=fxHO2(i)+0.041; fOH(i)=fOH(i)+0.443;
fMEO2(i)=fMEO2(i)+0.307; fxMECO3(i)=fxMECO3(i)+0.156; fxRCO3(i)=fxRCO3(i)+0.008; fRO2C(i)=fRO2C(i)+0.212; 
fRO2XC(i)=fRO2XC(i)+0.003; fzRNO3(i)=fzRNO3(i)+0.003; fCO(i)=fCO(i)+0.299; fCO2(i)=fCO2(i)+0.161; 
fHCHO(i)=fHCHO(i)+0.131; fxHCHO(i)=fxHCHO(i)+0.114; fCCHO(i)=fCCHO(i)+0.453; fxCCHO(i)=fxCCHO(i)+0.071; 
fRCHO(i)=fRCHO(i)+0.333; fxRCHO(i)=fxRCHO(i)+0.019; fACET(i)=fACET(i)+0.051; fMEK(i)=fMEK(i)+0.033; 
fxMEK(i)=fxMEK(i)+0.001; fFACD(i)=fFACD(i)+0.024; fCCOOH(i)=fCCOOH(i)+0.065; fRCOOH(i)=fRCOOH(i)+0.235; 
fPRD2(i)=fPRD2(i)+0.037; fyROOH(i)=fyROOH(i)+0.073; 
fyR6OOH(i)=fyR6OOH(i)+0.136; fXC(i)=fXC(i)+0.16;

%BL12
i=i+1;
Rnames{i} = ' OLE2 + NO3 = 0.4*xHO2 + 0.426*xNO2 + 0.035*xMEO2 + 1.193*RO2C +0.14*RO2XC + 0.14*zRNO3 + 0.072*xHCHO + 0.579*xCCHO + 0.163*xRCHO + 0.116*xACET + 0.002*xMEK + 0.32*xRNO3 + 0.319*yROOH + 0.681*yR6OOH + 0.254*XN + 0.13*XC ';
k(:,i) =  2.31e-13.*exp(382./ T);
Gstr{i,1} = 'OLE2'; Gstr{i,2} = 'NO3'; 
fOLE2(i)=fOLE2(i)-1; fNO3(i)=fNO3(i)-1; fxHO2(i)=fxHO2(i)+0.4; fxNO2(i)=fxNO2(i)+0.426; 
fxMEO2(i)=fxMEO2(i)+0.035; fRO2C(i)=fRO2C(i)+1.193; fRO2XC(i)=fRO2XC(i)+0.14; fzRNO3(i)=fzRNO3(i)+0.14; 
fxHCHO(i)=fxHCHO(i)+0.072; fxCCHO(i)=fxCCHO(i)+0.579; fxRCHO(i)=fxRCHO(i)+0.163; fxACET(i)=fxACET(i)+0.116;
fxMEK(i)=fxMEK(i)+0.002; fxRNO3(i)=fxRNO3(i)+0.32;
fyROOH(i)=fyROOH(i)+0.319; fyR6OOH(i)=fyR6OOH(i)+0.681; fXN(i)=fXN(i)+0.254; fXC(i)=fXC(i)+0.13;

%BL13
i=i+1;
Rnames{i} = ' OLE2 + O3P = 0.079*RCHO + 0.751*MEK + 0.17*PRD2 + 0.739*XC';
k(:,i) =  1.43e-11.*exp(111./ T);
Gstr{i,1} = 'OLE2'; Gstr{i,2} = 'O3P'; 
fOLE2(i)=fOLE2(i)-1; fO3P(i)=fO3P(i)-1; fRCHO(i)=fRCHO(i)+0.079; 
fMEK(i)=fMEK(i)+0.751; fPRD2(i)=fPRD2(i)+0.17; fXC(i)=fXC(i)+0.739; 

%BL14
i=i+1;
Rnames{i} = ' ARO1 + OH = 0.123*HO2 + 0.566*xHO2 + 0.202*OH + 0.566*RO2C + 0.11*RO2XC +0.11*zRNO3 + 0.158*xGLY + 0.1*xMGLY + 0.123*CRES + 0.072*xAFG1 +0.185*xAFG2 + 0.202*AFG3 + 0.309*xPROD2 + 0.369*yR6OOH + TOLRO2 +0.31*XC';
k(:,i) =  7.84e-12;
Gstr{i,1} = 'ARO1'; Gstr{i,2} = 'OH'; 
fARO1(i)=fARO1(i)-1; fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+0.123; fxHO2(i)=fxHO2(i)+0.566; fOH(i)=fOH(i)+0.202; 
fRO2C(i)=fRO2C(i)+0.566; fRO2XC(i)=fRO2XC(i)+0.11; fzRNO3(i)=fzRNO3(i)+0.11; fxGLY(i)=fxGLY(i)+0.158; 
fxMGLY(i)=fxMGLY(i)+0.1; fCRES(i)=fCRES(i)+0.123; fxAFG1(i)=fxAFG1(i)+0.072; 
fxAFG2(i)=fxAFG2(i)+0.185; fAFG3(i)=fAFG3(i)+0.202; fxPROD2(i)=fxPROD2(i)+0.309; fTOLRO2(i)=fTOLRO2(i)+1;
fyR6OOH(i)=fyR6OOH(i)+0.369; fXC(i)=fXC(i)+0.31; 

%BL15a ARO2 changed to ARO2MN
i=i+1;
Rnames{i} = ' ARO2MN + OH = 0.077*HO2 + 0.617*xHO2 + 0.178*OH + 0.617*RO2C +0.128*RO2XC + 0.128*zRNO3 + 0.088*xGLY + 0.312*xMGLY + 0.134*xBACL +0.077*CRES + 0.026*xBALD + 0.221*xAFG1 + 0.247*xAFG2 + 0.178*AFG3 +0.068*xAFG3 + 0.057*xPROD2 + 0.101*yR6OOH + XYLRO2 +1.459*XC ';
k(:,i) =  3.09e-11;
Gstr{i,1} = 'ARO2MN'; Gstr{i,2} = 'OH'; 
fARO2MN(i)=fARO2MN(i)-1; fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+0.077; fxHO2(i)=fxHO2(i)+0.617; 
fOH(i)=fOH(i)+0.178; fRO2C(i)=fRO2C(i)+0.617; fRO2XC(i)=fRO2XC(i)+0.128; fzRNO3(i)=fzRNO3(i)+0.128;
fxGLY(i)=fxGLY(i)+0.088; fxMGLY(i)=fxMGLY(i)+0.312; fxBACL(i)=fxBACL(i)+0.134; fCRES(i)=fCRES(i)+0.077;
fxBALD(i)=fxBALD(i)+0.026; fxAFG1(i)=fxAFG1(i)+0.221; fxAFG2(i)=fxAFG2(i)+0.247; fAFG3(i)=fAFG3(i)+0.178; 
fxAFG3(i)=fxAFG3(i)+0.068; fxPROD2(i)=fxPROD2(i)+0.057; fyR6OOH(i)=fyR6OOH(i)+0.101; fXYLRO2(i)=fXYLRO2(i)+1; 
fXC(i)=fXC(i)+1.459;

%BL15b new added
i=i+1;
Rnames{i} = ' NAPHTHAL + OH = 0.077*HO2 + 0.617*xHO2 + 0.178*OH + 0.617*RO2C +0.128*RO2XC + 0.128*zRNO3 + 0.088*xGLY + 0.312*xMGLY + 0.134*xBACL +0.077*CRES + 0.026*xBALD + 0.221*xAFG1 + 0.247*xAFG2 + 0.178*AFG3 + 0.068*xAFG3 + 0.057*xPROD2 + 0.101*yR6OOH + PAHRO2 +1.459*XC';
k(:,i) =  3.09e-11;
Gstr{i,1} = 'NAPHTHAL'; Gstr{i,2} = 'OH'; 
fNAPHTHAL(i)=fNAPHTHAL(i)-1;fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+0.077; fxHO2(i)=fxHO2(i)+0.617; 
fOH(i)=fOH(i)+0.178; fRO2C(i)=fRO2C(i)+0.617; fRO2XC(i)=fRO2XC(i)+0.128; fzRNO3(i)=fzRNO3(i)+0.128;
fxGLY(i)=fxGLY(i)+0.088; fxMGLY(i)=fxMGLY(i)+0.312; fxBACL(i)=fxBACL(i)+0.134; fCRES(i)=fCRES(i)+0.077;
fxBALD(i)=fxBALD(i)+0.026; fxAFG1(i)=fxAFG1(i)+0.221; fxAFG2(i)=fxAFG2(i)+0.247; fAFG3(i)=fAFG3(i)+0.178; 
fxAFG3(i)=fxAFG3(i)+0.068; fxPROD2(i)=fxPROD2(i)+0.057; fyR6OOH(i)=fyR6OOH(i)+0.101; fPAHRO2(i)=fPAHRO2(i)+1; 
fXC(i)=fXC(i)+1.459;

%BL16
i=i+1;
Rnames{i} = ' TERP + OH = 0.734*xHO2 + 0.064*xRCO3 + 1.211*RO2C + 0.201*RO2XC + 0.201*zMTNO3 + 0.001*xCO + 0.411*xHCHO + 0.385*xRCHO + 0.037*xACET + 0.007*xMEK + 0.003*xMGLY + 0.009*xBACL + 0.003*xMVK + 0.002*xIPRD + 0.409*xPROD2 + yR6OOH + TRPRXN + 4.375*XC';
k(:,i) =  2.27e-11.*exp(435./ T);
Gstr{i,1} = 'TERP'; Gstr{i,2} = 'OH'; 
fTERP(i)=fTERP(i)-1; fOH(i)=fOH(i)-1; fxHO2(i)=fxHO2(i)+0.734; fxRCO3(i)=fxRCO3(i)+0.064;
fRO2C(i)=fRO2C(i)+1.211; fRO2XC(i)=fRO2XC(i)+0.201; fzMTNO3(i)=fzMTNO3(i)+0.201; fxCO(i)=fxCO(i)+0.001; 
fxRCHO(i)=fxRCHO(i)+0.385; fxACET(i)=fxACET(i)+0.037; fxHCHO(i)=fxHCHO(i)+0.411;
fxMEK(i)=fxMEK(i)+0.007; fxMGLY(i)=fxMGLY(i)+0.003; fxBACL(i)=fxBACL(i)+0.009; 
fxMVK(i)=fxMVK(i)+0.003; fxIPRD(i)=fxIPRD(i)+0.002; fxPROD2(i)=fxPROD2(i)+0.409; 
fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+4.375;fTRPRXN(i)=fTRPRXN(i)+1;

%BL17
i=i+1;
Rnames{i} = ' TERP + O3 = 0.078*HO2 + 0.046*xHO2 + 0.499*OH + 0.202*xMECO3 +0.059*xRCO3 + 0.49*RO2C + 0.121*RO2XC + 0.121*zMTNO3 + 0.249*CO +0.063*CO2 + 0.127*HCHO + 0.033*xHCHO + 0.208*xRCHO + 0.057*xACET + 0.002*MEK + 0.172*FACD + 0.068*RCOOH + 0.003*xMGLY + 0.039*xBACL + 0.002*xMACR + 0.001*xIPRD + 0.502*PRD2 + 0.428*yR6OOH + TRPRXN + 3.852*XC';
k(:,i) =  8.28e-16.*exp(-785./ T);
Gstr{i,1} = 'TERP'; Gstr{i,2} = 'O3'; 
fTERP(i)=fTERP(i)-1; fO3(i)=fO3(i)-1; fHO2(i)=fHO2(i)+0.078; fxHO2(i)=fxHO2(i)+0.046; fOH(i)=fOH(i)+0.499;
fxMECO3(i)=fxMECO3(i)+0.202; fxRCO3(i)=fxRCO3(i)+0.059; fRO2C(i)=fRO2C(i)+0.49; fRO2XC(i)=fRO2XC(i)+0.121; 
fzMTNO3(i)=fzMTNO3(i)+0.121; fCO(i)=fCO(i)+0.249; fCO2(i)=fCO2(i)+0.063; 
fHCHO(i)=fHCHO(i)+0.127; fxHCHO(i)=fxHCHO(i)+0.033; fxRCHO(i)=fxRCHO(i)+0.208; fxACET(i)=fxACET(i)+0.057;
fMEK(i)=fMEK(i)+0.002; fFACD(i)=fFACD(i)+0.172; fRCOOH(i)=fRCOOH(i)+0.068;
fxMGLY(i)=fxMGLY(i)+0.003; fxBACL(i)=fxBACL(i)+0.039; fxMACR(i)=fxMACR(i)+0.002; fxIPRD(i)=fxIPRD(i)+0.001; 
fPRD2(i)=fPRD2(i)+0.502; fyR6OOH(i)=fyR6OOH(i)+0.428; fXC(i)=fXC(i)+3.852;fTRPRXN(i)=fTRPRXN(i)+1;

%BL18
i=i+1;
Rnames{i} = ' TERP + NO3 = TERPNRO2';
k(:,i) =  1.33e-12.*exp(490./ T);
Gstr{i,1} = 'TERP'; Gstr{i,2} = 'NO3'; 
fTERP(i)=fTERP(i)-1; fNO3(i)=fNO3(i)-1; fTERPNRO2(i)=fTERPNRO2(i)+1;  

%BL18a
i=i+1;
Rnames{i} = ' TERPNRO2 + NO = 0.827*NO2 + 0.688*MTNO3 + 0.424*RO2C + 0.227*HO2 +0.026*RCO3 + 0.012*CO + 0.023*HCHO + 0.002*HOCCHO + 0.403*RCHO +  0.239*ACET + 0.005*MACR + 0.001*MVK + 0.004*IPRD + 0.485*XN + 1.035*XC ';
k(:,i) = 2.60e-12.*exp(380./ T);
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'NO'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+0.827;fMTNO3(i)=fMTNO3(i)+0.688;  
fRO2C(i)=fRO2C(i)+0.424;fHO2(i)=fHO2(i)+0.227;fRCO3(i)=fRCO3(i)+0.026;fCO(i)=fCO(i)+0.012;
fHCHO(i)=fHCHO(i)+0.023;fHOCCHO(i)=fHOCCHO(i)+0.002;fRCHO(i)=fRCHO(i)+0.403;fACET(i)=fACET(i)+0.239;
fMACR(i)=fMACR(i)+0.005;fMVK(i)=fMVK(i)+0.001;fIPRD(i)=fIPRD(i)+0.004;fXN(i)=fXN(i)+0.485;
fXC(i)=fXC(i)+1.035;

%BL18b
i=i+1;
Rnames{i} = ' TERPNRO2 + HO2 = 1.0*MTNO3';
k(:,i) =  2.65e-13.*exp(1300./ T);
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'HO2'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fHO2(i)=fHO2(i)-1; fMTNO3(i)=fMTNO3(i)+1;  

%BL18c
i=i+1;
Rnames{i} = ' TERPNRO2 + NO3 = 1.531*NO2 + 0.422*MTNO3 + 0.786*RO2C + 0.420*HO2 +  0.048*RCO3 + 0.022*CO + 0.043*HCHO + 0.004*HOCCHO + 0.746*RCHO +  0.443*ACET + 0.009*MACR + 0.002*MVK + 0.007*IPRD + 0.047*XN +  1.917*XC ';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'NO3'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1.531;fMTNO3(i)=fMTNO3(i)+0.422;  
fRO2C(i)=fRO2C(i)+0.786;fHO2(i)=fHO2(i)+0.42;fRCO3(i)=fRCO3(i)+0.048;fCO(i)=fCO(i)+0.022;
fHCHO(i)=fHCHO(i)+0.043;fHOCCHO(i)=fHOCCHO(i)+0.004;fRCHO(i)=fRCHO(i)+0.746;fACET(i)=fACET(i)+0.443;
fMACR(i)=fMACR(i)+0.009;fMVK(i)=fMVK(i)+0.002;fIPRD(i)=fIPRD(i)+0.007;fXN(i)=fXN(i)+0.047;
fXC(i)=fXC(i)+1.917;

%BL18d
i=i+1;
Rnames{i} = 'TERPNRO2 + MEO2 = 0.266*NO2 + 0.711*MTNO3 + 0.393*RO2C + 0.710*HO2 + 0.024*RCO3 + 0.011*CO + 0.772*HCHO + 0.002*HOCCHO + 0.373*RCHO +  0.222*ACET + 0.005*MACR + 0.001*MVK + 0.004*IPRD + 0.024*XN +  0.959*XC + 0.250*MEOH  ';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'MEO2'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fMEO2(i)=fMEO2(i)-1; fNO2(i)=fNO2(i)+0.266;fMTNO3(i)=fMTNO3(i)+0.711;  
fRO2C(i)=fRO2C(i)+0.393;fHO2(i)=fHO2(i)+0.71;fRCO3(i)=fRCO3(i)+0.024;fCO(i)=fCO(i)+0.011;
fHCHO(i)=fHCHO(i)+0.772;fHOCCHO(i)=fHOCCHO(i)+0.002;fRCHO(i)=fRCHO(i)+0.373;fACET(i)=fACET(i)+0.222;
fMACR(i)=fMACR(i)+0.005;fMVK(i)=fMVK(i)+0.001;fIPRD(i)=fIPRD(i)+0.004;fXN(i)=fXN(i)+0.024;
fXC(i)=fXC(i)+0.959;fMEOH(i)=fMEOH(i)+0.25;

%BL18e
i=i+1;
Rnames{i} = 'TERPNRO2 + RO2C = 0.266*NO2 + 0.711*MTNO3 + 0.393*RO2C + 0.210*HO2 + 0.024*RCO3 + 0.011*CO + 0.022*HCHO + 0.002*HOCCHO + 0.373*RCHO +  0.222*ACET + 0.005*MACR + 0.001*MVK + 0.004*IPRD + 0.024*XN +  0.959*XC ';
k(:,i) = 3.50e-14;
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'RO2C'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fRO2C(i)=fRO2C(i)-1; fNO2(i)=fNO2(i)+0.266;fMTNO3(i)=fMTNO3(i)+0.711;  
fRO2C(i)=fRO2C(i)+0.393;fHO2(i)=fHO2(i)+0.21;fRCO3(i)=fRCO3(i)+0.024;fCO(i)=fCO(i)+0.011;
fHCHO(i)=fHCHO(i)+0.022;fHOCCHO(i)=fHOCCHO(i)+0.002;fRCHO(i)=fRCHO(i)+0.373;fACET(i)=fACET(i)+0.222;
fMACR(i)=fMACR(i)+0.005;fMVK(i)=fMVK(i)+0.001;fIPRD(i)=fIPRD(i)+0.004;fXN(i)=fXN(i)+0.024;
fXC(i)=fXC(i)+0.959;

%BL18f
i=i+1;
Rnames{i} = 'TERPNRO2 + RO2XC = 0.266*NO2 + 0.711*MTNO3 + 0.393*RO2C + 0.210*HO2 + 0.024*RCO3 + 0.011*CO + 0.022*HCHO + 0.002*HOCCHO + 0.373*RCHO +  0.222*ACET + 0.005*MACR + 0.001*MVK + 0.004*IPRD + 0.024*XN +  0.959*XC  ';
k(:,i) = 3.50e-14;
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'RO2XC'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fRO2XC(i)=fRO2XC(i)-1; fNO2(i)=fNO2(i)+0.266;fMTNO3(i)=fMTNO3(i)+0.711;  
fRO2C(i)=fRO2C(i)+0.393;fHO2(i)=fHO2(i)+0.21;fRCO3(i)=fRCO3(i)+0.024;fCO(i)=fCO(i)+0.011;
fHCHO(i)=fHCHO(i)+0.022;fHOCCHO(i)=fHOCCHO(i)+0.002;fRCHO(i)=fRCHO(i)+0.373;fACET(i)=fACET(i)+0.222;
fMACR(i)=fMACR(i)+0.005;fMVK(i)=fMVK(i)+0.001;fIPRD(i)=fIPRD(i)+0.004;fXN(i)=fXN(i)+0.024;
fXC(i)=fXC(i)+0.959;

%BL18g
i=i+1;
Rnames{i} = 'TERPNRO2 + MECO3 = 0.531*NO2 + 0.422*MTNO3 + 0.786*RO2C + 0.420*HO2 + 0.048*RCO3 + 0.022*CO + 0.043*HCHO + 0.004*HOCCHO + 0.746*RCHO + 0.443*ACET + 0.009*MACR + 0.002*MVK + 0.007*IPRD + 0.047*XN + 1.917*XC + MEO2 + CO2  ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'MECO3'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fMECO3(i)=fMECO3(i)-1; fNO2(i)=fNO2(i)+0.531;fMTNO3(i)=fMTNO3(i)+0.422;  
fRO2C(i)=fRO2C(i)+0.786;fHO2(i)=fHO2(i)+0.42;fRCO3(i)=fRCO3(i)+0.048;fCO(i)=fCO(i)+0.022;
fHCHO(i)=fHCHO(i)+0.043;fHOCCHO(i)=fHOCCHO(i)+0.004;fRCHO(i)=fRCHO(i)+0.746;fACET(i)=fACET(i)+0.443;
fMACR(i)=fMACR(i)+0.009;fMVK(i)=fMVK(i)+0.002;fIPRD(i)=fIPRD(i)+0.007;fXN(i)=fXN(i)+0.047;
fXC(i)=fXC(i)+1.917;fMEO2(i)=fMEO2(i)+1;fCO2(i)=fCO2(i)+1;

%BL18h
i=i+1;
Rnames{i} = 'TERPNRO2 + RCO3 = 0.531*NO2 + 0.422*MTNO3 + 1.786*RO2C + 0.420*HO2 + 0.048*RCO3 + 0.022*CO + 0.043*HCHO + 0.004*HOCCHO + 0.746*RCHO +  0.443*ACET + 0.009*MACR + 0.002*MVK + 0.007*IPRD + 0.047*XN +  1.917*XC + CO2 + xHO2 + xCCHO + yROOH  ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'RCO3'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fRCO3(i)=fRCO3(i)-1; fNO2(i)=fNO2(i)+0.531;fMTNO3(i)=fMTNO3(i)+0.422;  
fRO2C(i)=fRO2C(i)+1.786;fHO2(i)=fHO2(i)+0.42;fRCO3(i)=fRCO3(i)+0.048;fCO(i)=fCO(i)+0.022;
fHCHO(i)=fHCHO(i)+0.043;fHOCCHO(i)=fHOCCHO(i)+0.004;fRCHO(i)=fRCHO(i)+0.746;fACET(i)=fACET(i)+0.443;
fMACR(i)=fMACR(i)+0.009;fMVK(i)=fMVK(i)+0.002;fIPRD(i)=fIPRD(i)+0.007;fXN(i)=fXN(i)+0.047;
fXC(i)=fXC(i)+1.917;fxHO2(i)=fxHO2(i)+1;fCO2(i)=fCO2(i)+1;fxCCHO(i)=fxCCHO(i)+1;fyROOH(i)=fyROOH(i)+1;

%BL18i
i=i+1;
Rnames{i} = 'TERPNRO2 + BZCO3 = 0.531*NO2 + 0.422*MTNO3 + 1.786*RO2C + 0.420*HO2 + 0.048*RCO3 + 0.022*CO + 0.043*HCHO + 0.004*HOCCHO + 0.746*RCHO +  0.443*ACET + 0.009*MACR + 0.002*MVK + 0.007*IPRD + 0.047*XN +  1.917*XC + CO2 + BZO ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'BZCO3'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fBZCO3(i)=fBZCO3(i)-1; fNO2(i)=fNO2(i)+0.531;fMTNO3(i)=fMTNO3(i)+0.422;  
fRO2C(i)=fRO2C(i)+1.786;fHO2(i)=fHO2(i)+0.42;fRCO3(i)=fRCO3(i)+0.048;fCO(i)=fCO(i)+0.022;
fHCHO(i)=fHCHO(i)+0.043;fHOCCHO(i)=fHOCCHO(i)+0.004;fRCHO(i)=fRCHO(i)+0.746;fACET(i)=fACET(i)+0.443;
fMACR(i)=fMACR(i)+0.009;fMVK(i)=fMVK(i)+0.002;fIPRD(i)=fIPRD(i)+0.007;fXN(i)=fXN(i)+0.047;
fXC(i)=fXC(i)+1.917;fCO2(i)=fCO2(i)+1;fBZO(i)=fBZO(i)+1;

%BL19j
i=i+1;
Rnames{i} = 'TERPNRO2 + MACO3 = 1.0*CO2 + 1.0*HCHO + 1.0*MECO3 + 0.786*RO2C + 0.420*HO2 + 0.531*NO2 + 0.048*RCO3 + 0.022*CO + 0.043*HCHO + 0.004*HOCCHO + 0.746*RCHO + 0.443*ACET + 0.009*MACR +  0.002*MVK + 0.007*IPRD + 0.422*MTNO3 + 0.047*XN + 1.917*XC  ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'MACO3'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fMACO3(i)=fMACO3(i)-1; fNO2(i)=fNO2(i)+0.531;fMTNO3(i)=fMTNO3(i)+0.422;  
fRO2C(i)=fRO2C(i)+0.786;fHO2(i)=fHO2(i)+0.42;fRCO3(i)=fRCO3(i)+0.048;fCO(i)=fCO(i)+0.022;
fHCHO(i)=fHCHO(i)+1;fHOCCHO(i)=fHOCCHO(i)+0.004;fRCHO(i)=fRCHO(i)+0.746;fACET(i)=fACET(i)+0.443;
fMACR(i)=fMACR(i)+0.009;fMVK(i)=fMVK(i)+0.002;fIPRD(i)=fIPRD(i)+0.007;fXN(i)=fXN(i)+0.047;
fXC(i)=fXC(i)+1.917;fCO2(i)=fCO2(i)+1;fMECO3(i)=fMECO3(i)+1;

%BL19k
i=i+1;
Rnames{i} = 'TERPNRO2 + IMACO3 = 1.0*CO2 + 1.0*HCHO + 1.0*MECO3 + 0.786*RO2C + 0.420*HO2 + 0.531*NO2 + 0.048*RCO3 + 0.022*CO + 0.043*HCHO + 0.004*HOCCHO + 0.746*RCHO + 0.443*ACET + 0.009*MACR + 0.002*MVK + 0.007*IPRD + 0.422*MTNO3 + 0.047*XN +  1.917*XC  ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'TERPNRO2'; Gstr{i,2} = 'IMACO3'; 
fTERPNRO2(i)=fTERPNRO2(i)-1; fIMACO3(i)=fIMACO3(i)-1; fNO2(i)=fNO2(i)+0.531;fMTNO3(i)=fMTNO3(i)+0.422;  
fRO2C(i)=fRO2C(i)+0.786;fHO2(i)=fHO2(i)+0.42;fRCO3(i)=fRCO3(i)+0.048;fCO(i)=fCO(i)+0.022;
fHCHO(i)=fHCHO(i)+0.043;fHOCCHO(i)=fHOCCHO(i)+0.004;fRCHO(i)=fRCHO(i)+0.746;fACET(i)=fACET(i)+0.443;
fMACR(i)=fMACR(i)+0.009;fMVK(i)=fMVK(i)+0.002;fIPRD(i)=fIPRD(i)+0.007;fXN(i)=fXN(i)+0.047;
fXC(i)=fXC(i)+1.917;fCO2(i)=fCO2(i)+1;fMECO3(i)=fMECO3(i)+1;

%BL19
i=i+1;
Rnames{i} = ' TERP + O3P = 0.237*RCHO + 0.763*PRD2 + TRPRXN + 4.711*XC ';
k(:,i) =  4.021e-11;
Gstr{i,1} = 'TERP'; Gstr{i,2} = 'O3P'; 
fTERP(i)=fTERP(i)-1; fO3P(i)=fO3P(i)-1;fRCHO(i)=fRCHO(i)+0.237;fPRD2(i)=fPRD2(i)+0.763;fTRPRXN(i)=fTRPRXN(i)+1;
fXC(i)=fXC(i)+4.711;

%BT19
i=i+1;
Rnames{i} = ' SESQ + OH = 0.734*xHO2 + 0.064*xRCO3 + 1.211*RO2C + 0.201*RO2XC + 0.201*zRNO3 + 0.001*xCO + 0.411*xHCHO + 0.385*xRCHO + 0.037*xACET +  0.007*xMEK + 0.003*xMGLY + 0.009*xBACL + 0.003*xMVK + 0.002*xIPRD + 0.409*xPROD2 + yR6OOH + SESQRXN + 9.375*XC  ';
k(:,i) = 2.27e-11.*exp(435./ T);
Gstr{i,1} = 'SESQ'; Gstr{i,2} = 'OH'; 
fSESQ(i)=fSESQ(i)-1; fOH(i)=fOH(i)-1;fxHO2(i)=fxHO2(i)+0.734;fxRCO3(i)=fxRCO3(i)+0.064;fRO2C(i)=fRO2C(i)+1.211;
fRO2XC(i)=fRO2XC(i)+0.201;fzRNO3(i)=fzRNO3(i)+0.201;fxCO(i)=fxCO(i)+0.001;fxHCHO(i)=fxHCHO(i)+0.411;
fxRCHO(i)=fxRCHO(i)+0.385;fxACET(i)=fxACET(i)+0.037;fxMEK(i)=fxMEK(i)+0.007;fxMGLY(i)=fxMGLY(i)+0.003;
fxBACL(i)=fxBACL(i)+0.009;fxMVK(i)=fxMVK(i)+0.003;fxIPRD(i)=fxIPRD(i)+0.002;
fxPROD2(i)=fxPROD2(i)+0.409;fyR6OOH(i)=fyR6OOH(i)+1;fSESQRXN(i)=fSESQRXN(i)+1;fXC(i)=fXC(i)+9.375;

%BT20
i=i+1;
Rnames{i} = ' SESQ + O3 = 0.078*HO2 + 0.046*xHO2 + 0.499*OH + 0.202*xMECO3 + 0.059*xRCO3 + 0.49*RO2C + 0.121*RO2XC + 0.121*zRNO3 + 0.249*CO + 0.063*CO2 + 0.127*HCHO + 0.033*xHCHO + 0.208*xRCHO + 0.057*xACET + 0.002*MEK + 0.172*FACD + 0.068*RCOOH + 0.003*xMGLY + 0.039*xBACL + 0.002*xMACR + 0.001*xIPRD + 0.502*PRD2 + 0.428*yR6OOH + SESQRXN +  8.852*XC ';
k(:,i) =  8.28e-16.*exp(-785./ T);
Gstr{i,1} = 'SESQ'; Gstr{i,2} = 'O3'; 
fSESQ(i)=fSESQ(i)-1; fO3(i)=fO3(i)-1;fxHO2(i)=fxHO2(i)+0.046;fxRCO3(i)=fxRCO3(i)+0.059;fRO2C(i)=fRO2C(i)+0.49;
fRO2XC(i)=fRO2XC(i)+0.121;fzRNO3(i)=fzRNO3(i)+0.121;fCO(i)=fCO(i)+0.249;fxHCHO(i)=fxHCHO(i)+0.033;
fxRCHO(i)=fxRCHO(i)+0.208;fxACET(i)=fxACET(i)+0.057;fMEK(i)=fMEK(i)+0.002;fxMGLY(i)=fxMGLY(i)+0.003;
fxBACL(i)=fxBACL(i)+0.039;fxMACR(i)=fxMACR(i)+0.002;fxIPRD(i)=fxIPRD(i)+0.001;fHO2(i)=fHO2(i)+0.078;
fPRD2(i)=fPRD2(i)+0.502;fR6OOH(i)=fR6OOH(i)+0.428;fSESQRXN(i)=fSESQRXN(i)+1;fXC(i)=fXC(i)+8.852;
fOH(i)=fOH(i)+0.499;fxMECO3(i)=fxMECO3(i)+0.202;fCO2(i)=fCO2(i)+0.063;fHCHO(i)=fHCHO(i)+0.127;
fFACD(i)=fFACD(i)+0.172;fRCOOH(i)=fRCOOH(i)+0.068;

%BT21
i=i+1;
Rnames{i} = ' SESQ + NO3 = 0.227*xHO2 + 0.287*xNO2 + 0.026*xRCO3 + 1.786*RO2C + 0.46*RO2XC + 0.46*zRNO3 + 0.012*xCO + 0.023*xHCHO + 0.002*xCCHO + 0.403*xRCHO + 0.239*xACET + 0.005*xMACR + 0.001*xMVK + 0.004*xIPRD +  0.228*xRNO3 + yR6OOH + SESQRXN + 0.485*XN + 8.785*XC';
k(:,i) =  1.33e-12.*exp(490./ T);
Gstr{i,1} = 'SESQ'; Gstr{i,2} = 'NO3'; 
fSESQ(i)=fSESQ(i)-1; fNO3(i)=fNO3(i)-1;fxHO2(i)=fxHO2(i)+0.227;fxRCO3(i)=fxRCO3(i)+0.026;fRO2C(i)=fRO2C(i)+1.786;
fRO2XC(i)=fRO2XC(i)+0.46;fzRNO3(i)=fzRNO3(i)+0.46;fCO(i)=fCO(i)+0.012;fxHCHO(i)=fxHCHO(i)+0.023;
fxRCHO(i)=fxRCHO(i)+0.403;fxACET(i)=fxACET(i)+0.239;fxCCHO(i)=fxCCHO(i)+0.002;
fxMACR(i)=fxMACR(i)+0.005;fxIPRD(i)=fxIPRD(i)+0.004;fxMVK(i)=fxMVK(i)+0.001;
fxRNO3(i)=fxRNO3(i)+0.228;fR6OOH(i)=fR6OOH(i)+1;fSESQRXN(i)=fSESQRXN(i)+1;fXC(i)=fXC(i)+8.785;
fXN(i)=fXN(i)+0.485;fxNO2(i)=fxNO2(i)+0.287;

%BT22
i=i+1;
Rnames{i} = 'SESQ + O3P = 0.237*RCHO + 0.763*PRD2 + SESQRXN + 9.711*XC';
k(:,i) =  4.021e-11;
Gstr{i,1} = 'SESQ'; Gstr{i,2} = 'O3P'; 
fSESQ(i)=fSESQ(i)-1; fO3P(i)=fO3P(i)-1;fRCHO(i)=fRCHO(i)+0.237;fPRD2(i)=fPRD2(i)+0.763;
fSESQRXN(i)=fSESQRXN(i)+1;fXC(i)=fXC(i)+9.7111;

%CI01
i=i+1;
Rnames{i} = ' CL2 + hv = 2*CL ';
k(:,i) =  1.0.*JCL2;
Gstr{i,1} = 'CL2'; 
fCL2(i)=fCL2(i)-1; fCL(i)=fCL(i)+2; 

%CI02
i=i+1;
Rnames{i} = ' CL + NO + M = CLNO ';
k(:,i) =  7.60e-32.*(T./300).^-1.80.*M;
Gstr{i,1} = 'CL'; Gstr{i,2} = 'NO'; 
fCL(i)=fCL(i)-1; fNO(i)=fNO(i)-1; fCLNO(i)=fCLNO(i)+1; 

%CI03
i=i+1;
Rnames{i} = ' CLNO + hv = CL + NO ';
k(:,i) =  1.0.*JCLNO_06;
Gstr{i,1} = 'CLNO'; 
fCLNO(i)=fCLNO(i)-1; fCL(i)=fCL(i)+1; fNO(i)=fNO(i)+1; 

%CI04
i=i+1;
Rnames{i} = ' CL + NO2 = CLONO ';
k(:,i) = K_CL_NO2_CLONO;
Gstr{i,1} = 'CL'; Gstr{i,2} = 'NO2'; 
fCL(i)=fCL(i)-1; fNO2(i)=fNO2(i)-1; fCLONO(i)=fCLONO(i)+1; 

%CI05
i=i+1;
Rnames{i} = ' CL + NO2 = CLNO2 ';
k(:,i) = K_CL_NO2_CLNO2;
Gstr{i,1} = 'CL'; Gstr{i,2} = 'NO2'; 
fCL(i)=fCL(i)-1; fNO2(i)=fNO2(i)-1; fCLNO2(i)=fCLNO2(i)+1; 

%CI06
i=i+1;
Rnames{i} = ' CLONO + hv = CL + NO2 ';
k(:,i) =  1.0.*JCLONO;
Gstr{i,1} = 'CLONO'; 
fCLONO(i)=fCLONO(i)-1; fCL(i)=fCL(i)+1; fNO2(i)=fNO2(i)+1; 

%CI07
i=i+1;
Rnames{i} = ' CLNO2 + hv = CL + NO2 ';
k(:,i) =  1.0.*JCLNO2;
Gstr{i,1} = 'CLNO2'; 
fCLNO2(i)=fCLNO2(i)-1; fCL(i)=fCL(i)+1; fNO2(i)=fNO2(i)+1; 

%CI08
i=i+1;
Rnames{i} = ' CL + HO2 = HCL ';
k(:,i) =  3.44e-11.*(T./300).^-0.56;
Gstr{i,1} = 'CL'; Gstr{i,2} = 'HO2'; 
fCL(i)=fCL(i)-1; fHO2(i)=fHO2(i)-1; fHCL(i)=fHCL(i)+1; 

%CI09
i=i+1;
Rnames{i} = ' CL + HO2 = CLO + OH ';
k(:,i) =  9.41e-12.*(T./300).^2.10;
Gstr{i,1} = 'CL'; Gstr{i,2} = 'HO2'; 
fCL(i)=fCL(i)-1; fHO2(i)=fHO2(i)-1; fCLO(i)=fCLO(i)+1; fOH(i)=fOH(i)+1; 

%CI10
i=i+1;
Rnames{i} = ' CL + O3 = CLO ';
k(:,i) =  2.80e-11.*exp(-250./ T);
Gstr{i,1} = 'CL'; Gstr{i,2} = 'O3'; 
fCL(i)=fCL(i)-1; fO3(i)=fO3(i)-1; fCLO(i)=fCLO(i)+1; 

%CI11
i=i+1;
Rnames{i} = ' CL + NO3 = CLO + NO2 ';
k(:,i) =  2.40e-11;
Gstr{i,1} = 'CL'; Gstr{i,2} = 'NO3'; 
fCL(i)=fCL(i)-1; fNO3(i)=fNO3(i)-1; fCLO(i)=fCLO(i)+1; fNO2(i)=fNO2(i)+1; 

%CI12
i=i+1;
Rnames{i} = ' CLO + NO = CL + NO2 ';
k(:,i) =  6.20e-12.*exp(295./ T);
Gstr{i,1} = 'CLO'; Gstr{i,2} = 'NO'; 
fCLO(i)=fCLO(i)-1; fNO(i)=fNO(i)-1; fCL(i)=fCL(i)+1; fNO2(i)=fNO2(i)+1; 

%CI13
i=i+1;
Rnames{i} = ' CLO + NO2 = CLONO2 ';
k(:,i) = K_CLO_NO2;
Gstr{i,1} = 'CLO'; Gstr{i,2} = 'NO2'; 
fCLO(i)=fCLO(i)-1; fNO2(i)=fNO2(i)-1; fCLONO2(i)=fCLONO2(i)+1; 

%CI14
i=i+1;
Rnames{i} = ' CLONO2 + hv = CLO + NO2 ';
k(:,i) =  1.0.*JCLONO2_1;
Gstr{i,1} = 'CLONO2'; 
fCLONO2(i)=fCLONO2(i)-1; fCLO(i)=fCLO(i)+1; fNO2(i)=fNO2(i)+1; 

%CI15
i=i+1;
Rnames{i} = ' CLONO2 + hv = CL + NO3 ';
k(:,i) =  1.0.*JCLONO2_2;
Gstr{i,1} = 'CLONO2'; 
fCLONO2(i)=fCLONO2(i)-1; fCL(i)=fCL(i)+1; fNO3(i)=fNO3(i)+1; 

%CI16
i=i+1;
Rnames{i} = ' CLONO2 = CLO + NO2 ';
k(:,i) = K_CLONO2;
Gstr{i,1} = 'CLONO2'; 
fCLONO2(i)=fCLONO2(i)-1; fCLO(i)=fCLO(i)+1; fNO2(i)=fNO2(i)+1; 

%CI17
i=i+1;
Rnames{i} = ' CL + CLONO2 = CL2 + NO3 ';
k(:,i) =  6.20e-12.*exp(145./ T);
Gstr{i,1} = 'CL'; Gstr{i,2} = 'CLONO2'; 
fCL(i)=fCL(i)-1; fCLONO2(i)=fCLONO2(i)-1; fCL2(i)=fCL2(i)+1; fNO3(i)=fNO3(i)+1; 

%CI18
i=i+1;
Rnames{i} = ' CLO + HO2 = HOCL ';
k(:,i) =  2.20e-12.*exp(340./ T);
Gstr{i,1} = 'CLO'; Gstr{i,2} = 'HO2'; 
fCLO(i)=fCLO(i)-1; fHO2(i)=fHO2(i)-1; fHOCL(i)=fHOCL(i)+1; 

%CI19
i=i+1;
Rnames{i} = ' HOCL + hv = OH + CL ';
k(:,i) =  1.0.*JHOCL_06;
Gstr{i,1} = 'HOCL'; 
fHOCL(i)=fHOCL(i)-1; fOH(i)=fOH(i)+1; fCL(i)=fCL(i)+1; 

%CI20
i=i+1;
Rnames{i} = ' CLO + CLO = 0.29*CL2 + 1.42*CL ';
k(:,i) =  1.25e-11.*exp(-1960./ T);
Gstr{i,1} = 'CLO'; Gstr{i,2} = 'CLO'; 
fCLO(i)=fCLO(i)-1; fCLO(i)=fCLO(i)-1; fCL2(i)=fCL2(i)+0.29; fCL(i)=fCL(i)+1.42; 

%CI21
i=i+1;
Rnames{i} = ' OH + HCL = CL ';
k(:,i) =  1.70e-12.*exp(-230./ T);
Gstr{i,1} = 'OH'; Gstr{i,2} = 'HCL'; 
fOH(i)=fOH(i)-1; fHCL(i)=fHCL(i)-1; fCL(i)=fCL(i)+1; 

%CI22
i=i+1;
Rnames{i} = ' CL + H2 = HCL + HO2 ';
k(:,i) =  3.90e-11.*exp(-2310./ T);
Gstr{i,1} = 'CL'; Gstr{i,2} = 'H2'; 
fCL(i)=fCL(i)-1; fH2(i)=fH2(i)-1; fHCL(i)=fHCL(i)+1; fHO2(i)=fHO2(i)+1; 

%CP01
i=i+1;
Rnames{i} = ' HCHO + CL = HCL + HO2 + CO ';
k(:,i) =  8.10e-11.*exp(-30./ T);
Gstr{i,1} = 'HCHO'; Gstr{i,2} = 'CL'; 
fHCHO(i)=fHCHO(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fHO2(i)=fHO2(i)+1; fCO(i)=fCO(i)+1; 

%CP02
i=i+1;
Rnames{i} = ' CCHO + CL = HCL + MECO3 ';
k(:,i) =  8.00e-11;
Gstr{i,1} = 'CCHO'; Gstr{i,2} = 'CL'; 
fCCHO(i)=fCCHO(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fMECO3(i)=fMECO3(i)+1; 

%CP03
i=i+1;
Rnames{i} = ' MEOH + CL = HCL + HCHO + HO2 ';
k(:,i) =  5.50e-11;
Gstr{i,1} = 'MEOH'; Gstr{i,2} = 'CL'; 
fMEOH(i)=fMEOH(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; 

%CP04
i=i+1;
Rnames{i} = ' RCHO + CL = HCL + 0.9*RCO3 + 0.1*RO2C + 0.1*xCCHO + 0.1*xCO + 0.1*xHO2 +  0.1*yROOH ';
k(:,i) =  1.23e-10;
Gstr{i,1} = 'RCHO'; Gstr{i,2} = 'CL'; 
fRCHO(i)=fRCHO(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fRCO3(i)=fRCO3(i)+0.9; fRO2C(i)=fRO2C(i)+0.1; fxCCHO(i)=fxCCHO(i)+0.1; fxCO(i)=fxCO(i)+0.1; fxHO2(i)=fxHO2(i)+0.1; fyROOH(i)=fyROOH(i)+0.1; 

%CP05
i=i+1;
Rnames{i} = ' ACET + CL = HCL + RO2C + xHCHO + xMECO3 + yROOH ';
k(:,i) =  7.70e-11.*exp(-1000./ T);
Gstr{i,1} = 'ACET'; Gstr{i,2} = 'CL'; 
fACET(i)=fACET(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fRO2C(i)=fRO2C(i)+1; fxHCHO(i)=fxHCHO(i)+1; fxMECO3(i)=fxMECO3(i)+1; fyROOH(i)=fyROOH(i)+1; 

%CP06
i=i+1;
Rnames{i} = ' MEK + CL = HCL + 0.975*RO2C + 0.039*RO2XC + 0.039*zRNO3 + 0.84*xHO2 + 0.085*xMECO3 + 0.036*xRCO3 + 0.065*xHCHO + 0.07*xCCHO + 0.84*xRCHO +  yROOH + 0.763*XC ';
k(:,i) =  3.60e-11;
Gstr{i,1} = 'MEK'; Gstr{i,2} = 'CL'; 
fMEK(i)=fMEK(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fRO2C(i)=fRO2C(i)+0.975; fRO2XC(i)=fRO2XC(i)+0.039; fzRNO3(i)=fzRNO3(i)+0.039; fxHO2(i)=fxHO2(i)+0.84; fxMECO3(i)=fxMECO3(i)+0.085; fxRCO3(i)=fxRCO3(i)+0.036; fxHCHO(i)=fxHCHO(i)+0.065; fxCCHO(i)=fxCCHO(i)+0.07; fxRCHO(i)=fxRCHO(i)+0.84; fyROOH(i)=fyROOH(i)+1; fXC(i)=fXC(i)+0.763; 

%CP07
i=i+1;
Rnames{i} = ' RNO3 + CL = HCL + 0.038*NO2 + 0.055*HO2 + 1.282*RO2C + 0.202*RO2XC + 0.202*zRNO3 + 0.009*RCHO + 0.018*MEK + 0.012*PRD2 + 0.055*RNO3 + 0.159*xNO2 + 0.547*xHO2 + 0.045*xHCHO + 0.3*xCCHO + 0.02*xRCHO + 0.003*xACET + 0.041*xMEK + 0.046*xPROD2 + 0.547*xRNO3 + 0.908*yR6OOH +  0.201*XN + -0.149*XC ';
k(:,i) =  1.92e-10;
Gstr{i,1} = 'RNO3'; Gstr{i,2} = 'CL'; 
fRNO3(i)=fRNO3(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fNO2(i)=fNO2(i)+0.038; fHO2(i)=fHO2(i)+0.055; fRO2C(i)=fRO2C(i)+1.282; fRO2XC(i)=fRO2XC(i)+0.202; fzRNO3(i)=fzRNO3(i)+0.202; fRCHO(i)=fRCHO(i)+0.009; fMEK(i)=fMEK(i)+0.018; fPRD2(i)=fPRD2(i)+0.012; fRNO3(i)=fRNO3(i)+0.055; fxNO2(i)=fxNO2(i)+0.159; fxHO2(i)=fxHO2(i)+0.547; fxHCHO(i)=fxHCHO(i)+0.045; fxCCHO(i)=fxCCHO(i)+0.3; fxRCHO(i)=fxRCHO(i)+0.02; fxACET(i)=fxACET(i)+0.003; fxMEK(i)=fxMEK(i)+0.041; fxPROD2(i)=fxPROD2(i)+0.046; fxRNO3(i)=fxRNO3(i)+0.547; fyR6OOH(i)=fyR6OOH(i)+0.908; fXN(i)=fXN(i)+0.201; fXC(i)=fXC(i)+-0.149; 

%CP08
i=i+1;
Rnames{i} = ' PRD2 + CL = HCL + 0.314*HO2 + 0.68*RO2C + 0.116*RO2XC + 0.116*zRNO3 + 0.198*RCHO + 0.116*PRD2 + 0.541*xHO2 + 0.007*xMECO3 + 0.022*xRCO3 + 0.237*xHCHO + 0.109*xCCHO + 0.591*xRCHO + 0.051*xMEK + 0.04*xPROD2 +  0.686*yR6OOH + 1.262*XC ';
k(:,i) =  2.00e-10;
Gstr{i,1} = 'PRD2'; Gstr{i,2} = 'CL'; 
fPRD2(i)=fPRD2(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fHO2(i)=fHO2(i)+0.314; fRO2C(i)=fRO2C(i)+0.68; fRO2XC(i)=fRO2XC(i)+0.116; fzRNO3(i)=fzRNO3(i)+0.116; fRCHO(i)=fRCHO(i)+0.198; fPRD2(i)=fPRD2(i)+0.116; fxHO2(i)=fxHO2(i)+0.541; fxMECO3(i)=fxMECO3(i)+0.007; fxRCO3(i)=fxRCO3(i)+0.022; fxHCHO(i)=fxHCHO(i)+0.237; fxCCHO(i)=fxCCHO(i)+0.109; fxRCHO(i)=fxRCHO(i)+0.591; fxMEK(i)=fxMEK(i)+0.051; fxPROD2(i)=fxPROD2(i)+0.04; fyR6OOH(i)=fyR6OOH(i)+0.686; fXC(i)=fXC(i)+1.262; 

%CP09
i=i+1;
Rnames{i} = ' GLY + CL = HCL + 0.63*HO2 + 1.26*CO + 0.37*RCO3 + -0.37*XC';
k(:,i) =  8.10e-11.*exp(-30./ T);
Gstr{i,1} = 'GLY'; Gstr{i,2} = 'CL'; 
fGLY(i)=fGLY(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fHO2(i)=fHO2(i)+0.63; fCO(i)=fCO(i)+1.26; fRCO3(i)=fRCO3(i)+0.37; fXC(i)=fXC(i)+-0.37; 

%CP10
i=i+1;
Rnames{i} = ' MGLY + CL = HCL + CO + MECO3 ';
k(:,i) =  8.00e-11;
Gstr{i,1} = 'MGLY'; Gstr{i,2} = 'CL'; 
fMGLY(i)=fMGLY(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fCO(i)=fCO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%CP11
i=i+1;
Rnames{i} = ' CRES + CL = HCL + xHO2 + xBALD + yR6OOH ';
k(:,i) =  6.20e-11;
Gstr{i,1} = 'CRES'; Gstr{i,2} = 'CL'; 
fCRES(i)=fCRES(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fxHO2(i)=fxHO2(i)+1; fxBALD(i)=fxBALD(i)+1; fyR6OOH(i)=fyR6OOH(i)+1; 

%CP12
i=i+1;
Rnames{i} = ' BALD + CL = HCL + BZCO3 ';
k(:,i) =  8.00e-11;
Gstr{i,1} = 'BALD'; Gstr{i,2} = 'CL'; 
fBALD(i)=fBALD(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%CP13
i=i+1;
Rnames{i} = ' ROOH + CL = HCL + 0.414*OH + 0.588*RO2C + 0.414*RCHO + 0.104*xOH + 0.482*xHO2 + 0.106*xHCHO + 0.104*xCCHO + 0.197*xRCHO + 0.285*xMEK +  0.586*yROOH + -0.287*XC ';
k(:,i) =  1.66e-10;
Gstr{i,1} = 'ROOH'; Gstr{i,2} = 'CL'; 
fROOH(i)=fROOH(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fOH(i)=fOH(i)+0.414; fRO2C(i)=fRO2C(i)+0.588; 
fRCHO(i)=fRCHO(i)+0.414; fxOH(i)=fxOH(i)+0.104; fxHO2(i)=fxHO2(i)+0.482; fxHCHO(i)=fxHCHO(i)+0.106; 
fxCCHO(i)=fxCCHO(i)+0.104; fxRCHO(i)=fxRCHO(i)+0.197; fxMEK(i)=fxMEK(i)+0.285; fyROOH(i)=fyROOH(i)+0.586; fXC(i)=fXC(i)+-0.287; 

%CP14
i=i+1;
Rnames{i} = ' R6OOH + CL = HCL + 0.145*OH + 1.078*RO2C + 0.117*RO2XC + 0.117*zRNO3 + 0.145*PRD2 + 0.502*xOH + 0.237*xHO2 + 0.186*xCCHO + 0.676*xRCHO +  0.28*xPROD2 + 0.855*yR6OOH + 0.348*XC ';
k(:,i) =  3.00e-10;
Gstr{i,1} = 'R6OOH'; Gstr{i,2} = 'CL'; 
fR6OOH(i)=fR6OOH(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fOH(i)=fOH(i)+0.145; fRO2C(i)=fRO2C(i)+1.078; 
fRO2XC(i)=fRO2XC(i)+0.117; fzRNO3(i)=fzRNO3(i)+0.117; fPRD2(i)=fPRD2(i)+0.145; fxOH(i)=fxOH(i)+0.502; 
fxHO2(i)=fxHO2(i)+0.237; fxCCHO(i)=fxCCHO(i)+0.186; fxRCHO(i)=fxRCHO(i)+0.676; fxPROD2(i)=fxPROD2(i)+0.28; 
fyR6OOH(i)=fyR6OOH(i)+0.855; fXC(i)=fXC(i)+0.348; 

%CP15
i=i+1;
Rnames{i} = ' RAOOH + CL = 0.404*HCL + 0.139*OH + 0.148*HO2 + 0.589*RO2C + 0.124*RO2XC + 0.124*zRNO3 + 0.074*PRD2 + 0.147*MGLY + 0.139*IPRD + 0.565*xHO2 + 0.024*xOH + 0.448*xRCHO + 0.026*xGLY + 0.03*xMEK + 0.252*xMGLY + 0.073*xAFG1 + 0.073*xAFG2 + 0.713*yR6OOH + 2.674*XC';
k(:,i) =  4.29e-10;
Gstr{i,1} = 'RAOOH'; Gstr{i,2} = 'CL'; 
fRAOOH(i)=fRAOOH(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+0.404; fOH(i)=fOH(i)+0.139; fHO2(i)=fHO2(i)+0.148; 
fRO2C(i)=fRO2C(i)+0.589; fRO2XC(i)=fRO2XC(i)+0.124; fzRNO3(i)=fzRNO3(i)+0.124; fPRD2(i)=fPRD2(i)+0.074; 
fMGLY(i)=fMGLY(i)+0.147; fIPRD(i)=fIPRD(i)+0.139; fxHO2(i)=fxHO2(i)+0.565; fxOH(i)=fxOH(i)+0.024; 
fxRCHO(i)=fxRCHO(i)+0.448; fxGLY(i)=fxGLY(i)+0.026; fxMEK(i)=fxMEK(i)+0.03; fxMGLY(i)=fxMGLY(i)+0.252;
fxAFG1(i)=fxAFG1(i)+0.073; fxAFG2(i)=fxAFG2(i)+0.073; fyR6OOH(i)=fyR6OOH(i)+0.713; fXC(i)=fXC(i)+2.674; 

%TP01
i=i+1;
Rnames{i} = ' ACROLEIN + CL = 0.484*xHO2 + 0.274*xCL + 0.216*MACO3 + 1.032*RO2C + 0.026*RO2XC + 0.026*zRNO3 + 0.216*HCL + 0.484*xCO + 0.274*xHCHO + 0.274*xGLY + 0.484*xCLCCHO + 0.784*yROOH - 0.294*XC';
k(:,i) =  2.94e-10;
Gstr{i,1} = 'ACROLEIN'; Gstr{i,2} = 'CL'; 
fACROLEIN(i)=fACROLEIN(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.484; fxCL(i)=fxCL(i)+0.274;fMACO3(i)=fMACO3(i)+0.216;
fRO2C(i)=fRO2C(i)+1.032; fRO2XC(i)=fRO2XC(i)+0.026; fzRNO3(i)=fzRNO3(i)+0.026; 
fxGLY(i)=fxGLY(i)+0.274; fHCL(i)=fHCL(i)+0.216; fxCO(i)=fxCO(i)+0.484; fxHCHO(i)=fxHCHO(i)+0.274; 
fxCLCCHO(i)=fxCLCCHO(i)+0.484; fyROOH(i)=fyROOH(i)+0.784; fXC(i)=fXC(i)-0.294; 

%CP16
i=i+1;
Rnames{i} = ' MACR + CL = 0.25*HCL + 0.165*IMACO3 + 0.802*RO2C + 0.033*RO2XC + 0.033*zRNO3 + 0.802*xHO2 + 0.541*xCO + 0.082*xIPRD + 0.18*xCLCCHO + 0.541*xCLACET + 0.835*yROOH + 0.208*XC';
k(:,i) =  3.85e-10;
Gstr{i,1} = 'MACR'; Gstr{i,2} = 'CL'; 
fMACR(i)=fMACR(i)-1; fCL(i)=fCL(i)-1; fIMACO3(i)=fIMACO3(i)+0.165; 
fRO2C(i)=fRO2C(i)+0.802; fRO2XC(i)=fRO2XC(i)+0.033; fzRNO3(i)=fzRNO3(i)+0.033; 
fxHO2(i)=fxHO2(i)+0.802; fHCL(i)=fHCL(i)+0.25; fxCO(i)=fxCO(i)+0.541; fxIPRD(i)=fxIPRD(i)+0.082; 
fxCLCCHO(i)=fxCLCCHO(i)+0.18; fyROOH(i)=fyROOH(i)+0.835; fXC(i)=fXC(i)+0.208;fxCLACET(i)=fxCLACET(i)+0.541; 

%CP17
i=i+1;
Rnames{i} = ' MVK + CL = 1.283*RO2C + 0.053*RO2XC + 0.053*zRNO3 + 0.322*xHO2 +  0.625*xMECO3 + 0.947*xCLCCHO + yROOH + 0.538*XC ';
k(:,i) =  2.32e-10;
Gstr{i,1} = 'MVK'; Gstr{i,2} = 'CL'; 
fMVK(i)=fMVK(i)-1; fCL(i)=fCL(i)-1; fRO2C(i)=fRO2C(i)+1.283; fRO2XC(i)=fRO2XC(i)+0.053; 
fzRNO3(i)=fzRNO3(i)+0.053; fxHO2(i)=fxHO2(i)+0.322; fxMECO3(i)=fxMECO3(i)+0.625; 
fxCLCCHO(i)=fxCLCCHO(i)+0.947; fyROOH(i)=fyROOH(i)+1; fXC(i)=fXC(i)+0.538; 

%CP18
i=i+1;
Rnames{i} = ' IPRD + CL = 0.401*HCL + 0.084*HO2 + 0.154*MACO3 + 0.73*RO2C + 0.051*RO2XC + 0.051*zRNO3 + 0.042*AFG1 + 0.042*AFG2 + 0.712*xHO2 + 0.498*xCO + 0.195*xHCHO + 0.017*xMGLY + 0.009*xAFG1 + 0.009*xAFG2 + 0.115*xIPRD + 0.14*xCLCCHO + 0.42*xCLACET + 0.762*yR6OOH + 0.709*XC';
k(:,i) =  4.12e-10;
Gstr{i,1} = 'IPRD'; Gstr{i,2} = 'CL'; 
fIPRD(i)=fIPRD(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+0.401; fHO2(i)=fHO2(i)+0.084; fMACO3(i)=fMACO3(i)+0.154; 
fRO2C(i)=fRO2C(i)+0.73; fRO2XC(i)=fRO2XC(i)+0.051; fzRNO3(i)=fzRNO3(i)+0.051; fAFG1(i)=fAFG1(i)+0.042; 
fAFG2(i)=fAFG2(i)+0.042; fxHO2(i)=fxHO2(i)+0.712; fxCO(i)=fxCO(i)+0.498; fxHCHO(i)=fxHCHO(i)+0.195; 
fxMGLY(i)=fxMGLY(i)+0.017; fxAFG1(i)=fxAFG1(i)+0.009; fxAFG2(i)=fxAFG2(i)+0.009; fxIPRD(i)=fxIPRD(i)+0.115; 
fxCLCCHO(i)=fxCLCCHO(i)+0.14; fxCLACET(i)=fxCLACET(i)+0.42; fyR6OOH(i)=fyR6OOH(i)+0.762; fXC(i)=fXC(i)+0.709; 

%CP19
i=i+1;
Rnames{i} = ' CLCCHO + hv = HO2 + CO + RO2C + xCL + xHCHO + yROOH ';
k(:,i) =  1.0.*JCLCCHO;
Gstr{i,1} = 'CLCCHO'; 
fCLCCHO(i)=fCLCCHO(i)-1; fHO2(i)=fHO2(i)+1; fCO(i)=fCO(i)+1; fRO2C(i)=fRO2C(i)+1; fxCL(i)=fxCL(i)+1; 
fxHCHO(i)=fxHCHO(i)+1; fyROOH(i)=fyROOH(i)+1; 

%CP20
i=i+1;
Rnames{i} = ' CLCCHO + OH = RCO3 + -1*XC ';
k(:,i) =  3.10e-12;
Gstr{i,1} = 'CLCCHO'; Gstr{i,2} = 'OH'; 
fCLCCHO(i)=fCLCCHO(i)-1; fOH(i)=fOH(i)-1; fRCO3(i)=fRCO3(i)+1; fXC(i)=fXC(i)+-1; 

%CP21
i=i+1;
Rnames{i} = ' CLCCHO + CL = HCL + RCO3 + -1*XC ';
k(:,i) =  1.29e-11;
Gstr{i,1} = 'CLCCHO'; Gstr{i,2} = 'CL'; 
fCLCCHO(i)=fCLCCHO(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fRCO3(i)=fRCO3(i)+1; fXC(i)=fXC(i)+-1; 

%CP22
i=i+1;
Rnames{i} = ' CLACET + hv = MECO3 + RO2C + xCL + xHCHO + yROOH ';
k(:,i) =  5.00e-1.*JCLACET;
Gstr{i,1} = 'CLACET'; 
fCLACET(i)=fCLACET(i)-1; fMECO3(i)=fMECO3(i)+1; fRO2C(i)=fRO2C(i)+1; fxCL(i)=fxCL(i)+1; fxHCHO(i)=fxHCHO(i)+1; fyROOH(i)=fyROOH(i)+1; 

%CE01
i=i+1;
Rnames{i} = ' CH4 + CL = HCL + MEO2 ';
k(:,i) =  7.30e-12.*exp(-1280./ T);
Gstr{i,1} = 'CH4'; Gstr{i,2} = 'CL'; 
fCH4(i)=fCH4(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+1; fMEO2(i)=fMEO2(i)+1; 

%TE01
i=i+1;
Rnames{i} = ' PROPENE + CL = 0.124*HCL + 0.971*xHO2 + 0.971*RO2C + 0.029*RO2XC + 0.029*zRNO3 + 0.124*xACROLEIN + 0.306*xCLCCHO + 0.54*xCLACET + yROOH + 0.222*XC  ';
k(:,i) =  2.67e-10;
Gstr{i,1} = 'PROPENE'; Gstr{i,2} = 'CL'; 
fPROPENE(i)=fPROPENE(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+0.124; fxHO2(i)=fxHO2(i)+0.971; fRO2C(i)=fRO2C(i)+0.971;
fRO2XC(i)=fRO2XC(i)+0.029;fzRNO3(i)=fzRNO3(i)+0.029;fxACROLEIN(i)=fxACROLEIN(i)+0.124;fxCLCCHO(i)=fxCLCCHO(i)+0.306;
fxCLACET(i)=fxCLACET(i)+0.54;fyROOH(i)=fyROOH(i)+1;fXC(i)=fXC(i)+0.222;

%TE02
i=i+1;
Rnames{i} = ' BUTADIENE13 + CL = 0.39*xHO2 + 0.541*xCL + 1.884*RO2C + 0.069*RO2XC + 0.069*zRNO3 + 0.863*xHCHO + 0.457*xACROLEIN + 0.473*xIPRD + yROOH - 1.013*XC  ';
k(:,i) =  4.9e-10;
Gstr{i,1} = 'BUTADIENE13'; Gstr{i,2} = 'CL'; 
fBUTADIENE13(i)=fBUTADIENE13(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.39; fxCL(i)=fxCL(i)+0.541;fRO2C(i)=fRO2C(i)+1.884;
fRO2XC(i)=fRO2XC(i)+0.069;fzRNO3(i)=fzRNO3(i)+0.069;fxACROLEIN(i)=fxACROLEIN(i)+0.457;fxHCHO(i)=fxHCHO(i)+0.863;
fxIPRD(i)=fxIPRD(i)+0.473;fyROOH(i)=fyROOH(i)+1;fXC(i)=fXC(i)-1.013;


%CE02
i=i+1;
Rnames{i} = ' ETHE + CL = 2*RO2C + xHO2 + xHCHO + CLCHO';
k(:,i) = K_ETHE_CL;
Gstr{i,1} = 'ETHE'; Gstr{i,2} = 'CL'; 
fETHE(i)=fETHE(i)-1; fCL(i)=fCL(i)-1; fRO2C(i)=fRO2C(i)+2; fxHO2(i)=fxHO2(i)+1; fxHCHO(i)=fxHCHO(i)+1; fCLCHO(i)=fCLCHO(i)+1; 

%CE03
i=i+1;
Rnames{i} = ' ISOP + CL = 0.15*HCL + 1.168*RO2C + 0.085*RO2XC + 0.085*zRNO3 + 0.738*xHO2 + 0.177*xCL + 0.275*xHCHO + 0.177*xMVK + 0.671*xIPRD +  0.067*xCLCCHO + yR6OOH + 0.018*XC ';
k(:,i) =  4.80e-10;
Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'CL'; 
fISOP(i)=fISOP(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+0.15; fRO2C(i)=fRO2C(i)+1.168; fRO2XC(i)=fRO2XC(i)+0.085; 
fzRNO3(i)=fzRNO3(i)+0.085; fxHO2(i)=fxHO2(i)+0.738; fxCL(i)=fxCL(i)+0.177; fxHCHO(i)=fxHCHO(i)+0.275; 
fxMVK(i)=fxMVK(i)+0.177; fxIPRD(i)=fxIPRD(i)+0.671; fxCLCCHO(i)=fxCLCCHO(i)+0.067; fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+0.018; 

%TE03
i=i+1;
Rnames{i} = ' APIN + CL = 0.548*HCL + 0.252*xHO2 + 0.068*xCL + 0.034*xMECO3 + 0.05*xRCO3 + 0.016*xMACO3 + 2.258*RO2C + 0.582*RO2XC + 0.582*zRNO3 + 0.035*xCO + 0.158*xHCHO + 0.185*xRCHO + 0.274*xACET + 0.007*xGLY + 0.003*xBACL + 0.003*xMVK + 0.158*xIPRD + 0.006*xAFG1 + 0.006*xAFG2 + 0.001*xAFG3 + 0.109*xCLCCHO + yR6OOH + 3.543*XC ';
k(:,i) =  5.46e-10;
Gstr{i,1} = 'APIN'; Gstr{i,2} = 'CL'; 
fAPIN(i)=fAPIN(i)-1; fCL(i)=fCL(i)-1; fHCL(i)=fHCL(i)+0.548;fxHO2(i)=fxHO2(i)+0.252; fxCL(i)=fxCL(i)+0.068;
fxMECO3(i)=fxMECO3(i)+0.034;fxRCO3(i)=fxRCO3(i)+0.05;fxMACO3(i)=fxMACO3(i)+0.016;fRO2C(i)=fRO2C(i)+2.258;
fRO2XC(i)=fRO2XC(i)+0.582;fzRNO3(i)=fzRNO3(i)+0.582;fxCO(i)=fxCO(i)+0.035;fxHCHO(i)=fxHCHO(i)+0.158;
fxRCHO(i)=fxRCHO(i)+0.185;fxACET(i)=fxACET(i)+0.274;fxGLY(i)=fxGLY(i)+0.007;fxBACL(i)=fxBACL(i)+0.003;
fxMVK(i)=fxMVK(i)+0.003;fxIPRD(i)=fxIPRD(i)+0.158;fxAFG1(i)=fxAFG1(i)+0.006;fxAFG2(i)=fxAFG2(i)+0.006;
fxAFG3(i)=fxAFG3(i)+0.001;fxCLCCHO(i)=fxCLCCHO(i)+0.109;fyR6OOH(i)=fyR6OOH(i)+1;fXC(i)=fXC(i)+3.543;

%CE04 Tic version uses ACETYLENE, not ACYE
i=i+1;
Rnames{i} = ' ACETYLENE + CL = HO2 + CO + XC ';
k(:,i) = K_ACYE_CL;
Gstr{i,1} = 'ACETYLENE'; Gstr{i,2} = 'CL'; 
fACETYLENE(i)=fACETYLENE(i)-1; fCL(i)=fCL(i)-1; fHO2(i)=fHO2(i)+1; fCO(i)=fCO(i)+1; fXC(i)=fXC(i)+1; 

%TE04
i=i+1;
Rnames{i} = ' TOLUENE + CL = 0.894*xHO2 + 0.894*RO2C + 0.106*RO2XC + 0.106*zRNO3 + 0.894*xBALD + 0.106*XC';
k(:,i) =  6.2e-11;
Gstr{i,1} = 'TOLUENE'; Gstr{i,2} = 'CL'; 
fTOLUENE(i)=fTOLUENE(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.894; 
fRO2C(i)=fRO2C(i)+0.894;
fRO2XC(i)=fRO2XC(i)+0.106;fzRNO3(i)=fzRNO3(i)+0.106;
fxBALD(i)=fxBALD(i)+0.894;fXC(i)=fXC(i)+0.106;

%TE05
i=i+1;
Rnames{i} = ' MXYL + CL = 0.864*xHO2 + 0.864*RO2C + 0.136*RO2XC + 0.136*zRNO3 + 0.864*xBALD + 1.136*XC';
k(:,i) =  1.35e-10;
Gstr{i,1} = 'MXYL'; Gstr{i,2} = 'CL'; 
fMXYL(i)=fMXYL(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.864; 
fRO2C(i)=fRO2C(i)+0.864;
fRO2XC(i)=fRO2XC(i)+0.136;fzRNO3(i)=fzRNO3(i)+0.136;
fxBALD(i)=fxBALD(i)+0.864;fXC(i)=fXC(i)+1.136;

%TE06
i=i+1;
Rnames{i} = ' OXYL + CL = 0.864*xHO2 + 0.864*RO2C + 0.136*RO2XC + 0.136*zRNO3 + 0.864*xBALD + 1.136*XC';
k(:,i) =  1.4e-10;
Gstr{i,1} = 'OXYL'; Gstr{i,2} = 'CL'; 
fOXYL(i)=fOXYL(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.864; 
fRO2C(i)=fRO2C(i)+0.864;
fRO2XC(i)=fRO2XC(i)+0.136;fzRNO3(i)=fzRNO3(i)+0.136;
fxBALD(i)=fxBALD(i)+0.864;fXC(i)=fXC(i)+1.136;

%TE07
i=i+1;
Rnames{i} = ' PXYL + CL = 0.864*xHO2 + 0.864*RO2C + 0.136*RO2XC + 0.136*zRNO3 + 0.864*xBALD + 1.136*XC ';
k(:,i) =  1.44e-10;
Gstr{i,1} = 'PXYL'; Gstr{i,2} = 'CL'; 
fPXYL(i)=fPXYL(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.864; 
fRO2C(i)=fRO2C(i)+0.864;
fRO2XC(i)=fRO2XC(i)+0.136;fzRNO3(i)=fzRNO3(i)+0.136;
fxBALD(i)=fxBALD(i)+0.864;fXC(i)=fXC(i)+1.136;

%TE08
i=i+1;
Rnames{i} = 'TMBENZ124 + CL = 0.838*xHO2 + 0.838*RO2C + 0.162*RO2XC + 0.162*zRNO3 + 0.838*xBALD + 2.162*XC ';
k(:,i) =  2.42e-10;
Gstr{i,1} = 'TMBENZ124'; Gstr{i,2} = 'CL'; 
fTMBENZ124(i)=fTMBENZ124(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.838; 
fRO2C(i)=fRO2C(i)+0.838;
fRO2XC(i)=fRO2XC(i)+0.162;fzRNO3(i)=fzRNO3(i)+0.162;
fxBALD(i)=fxBALD(i)+0.838;fXC(i)=fXC(i)+2.162;

%TE09
i=i+1;
Rnames{i} = 'ETOH + CL = HCL + 0.688*HO2 + 0.312*xHO2 + 0.312*RO2C + 0.503*xHCHO + 0.688*CCHO + 0.061*xHOCCHO + 0.312*yROOH - 0.001*XC  ';
k(:,i) =   8.6e-11.*exp(45./ T);
Gstr{i,1} = 'ETOH'; Gstr{i,2} = 'CL'; 
fETOH(i)=fETOH(i)-1; fCL(i)=fCL(i)-1; fHO2(i)=fHO2(i)+0.688; fxHO2(i)=fxHO2(i)+0.312;
fRO2C(i)=fRO2C(i)+0.312;fxHCHO(i)=fxHCHO(i)+0.503;
fCCHO(i)=fCCHO(i)+0.688;fxHOCCHO(i)=fxHOCCHO(i)+0.061;
fyROOH(i)=fyROOH(i)+0.312;fXC(i)=fXC(i)-0.001;

%BC01
i=i+1;
Rnames{i} = ' ALK1 + CL = xHO2 + RO2C + HCL + xCCHO + yROOH ';
k(:,i) =  8.30e-11.*exp(-100./ T);
Gstr{i,1} = 'ALK1'; Gstr{i,2} = 'CL'; 
fALK1(i)=fALK1(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+1; fRO2C(i)=fRO2C(i)+1; fHCL(i)=fHCL(i)+1; 
fxCCHO(i)=fxCCHO(i)+1; fyROOH(i)=fyROOH(i)+1; 

%BC02
i=i+1;
Rnames{i} = ' ALK2 + CL = 0.97*xHO2 + 0.97*RO2C + 0.03*RO2XC + 0.03*zRNO3 + HCL +  0.482*xRCHO + 0.488*xACET + yROOH + -0.09*XC ';
k(:,i) =  1.20e-10.*exp(40./ T);
Gstr{i,1} = 'ALK2'; Gstr{i,2} = 'CL'; 
fALK2(i)=fALK2(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.97; fRO2C(i)=fRO2C(i)+0.97; 
fRO2XC(i)=fRO2XC(i)+0.03; fzRNO3(i)=fzRNO3(i)+0.03; fHCL(i)=fHCL(i)+1; fxRCHO(i)=fxRCHO(i)+0.482; 
fxACET(i)=fxACET(i)+0.488; fyROOH(i)=fyROOH(i)+1; fXC(i)=fXC(i)+-0.09; 

%BC03
i=i+1;
Rnames{i} = ' ALK3 + CL = 0.835*xHO2 + 0.094*xTBUO + 1.361*RO2C + 0.07*RO2XC + 0.07*zRNO3 + HCL + 0.078*xHCHO + 0.34*xCCHO + 0.343*xRCHO + 0.075*xACET + 0.253*xMEK + 0.983*yROOH + 0.017*yR6OOH + 0.18*XC';
k(:,i) =  1.86e-10;
Gstr{i,1} = 'ALK3'; Gstr{i,2} = 'CL'; 
fALK3(i)=fALK3(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.835;
fxTBUO(i)=fxTBUO(i)+0.094; fRO2C(i)=fRO2C(i)+1.361; fRO2XC(i)=fRO2XC(i)+0.07;
fzRNO3(i)=fzRNO3(i)+0.07; fHCL(i)=fHCL(i)+1; fxHCHO(i)=fxHCHO(i)+0.078; 
fxCCHO(i)=fxCCHO(i)+0.34; fxRCHO(i)=fxRCHO(i)+0.343; fxACET(i)=fxACET(i)+0.075; 
fxMEK(i)=fxMEK(i)+0.253; fyROOH(i)=fyROOH(i)+0.983; fyR6OOH(i)=fyR6OOH(i)+0.017; fXC(i)=fXC(i)+0.18; 

%BC04
i=i+1;
Rnames{i} = ' ALK4 + CL = 0.827*xHO2 + 0.003*xMEO2 + 0.004*xMECO3 + 1.737*RO2C + 0.165*RO2XC + 0.165*zRNO3 + HCL + 0.003*xCO + 0.034*xHCHO + 0.287*xCCHO + 0.412*xRCHO + 0.247*xACET + 0.076*xMEK + 0.13*xPROD2 +  yR6OOH + 0.327*XC ';
k(:,i) =  2.63e-10;
Gstr{i,1} = 'ALK4'; Gstr{i,2} = 'CL'; 
fALK4(i)=fALK4(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.827; fxMEO2(i)=fxMEO2(i)+0.003; 
fxMECO3(i)=fxMECO3(i)+0.004; fRO2C(i)=fRO2C(i)+1.737; fRO2XC(i)=fRO2XC(i)+0.165; fzRNO3(i)=fzRNO3(i)+0.165; 
fHCL(i)=fHCL(i)+1; fxCO(i)=fxCO(i)+0.003; fxHCHO(i)=fxHCHO(i)+0.034; fxCCHO(i)=fxCCHO(i)+0.287; fxRCHO(i)=fxRCHO(i)+0.412; 
fxACET(i)=fxACET(i)+0.247; fxMEK(i)=fxMEK(i)+0.076; fxPROD2(i)=fxPROD2(i)+0.13; fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+0.327; 

%BC05
i=i+1;
Rnames{i} = ' ALK5 + CL = 0.647*xHO2 + 1.541*RO2C + 0.352*RO2XC + 0.352*zRNO3 + HCL + 0.022*xHCHO + 0.08*xCCHO + 0.258*xRCHO + 0.044*xACET + 0.041*xMEK +  0.378*xPROD2 + yR6OOH + 2.368*XC ';
k(:,i) =  4.21e-10;
Gstr{i,1} = 'ALK5'; Gstr{i,2} = 'CL'; 
fALK5(i)=fALK5(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.647; fRO2C(i)=fRO2C(i)+1.541; 
fRO2XC(i)=fRO2XC(i)+0.352; fzRNO3(i)=fzRNO3(i)+0.352; fHCL(i)=fHCL(i)+1; fxHCHO(i)=fxHCHO(i)+0.022; 
fxCCHO(i)=fxCCHO(i)+0.08; fxRCHO(i)=fxRCHO(i)+0.258; fxACET(i)=fxACET(i)+0.044; fxMEK(i)=fxMEK(i)+0.041;
fxPROD2(i)=fxPROD2(i)+0.378; fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+2.368; 

%BC06
i=i+1;
Rnames{i} = ' OLE1 + CL = 0.384*HCL + 0.873*xHO2 + 1.608*RO2C + 0.127*RO2XC + 0.127*zRNO3 + 0.036*xHCHO + 0.206*xCCHO + 0.072*xRCHO + 0.215*xACROLEIN + 0.019*xMVK + 0.038*xIPRD + 0.192*xCLCCHO + 0.337*xCLACET + 0.169*yROOH + 0.831*yR6OOH + 1.268*XC ';
k(:,i) =  3.92e-10;
Gstr{i,1} = 'OLE1'; Gstr{i,2} = 'CL'; 
fOLE1(i)=fOLE1(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.873; fRO2C(i)=fRO2C(i)+1.608; 
fRO2XC(i)=fRO2XC(i)+0.127; fHCL(i)=fHCL(i)+0.384; fxHCHO(i)=fxHCHO(i)+0.036; 
fxCCHO(i)=fxCCHO(i)+0.206; fxRCHO(i)=fxRCHO(i)+0.072; fxACROLEIN(i)=fxACROLEIN(i)+0.215; fxMVK(i)=fxMVK(i)+0.019; 
fxIPRD(i)=fxIPRD(i)+0.038; fxCLCCHO(i)=fxCLCCHO(i)+0.192; fxCLACET(i)=fxCLACET(i)+0.337; fyROOH(i)=fyROOH(i)+0.169; 
fyR6OOH(i)=fyR6OOH(i)+0.831; fXC(i)=fXC(i)+1.268; 

%BC07
i=i+1;
Rnames{i} = ' OLE2 + CL = 0.279*HCL + 0.45*xHO2 + 0.442*xCL + 0.001*xMEO2 + 1.492*RO2C + 0.106*RO2XC + 0.106*zRNO3 + 0.19*xHCHO + 0.383*xCCHO +  0.317*xRCHO + 0.086*xACET + 0.042*xMEK + 0.025*xMACR + 0.058*xMVK + 0.161*xIPRD + 0.013*xCLCCHO + 0.191*xCLACET + 0.319*yROOH + 0.681*yR6OOH + 0.294*XC';
k(:,i) =  3.77e-10;
Gstr{i,1} = 'OLE2'; Gstr{i,2} = 'CL'; 
fOLE2(i)=fOLE2(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.45; fxCL(i)=fxCL(i)+0.442; 
fxMEO2(i)=fxMEO2(i)+0.001; fRO2C(i)=fRO2C(i)+1.492; fRO2XC(i)=fRO2XC(i)+0.106; fzRNO3(i)=fzRNO3(i)+0.106; 
fHCL(i)=fHCL(i)+0.279; fxHCHO(i)=fxHCHO(i)+0.19; fxCCHO(i)=fxCCHO(i)+0.383; fxRCHO(i)=fxRCHO(i)+0.317; 
fxACET(i)=fxACET(i)+0.086; fxMEK(i)=fxMEK(i)+0.042; fxMACR(i)=fxMACR(i)+0.025; fxMVK(i)=fxMVK(i)+0.058; 
fxIPRD(i)=fxIPRD(i)+0.161; fxCLCCHO(i)=fxCLCCHO(i)+0.013; fxCLACET(i)=fxCLACET(i)+0.191; fyROOH(i)=fyROOH(i)+0.319;
fyR6OOH(i)=fyR6OOH(i)+0.681; fXC(i)=fXC(i)+0.294; 

%BC08
i=i+1;
Rnames{i} = ' ARO1 + CL = 0.84*xHO2 + 0.84*RO2C + 0.16*RO2XC + 0.16*zRNO3 + 0.84*xPROD2 + XC ';
k(:,i) =  2.16e-10;
Gstr{i,1} = 'ARO1'; Gstr{i,2} = 'CL'; 
fARO1(i)=fARO1(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.84; fRO2C(i)=fRO2C(i)+0.84; 
fRO2XC(i)=fRO2XC(i)+0.16; fzRNO3(i)=fzRNO3(i)+0.16; fxPROD2(i)=fxPROD2(i)+0.84; fXC(i)=fXC(i)+1;

%BC09a
i=i+1;
Rnames{i} = ' ARO2MN + CL = 0.828*xHO2 + 0.828*RO2C + 0.172*RO2XC + 0.172*zRNO3 + 0.469*xBALD + 0.359*xPROD2 + 2.531*XC  ';
k(:,i) =  2.66e-10;
Gstr{i,1} = 'ARO2MN'; Gstr{i,2} = 'CL'; 
fARO2MN(i)=fARO2MN(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.828; 
fRO2C(i)=fRO2C(i)+0.828; fRO2XC(i)=fRO2XC(i)+0.172; fzRNO3(i)=fzRNO3(i)+0.172; 
fxBALD(i)=fxBALD(i)+0.469; fxPROD2(i)=fxPROD2(i)+0.359; fXC(i)=fXC(i)+2.531;

%BC09b
i=i+1;
Rnames{i} = ' NAPHTHAL + CL = 0.828*xHO2 + 0.828*RO2C + 0.172*RO2XC + 0.172*zRNO3 + 0.469*xBALD + 0.359*xPROD2 + 2.531*XC  ';
k(:,i) =  2.66e-10;
Gstr{i,1} = 'NAPHTHAL'; Gstr{i,2} = 'CL'; 
fNAPHTHAL(i)=fNAPHTHAL(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.828; 
fRO2C(i)=fRO2C(i)+0.828; fRO2XC(i)=fRO2XC(i)+0.172; fzRNO3(i)=fzRNO3(i)+0.172; 
fxBALD(i)=fxBALD(i)+0.469; fxPROD2(i)=fxPROD2(i)+0.359; fXC(i)=fXC(i)+2.531;

%BC10
i=i+1;
Rnames{i} = ' TERP + CL = 0.252*xHO2 + 0.068*xCL + 0.034*xMECO3 + 0.05*xRCO3 + 0.016*xMACO3 + 2.258*RO2C + 0.582*RO2XC + 0.582*zRNO3 + 0.548*HCL + 0.035*xCO + 0.158*xHCHO + 0.185*xRCHO + 0.274*xACET + 0.007*xGLY + 0.003*xBACL + 0.003*xMVK + 0.158*xIPRD + 0.006*xAFG1 + 0.006*xAFG2 +  0.001*xAFG3 + 0.109*xCLCCHO + yR6OOH + 3.543*XC ';
k(:,i) =  5.46e-10;
Gstr{i,1} = 'TERP'; Gstr{i,2} = 'CL'; 
fTERP(i)=fTERP(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.252; fxCL(i)=fxCL(i)+0.068; fxMECO3(i)=fxMECO3(i)+0.034; fxRCO3(i)=fxRCO3(i)+0.05; fxMACO3(i)=fxMACO3(i)+0.016; fRO2C(i)=fRO2C(i)+2.258; fRO2XC(i)=fRO2XC(i)+0.582; fzRNO3(i)=fzRNO3(i)+0.582; fHCL(i)=fHCL(i)+0.548; fxCO(i)=fxCO(i)+0.035; fxHCHO(i)=fxHCHO(i)+0.158; fxRCHO(i)=fxRCHO(i)+0.185; fxACET(i)=fxACET(i)+0.274; fxGLY(i)=fxGLY(i)+0.007; fxBACL(i)=fxBACL(i)+0.003; fxMVK(i)=fxMVK(i)+0.003; fxIPRD(i)=fxIPRD(i)+0.158; fxAFG1(i)=fxAFG1(i)+0.006; fxAFG2(i)=fxAFG2(i)+0.006; fxAFG3(i)=fxAFG3(i)+0.001; fxCLCCHO(i)=fxCLCCHO(i)+0.109; fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+3.543; 

%BC11
i=i+1;
Rnames{i} = ' SESQ + CL = 0.252*xHO2 + 0.068*xCL + 0.034*xMECO3 + 0.05*xRCO3 + 0.016*xMACO3 + 2.258*RO2C + 0.582*RO2XC + 0.582*zRNO3 + 0.548*HCL + 0.035*xCO + 0.158*xHCHO + 0.185*xRCHO + 0.274*xACET + 0.007*xGLY + 0.003*xBACL + 0.003*xMVK + 0.158*xIPRD + 0.006*xAFG1 + 0.006*xAFG2 + 0.001*xAFG3 + 0.109*xCLCCHO + yR6OOH + 8.543*XC';
k(:,i) =  5.46e-10;
Gstr{i,1} = 'SESQ'; Gstr{i,2} = 'CL'; 
fSESQ(i)=fSESQ(i)-1; fCL(i)=fCL(i)-1; fxHO2(i)=fxHO2(i)+0.252; fxCL(i)=fxCL(i)+0.068; fxMECO3(i)=fxMECO3(i)+0.034;
fxRCO3(i)=fxRCO3(i)+0.05; fxMACO3(i)=fxMACO3(i)+0.016; fRO2C(i)=fRO2C(i)+2.258; fRO2XC(i)=fRO2XC(i)+0.582;
fzRNO3(i)=fzRNO3(i)+0.582; fHCL(i)=fHCL(i)+0.548; fxCO(i)=fxCO(i)+0.035; fxHCHO(i)=fxHCHO(i)+0.158; 
fxRCHO(i)=fxRCHO(i)+0.185; fxACET(i)=fxACET(i)+0.274; fxGLY(i)=fxGLY(i)+0.007; fxBACL(i)=fxBACL(i)+0.003; 
fxMVK(i)=fxMVK(i)+0.003; fxIPRD(i)=fxIPRD(i)+0.158; fxAFG1(i)=fxAFG1(i)+0.006; fxAFG2(i)=fxAFG2(i)+0.006; 
fxAFG3(i)=fxAFG3(i)+0.001; fxCLCCHO(i)=fxCLCCHO(i)+0.109; fyR6OOH(i)=fyR6OOH(i)+1; fXC(i)=fXC(i)+8.543;

%R019
i=i+1;
Rnames{i} = 'NO +  xHO2 = HO2  + NO';
k(:,i) =  2.60e-12.*exp(380./ T); %BR07
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xHO2'; 
fNO(i)=fNO(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+1; fNO(i)=fNO(i)+1; 

%R021
i=i+1;
Rnames{i} = 'NO3 +  xHO2 = HO2  + NO3';
k(:,i) =  2.30e-12; %BR09
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xHO2'; 
fNO3(i)=fNO3(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+1; fNO3(i)=fNO3(i)+1; 

%R025
i=i+1;
Rnames{i} = 'MECO3 +  xHO2 = HO2  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T); %BR25
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xHO2'; 
fMECO3(i)=fMECO3(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R026
i=i+1;
Rnames{i} = 'RCO3 + xHO2 = HO2  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T); %BR25
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xHO2'; 
fRCO3(i)=fRCO3(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R027
i=i+1;
Rnames{i} = 'BZCO3 + xHO2 = HO2  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);%BR25
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xHO2'; 
fBZCO3(i)=fBZCO3(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R028
i=i+1;
Rnames{i} = 'MACO3 + xHO2 = HO2  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);%BR25
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xHO2'; 
fMACO3(i)=fMACO3(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R022
i=i+1;
Rnames{i} = 'MEO2 +  xHO2 = 0.5*HO2  + MEO2';
k(:,i) =  2.00e-13;%BR10
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xHO2'; 
fMEO2(i)=fMEO2(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+0.5; fMEO2(i)=fMEO2(i)+1; 

%R023
i=i+1;
Rnames{i} = 'RO2C +  xHO2 = 0.5*HO2  + RO2C';
k(:,i) =  3.50e-14;%BR11
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xHO2'; 
fRO2C(i)=fRO2C(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+0.5; fRO2C(i)=fRO2C(i)+1; 

%R024
i=i+1;
Rnames{i} = 'RO2XC +  xHO2 = 0.5*HO2  + RO2XC';
k(:,i) =  3.50e-14;%BR11
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xHO2'; 
fRO2XC(i)=fRO2XC(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; 

%R020
i=i+1;
Rnames{i} = 'HO2 +  xHO2 =   + HO2';
k(:,i) =  3.80e-13.*exp(900./ T); %BR08
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xHO2'; 
fHO2(i)=fHO2(i)-1; fxHO2(i)=fxHO2(i)-1; fHO2(i)=fHO2(i)+1; 

%R029
i=i+1;
Rnames{i} = 'NO +  xOH = OH  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);%BR07
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xOH'; 
fNO(i)=fNO(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+1; fNO(i)=fNO(i)+1; 

%R031
i=i+1;
Rnames{i} = 'NO3 +  xOH = OH  + NO3';
k(:,i) =  2.30e-12;%BR09
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xOH'; 
fNO3(i)=fNO3(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+1; fNO3(i)=fNO3(i)+1; 

%R035
i=i+1;
Rnames{i} = 'MECO3 +  xOH = OH  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);%BR25
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xOH'; 
fMECO3(i)=fMECO3(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R036
i=i+1;
Rnames{i} = 'RCO3 +  xOH = OH  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);%BR25
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xOH'; 
fRCO3(i)=fRCO3(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R037
i=i+1;
Rnames{i} = 'BZCO3 +  xOH = OH  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);%BR25
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xOH'; 
fBZCO3(i)=fBZCO3(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R038
i=i+1;
Rnames{i} = 'MACO3 +  xOH = OH  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);%BR25
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xOH'; 
fMACO3(i)=fMACO3(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R032
i=i+1;
Rnames{i} = 'MEO2 +  xOH = 0.5*OH  + MEO2';
k(:,i) =  2.00e-13;%BR10
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xOH'; 
fMEO2(i)=fMEO2(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+0.5; fMEO2(i)=fMEO2(i)+1; 

%R033
i=i+1;
Rnames{i} = 'RO2C +  xOH =0.5*OH  + RO2C';
k(:,i) =  3.50e-14;%BR11
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xOH'; 
fRO2C(i)=fRO2C(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+0.5; fRO2C(i)=fRO2C(i)+1; 

%R034
i=i+1;
Rnames{i} = 'RO2XC +  xOH = 0.5*OH  + RO2XC';
k(:,i) =  3.50e-14;%BR11 delete '*0.5'
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xOH'; 
fRO2XC(i)=fRO2XC(i)-1; fxOH(i)=fxOH(i)-1; fOH(i)=fOH(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; 

%R030
i=i+1;
Rnames{i} = 'HO2 +  xOH =  HO2';
k(:,i) =  3.80e-13.*exp(900./ T); %BR08
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xOH'; 
fHO2(i)=fHO2(i)-1; fxOH(i)=fxOH(i)-1; fHO2(i)=fHO2(i)+1; 

%R039
i=i+1;
Rnames{i} = 'NO +  xNO2 = NO2  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xNO2'; 
fNO(i)=fNO(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+1; fNO(i)=fNO(i)+1; 

%R041
i=i+1;
Rnames{i} = 'NO3 +  xNO2 = NO2  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xNO2'; 
fNO3(i)=fNO3(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+1; fNO3(i)=fNO3(i)+1; 

%R045
i=i+1;
Rnames{i} = 'MECO3 +  xNO2 = NO2  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xNO2'; 
fMECO3(i)=fMECO3(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R046
i=i+1;
Rnames{i} = 'RCO3 +  xNO2 = NO2  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xNO2'; 
fRCO3(i)=fRCO3(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R047
i=i+1;
Rnames{i} = 'BZCO3 +  xNO2 = NO2  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xNO2'; 
fBZCO3(i)=fBZCO3(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R048
i=i+1;
Rnames{i} = 'MACO3 +  xNO2 = NO2  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xNO2'; 
fMACO3(i)=fMACO3(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R042 rate doubled and add 0.5*XN
i=i+1;
Rnames{i} = 'MEO2 +  xNO2 = 0.5*NO2  + 0.5*XN + MEO2 ';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xNO2'; 
fMEO2(i)=fMEO2(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+0.5; fMEO2(i)=fMEO2(i)+1;  fXN(i)=fXN(i)+0.5;

%R043 rate doubled and add 0.5*XN
i=i+1;
Rnames{i} = 'RO2C +  xNO2 = 0.5*NO2  + 0.5*XN + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xNO2'; 
fRO2C(i)=fRO2C(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+0.5; fRO2C(i)=fRO2C(i)+1;fXN(i)=fXN(i)+0.5; 

%R044 rate doubled and add 0.5*XN
i=i+1;
Rnames{i} = 'RO2XC +  xNO2 = 0.5*NO2  + 0.5*XN + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xNO2'; 
fRO2XC(i)=fRO2XC(i)-1; fxNO2(i)=fxNO2(i)-1; fNO2(i)=fNO2(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXN(i)=fXN(i)+0.5;

%R040
i=i+1;
Rnames{i} = 'HO2 +  xNO2 = XN  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xNO2'; 
fHO2(i)=fHO2(i)-1; fxNO2(i)=fxNO2(i)-1; fXN(i)=fXN(i)+1; fHO2(i)=fHO2(i)+1; 

%R049
i=i+1;
Rnames{i} = 'NO +  xMEO2 = MEO2  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xMEO2'; 
fNO(i)=fNO(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+1; fNO(i)=fNO(i)+1; 

%R051
i=i+1;
Rnames{i} = 'NO3 +  xMEO2 = MEO2  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xMEO2'; 
fNO3(i)=fNO3(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+1; fNO3(i)=fNO3(i)+1; 

%R055
i=i+1;
Rnames{i} = 'MECO3 +  xMEO2 = MEO2  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xMEO2'; 
fMECO3(i)=fMECO3(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R056
i=i+1;
Rnames{i} = 'RCO3 +  xMEO2 = MEO2  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xMEO2'; 
fRCO3(i)=fRCO3(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R057
i=i+1;
Rnames{i} = 'BZCO3 +  xMEO2 = MEO2  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xMEO2'; 
fBZCO3(i)=fBZCO3(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R058
i=i+1;
Rnames{i} = 'MACO3 +  xMEO2 = MEO2  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xMEO2'; 
fMACO3(i)=fMACO3(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R052 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xMEO2 = 0.5*MEO2  + 0.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xMEO2'; 
fMEO2(i)=fMEO2(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+0.5;

%R053 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xMEO2 = 0.5*MEO2  + 0.5*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xMEO2'; 
fRO2C(i)=fRO2C(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+0.5;

%R054 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xMEO2 = 0.5*MEO2  + 0.5*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xMEO2'; 
fRO2XC(i)=fRO2XC(i)-1; fxMEO2(i)=fxMEO2(i)-1; fMEO2(i)=fMEO2(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+0.5;

%R050
i=i+1;
Rnames{i} = 'HO2 +  xMEO2 = XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xMEO2'; 
fHO2(i)=fHO2(i)-1; fxMEO2(i)=fxMEO2(i)-1; fXC(i)=fXC(i)+1; fHO2(i)=fHO2(i)+1; 

%R059
i=i+1;
Rnames{i} = 'NO +  xMECO3 = MECO3  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xMECO3'; 
fNO(i)=fNO(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+1; fNO(i)=fNO(i)+1; 

%R061
i=i+1;
Rnames{i} = 'NO3 +  xMECO3 = MECO3  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xMECO3'; 
fNO3(i)=fNO3(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+1; fNO3(i)=fNO3(i)+1; 

%R065
i=i+1;
Rnames{i} = 'MECO3 +  xMECO3 = MECO3  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xMECO3'; 
fMECO3(i)=fMECO3(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R066
i=i+1;
Rnames{i} = 'RCO3 +  xMECO3 = MECO3  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xMECO3'; 
fRCO3(i)=fRCO3(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R067
i=i+1;
Rnames{i} = 'BZCO3 +  xMECO3 = MECO3  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xMECO3'; 
fBZCO3(i)=fBZCO3(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R068
i=i+1;
Rnames{i} = 'MACO3 +  xMECO3 = MECO3  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xMECO3'; 
fMACO3(i)=fMACO3(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R062 double the rate and add XC
i=i+1;
Rnames{i} = 'MEO2 +  xMECO3 = XC + 0.5*MECO3  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xMECO3'; 
fMEO2(i)=fMEO2(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+0.5; fMEO2(i)=fMEO2(i)+1;fXC(i)=fXC(i)+1;

%R063 double the rate and add XC
i=i+1;
Rnames{i} = 'RO2C +  xMECO3 = XC + 0.5*MECO3 + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xMECO3'; 
fRO2C(i)=fRO2C(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+1;

%R064 double the rate and add XC
i=i+1;
Rnames{i} = 'RO2XC +  xMECO3 = XC + 0.5*MECO3 + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xMECO3'; 
fRO2XC(i)=fRO2XC(i)-1; fxMECO3(i)=fxMECO3(i)-1; fMECO3(i)=fMECO3(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+1;

%R060
i=i+1;
Rnames{i} = 'HO2 +  xMECO3 = 2*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xMECO3'; 
fHO2(i)=fHO2(i)-1; fxMECO3(i)=fxMECO3(i)-1; fXC(i)=fXC(i)+2; fHO2(i)=fHO2(i)+1; 

%R069
i=i+1;
Rnames{i} = 'NO +  xRCO3 = RCO3  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xRCO3'; 
fNO(i)=fNO(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+1; fNO(i)=fNO(i)+1; 

%R071
i=i+1;
Rnames{i} = 'NO3 +  xRCO3 = RCO3  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xRCO3'; 
fNO3(i)=fNO3(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+1; fNO3(i)=fNO3(i)+1; 

%R075
i=i+1;
Rnames{i} = 'MECO3 +  xRCO3 = RCO3  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xRCO3'; 
fMECO3(i)=fMECO3(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R076
i=i+1;
Rnames{i} = 'RCO3 +  xRCO3 = RCO3  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xRCO3'; 
fRCO3(i)=fRCO3(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R077
i=i+1;
Rnames{i} = 'BZCO3 +  xRCO3 = RCO3  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xRCO3'; 
fBZCO3(i)=fBZCO3(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R078
i=i+1;
Rnames{i} = 'MACO3 +  xRCO3 = RCO3  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xRCO3'; 
fMACO3(i)=fMACO3(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R072 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xRCO3 = 0.5*RCO3 + 1.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xRCO3'; 
fMEO2(i)=fMEO2(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1.5; 

%R073 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xRCO3 = 0.5*RCO3 + 1.5*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xRCO3'; 
fRO2C(i)=fRO2C(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+1.5; 

%R074 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xRCO3 = 0.5*RCO3 + 1.5*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xRCO3'; 
fRO2XC(i)=fRO2XC(i)-1; fxRCO3(i)=fxRCO3(i)-1; fRCO3(i)=fRCO3(i)+0.5; fRO2XC(i)=fRO2XC(i)+1;fXC(i)=fXC(i)+1.5;  

%R070
i=i+1;
Rnames{i} = 'HO2 +  xRCO3 = 3*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xRCO3'; 
fHO2(i)=fHO2(i)-1; fxRCO3(i)=fxRCO3(i)-1; fXC(i)=fXC(i)+3; fHO2(i)=fHO2(i)+1; 

%R079
i=i+1;
Rnames{i} = 'NO +  xMACO3 = MACO3  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xMACO3'; 
fNO(i)=fNO(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+1; fNO(i)=fNO(i)+1; 

%R081
i=i+1;
Rnames{i} = 'NO3 +  xMACO3 = MACO3  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xMACO3'; 
fNO3(i)=fNO3(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+1; fNO3(i)=fNO3(i)+1; 

%R085
i=i+1;
Rnames{i} = 'MECO3 +  xMACO3 = MACO3  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xMACO3'; 
fMECO3(i)=fMECO3(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R086
i=i+1;
Rnames{i} = 'RCO3 +  xMACO3 = MACO3  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xMACO3'; 
fRCO3(i)=fRCO3(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R087
i=i+1;
Rnames{i} = 'BZCO3 +  xMACO3 = MACO3  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xMACO3'; 
fBZCO3(i)=fBZCO3(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R088
i=i+1;
Rnames{i} = 'MACO3 +  xMACO3 = MACO3  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xMACO3'; 
fMACO3(i)=fMACO3(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R082 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'MEO2 +  xMACO3 = 0.5*MACO3 + 2*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xMACO3'; 
fMEO2(i)=fMEO2(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+2; 

%R083 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2C +  xMACO3 = 0.5*MACO3 + 2*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xMACO3'; 
fRO2C(i)=fRO2C(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+2; 

%R084 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2XC +  xMACO3 = 0.5*MACO3 + 2*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xMACO3'; 
fRO2XC(i)=fRO2XC(i)-1; fxMACO3(i)=fxMACO3(i)-1; fMACO3(i)=fMACO3(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+2; 

%R080
i=i+1;
Rnames{i} = 'HO2 +  xMACO3 = 4*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xMACO3'; 
fHO2(i)=fHO2(i)-1; fxMACO3(i)=fxMACO3(i)-1; fXC(i)=fXC(i)+4; fHO2(i)=fHO2(i)+1; 

%R089
i=i+1;
Rnames{i} = 'NO +  xTBUO = TBUO  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xTBUO'; 
fNO(i)=fNO(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+1; fNO(i)=fNO(i)+1; 

%R091
i=i+1;
Rnames{i} = 'NO3 +  xTBUO = TBUO  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xTBUO'; 
fNO3(i)=fNO3(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+1; fNO3(i)=fNO3(i)+1; 

%R095
i=i+1;
Rnames{i} = 'MECO3 +  xTBUO = TBUO  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xTBUO'; 
fMECO3(i)=fMECO3(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R096
i=i+1;
Rnames{i} = 'RCO3 +  xTBUO = TBUO  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xTBUO'; 
fRCO3(i)=fRCO3(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R097
i=i+1;
Rnames{i} = 'BZCO3 +  xTBUO = TBUO  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xTBUO'; 
fBZCO3(i)=fBZCO3(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R098
i=i+1;
Rnames{i} = 'MACO3 +  xTBUO = TBUO  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xTBUO'; 
fMACO3(i)=fMACO3(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R092 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'MEO2 +  xTBUO = 0.5*TBUO  + 2*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xTBUO'; 
fMEO2(i)=fMEO2(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+0.5; fMEO2(i)=fMEO2(i)+1;fXC(i)=fXC(i)+2;  

%R093 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2C +  xTBUO = 0.5*TBUO  + 2*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xTBUO'; 
fRO2C(i)=fRO2C(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+2; 

%R094 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2XC +  xTBUO = 0.5*TBUO  + 2*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xTBUO'; 
fRO2XC(i)=fRO2XC(i)-1; fxTBUO(i)=fxTBUO(i)-1; fTBUO(i)=fTBUO(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+2; 

%R090
i=i+1;
Rnames{i} = 'HO2 +  xTBUO = 4*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xTBUO'; 
fHO2(i)=fHO2(i)-1; fxTBUO(i)=fxTBUO(i)-1; fXC(i)=fXC(i)+4; fHO2(i)=fHO2(i)+1; 

%R099
i=i+1;
Rnames{i} = 'NO +  xCO = CO  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xCO'; 
fNO(i)=fNO(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+1; fNO(i)=fNO(i)+1; 

%R101
i=i+1;
Rnames{i} = 'NO3 +  xCO = CO  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xCO'; 
fNO3(i)=fNO3(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+1; fNO3(i)=fNO3(i)+1; 

%R105
i=i+1;
Rnames{i} = 'MECO3 +  xCO = CO  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xCO'; 
fMECO3(i)=fMECO3(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%R106
i=i+1;
Rnames{i} = 'RCO3 +  xCO = CO  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xCO'; 
fRCO3(i)=fRCO3(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+1; fRCO3(i)=fRCO3(i)+1; 

%R107
i=i+1;
Rnames{i} = 'BZCO3 +  xCO = CO  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xCO'; 
fBZCO3(i)=fBZCO3(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%R108
i=i+1;
Rnames{i} = 'MACO3 +  xCO = CO  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xCO'; 
fMACO3(i)=fMACO3(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+1; fMACO3(i)=fMACO3(i)+1; 

%R102 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xCO = 0.5*CO + 0.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xCO'; 
fMEO2(i)=fMEO2(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+0.5; 

%R103 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xCO = 0.5*CO + 0.5*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xCO'; 
fRO2C(i)=fRO2C(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+0.5;

%R104 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xCO = 0.5*CO + 0.5*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xCO'; 
fRO2XC(i)=fRO2XC(i)-1; fxCO(i)=fxCO(i)-1; fCO(i)=fCO(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+0.5;

%R100
i=i+1;
Rnames{i} = 'HO2 +  xCO = XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xCO'; 
fHO2(i)=fHO2(i)-1; fxCO(i)=fxCO(i)-1; fXC(i)=fXC(i)+1; fHO2(i)=fHO2(i)+1; 

%P001
i=i+1;
Rnames{i} = 'NO +  xHCHO = HCHO  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xHCHO'; 
fNO(i)=fNO(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+1; fNO(i)=fNO(i)+1; 

%P003
i=i+1;
Rnames{i} = 'NO3 +  xHCHO = HCHO  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xHCHO'; 
fNO3(i)=fNO3(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+1; fNO3(i)=fNO3(i)+1; 

%P007
i=i+1;
Rnames{i} = 'MECO3 +  xHCHO = HCHO  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xHCHO'; 
fMECO3(i)=fMECO3(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P008
i=i+1;
Rnames{i} = 'RCO3 +  xHCHO = HCHO  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xHCHO'; 
fRCO3(i)=fRCO3(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P009
i=i+1;
Rnames{i} = 'BZCO3 +  xHCHO = HCHO  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xHCHO'; 
fBZCO3(i)=fBZCO3(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P010
i=i+1;
Rnames{i} = 'MACO3 +  xHCHO = HCHO  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xHCHO'; 
fMACO3(i)=fMACO3(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P004 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xHCHO = 0.5*HCHO + 0.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xHCHO'; 
fMEO2(i)=fMEO2(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+0.5; fMEO2(i)=fMEO2(i)+1;fXC(i)=fXC(i)+0.5; 

%P005 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xHCHO = 0.5*HCHO + 0.5*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xHCHO'; 
fRO2C(i)=fRO2C(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+0.5; 

%P006 rate doubled and add 0.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xHCHO = 0.5*HCHO + 0.5*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xHCHO'; 
fRO2XC(i)=fRO2XC(i)-1; fxHCHO(i)=fxHCHO(i)-1; fHCHO(i)=fHCHO(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+0.5; 

%P002
i=i+1;
Rnames{i} = 'HO2 +  xHCHO = XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xHCHO'; 
fHO2(i)=fHO2(i)-1; fxHCHO(i)=fxHCHO(i)-1; fXC(i)=fXC(i)+1; fHO2(i)=fHO2(i)+1; 

%P011
i=i+1;
Rnames{i} = 'NO +  xCCHO = CCHO  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xCCHO'; 
fNO(i)=fNO(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+1; fNO(i)=fNO(i)+1; 

%P013
i=i+1;
Rnames{i} = 'NO3 +  xCCHO = CCHO  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xCCHO'; 
fNO3(i)=fNO3(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+1; fNO3(i)=fNO3(i)+1; 

%P017
i=i+1;
Rnames{i} = 'MECO3 +  xCCHO = CCHO  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xCCHO'; 
fMECO3(i)=fMECO3(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P018
i=i+1;
Rnames{i} = 'RCO3 +  xCCHO = CCHO  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xCCHO'; 
fRCO3(i)=fRCO3(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P019
i=i+1;
Rnames{i} = 'BZCO3 +  xCCHO = CCHO  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xCCHO'; 
fBZCO3(i)=fBZCO3(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P020
i=i+1;
Rnames{i} = 'MACO3 +  xCCHO = CCHO  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xCCHO'; 
fMACO3(i)=fMACO3(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P014 rate doubled and add XC
i=i+1;
Rnames{i} = 'MEO2 +  xCCHO = 0.5*CCHO + XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xCCHO'; 
fMEO2(i)=fMEO2(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1;

%P015
i=i+1;
Rnames{i} = 'RO2C +  xCCHO = 0.5*CCHO + XC   + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xCCHO'; 
fRO2C(i)=fRO2C(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+1;

%P016
i=i+1;
Rnames{i} = 'RO2XC +  xCCHO = 0.5*CCHO + XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xCCHO'; 
fRO2XC(i)=fRO2XC(i)-1; fxCCHO(i)=fxCCHO(i)-1; fCCHO(i)=fCCHO(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+1;

%P012
i=i+1;
Rnames{i} = 'HO2 +  xCCHO = 2*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xCCHO'; 
fHO2(i)=fHO2(i)-1; fxCCHO(i)=fxCCHO(i)-1; fXC(i)=fXC(i)+2; fHO2(i)=fHO2(i)+1; 

%P021
i=i+1;
Rnames{i} = 'NO +  xRCHO = RCHO  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xRCHO'; 
fNO(i)=fNO(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+1; fNO(i)=fNO(i)+1; 

%P023
i=i+1;
Rnames{i} = 'NO3 +  xRCHO = RCHO  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xRCHO'; 
fNO3(i)=fNO3(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+1; fNO3(i)=fNO3(i)+1; 

%P027
i=i+1;
Rnames{i} = 'MECO3 +  xRCHO = RCHO  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xRCHO'; 
fMECO3(i)=fMECO3(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P028
i=i+1;
Rnames{i} = 'RCO3 +  xRCHO = RCHO  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xRCHO'; 
fRCO3(i)=fRCO3(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P029
i=i+1;
Rnames{i} = 'BZCO3 +  xRCHO = RCHO  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xRCHO'; 
fBZCO3(i)=fBZCO3(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P030
i=i+1;
Rnames{i} = 'MACO3 +  xRCHO = RCHO  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xRCHO'; 
fMACO3(i)=fMACO3(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P024 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xRCHO = 0.5*RCHO + 1.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xRCHO'; 
fMEO2(i)=fMEO2(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1.5; 

%P025 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xRCHO = 0.5*RCHO + 1.5*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xRCHO'; 
fRO2C(i)=fRO2C(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+1.5;

%P026 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xRCHO = 0.5*RCHO + 1.5*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xRCHO'; 
fRO2XC(i)=fRO2XC(i)-1; fxRCHO(i)=fxRCHO(i)-1; fRCHO(i)=fRCHO(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+1.5;

%P022
i=i+1;
Rnames{i} = 'HO2 +  xRCHO = 3*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xRCHO'; 
fHO2(i)=fHO2(i)-1; fxRCHO(i)=fxRCHO(i)-1; fXC(i)=fXC(i)+3; fHO2(i)=fHO2(i)+1; 

%P031
i=i+1;
Rnames{i} = 'NO +  xACET = ACET  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xACET'; 
fNO(i)=fNO(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+1; fNO(i)=fNO(i)+1; 

%P033
i=i+1;
Rnames{i} = 'NO3 +  xACET = ACET  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xACET'; 
fNO3(i)=fNO3(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+1; fNO3(i)=fNO3(i)+1; 

%P037
i=i+1;
Rnames{i} = 'MECO3 +  xACET = ACET  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xACET'; 
fMECO3(i)=fMECO3(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P038
i=i+1;
Rnames{i} = 'RCO3 +  xACET = ACET  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xACET'; 
fRCO3(i)=fRCO3(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P039
i=i+1;
Rnames{i} = 'BZCO3 +  xACET = ACET  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xACET'; 
fBZCO3(i)=fBZCO3(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P040
i=i+1;
Rnames{i} = 'MACO3 +  xACET = ACET  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xACET'; 
fMACO3(i)=fMACO3(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P034 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xACET = 0.5*ACET + 1.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xACET'; 
fMEO2(i)=fMEO2(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1.5;

%P035 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xACET = 0.5*ACET + 1.5*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xACET'; 
fRO2C(i)=fRO2C(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+0.5; fRO2C(i)=fRO2C(i)+1;fXC(i)=fXC(i)+1.5;

%P036 rate doubled and add 1.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xACET = 0.5*ACET + 1.5*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xACET'; 
fRO2XC(i)=fRO2XC(i)-1; fxACET(i)=fxACET(i)-1; fACET(i)=fACET(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+1.5;

%P032
i=i+1;
Rnames{i} = 'HO2 +  xACET = 3*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xACET'; 
fHO2(i)=fHO2(i)-1; fxACET(i)=fxACET(i)-1; fXC(i)=fXC(i)+3; fHO2(i)=fHO2(i)+1; 

%P041
i=i+1;
Rnames{i} = 'NO +  xMEK = MEK  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xMEK'; 
fNO(i)=fNO(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+1; fNO(i)=fNO(i)+1; 

%P043
i=i+1;
Rnames{i} = 'NO3 +  xMEK = MEK  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xMEK'; 
fNO3(i)=fNO3(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+1; fNO3(i)=fNO3(i)+1; 

%P047
i=i+1;
Rnames{i} = 'MECO3 +  xMEK = MEK  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xMEK'; 
fMECO3(i)=fMECO3(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P048
i=i+1;
Rnames{i} = 'RCO3 +  xMEK = MEK  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xMEK'; 
fRCO3(i)=fRCO3(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P049
i=i+1;
Rnames{i} = 'BZCO3 +  xMEK = MEK  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xMEK'; 
fBZCO3(i)=fBZCO3(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P050
i=i+1;
Rnames{i} = 'MACO3 +  xMEK = MEK  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xMEK'; 
fMACO3(i)=fMACO3(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P044 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'MEO2 +  xMEK = 0.5*MEK + 2*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xMEK'; 
fMEO2(i)=fMEO2(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+2; 

%P045 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2C +  xMEK = 0.5*MEK + 2*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xMEK'; 
fRO2C(i)=fRO2C(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+2; 

%P046 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2XC +  xMEK = 0.5*MEK + 2*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xMEK'; 
fRO2XC(i)=fRO2XC(i)-1; fxMEK(i)=fxMEK(i)-1; fMEK(i)=fMEK(i)+0.5; fRO2XC(i)=fRO2XC(i)+1;fXC(i)=fXC(i)+2;  

%P042
i=i+1;
Rnames{i} = 'HO2 +  xMEK = 4*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xMEK'; 
fHO2(i)=fHO2(i)-1; fxMEK(i)=fxMEK(i)-1; fXC(i)=fXC(i)+4; fHO2(i)=fHO2(i)+1; 

%P051
i=i+1;
Rnames{i} = 'NO +  xPROD2 = PRD2  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xPROD2'; 
fNO(i)=fNO(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+1; fNO(i)=fNO(i)+1; 

%P053
i=i+1;
Rnames{i} = 'NO3 +  xPROD2 = PRD2  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xPROD2'; 
fNO3(i)=fNO3(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+1; fNO3(i)=fNO3(i)+1; 

%P057
i=i+1;
Rnames{i} = 'MECO3 +  xPROD2 = PRD2  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xPROD2'; 
fMECO3(i)=fMECO3(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P058
i=i+1;
Rnames{i} = 'RCO3 +  xPROD2 = PRD2  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xPROD2'; 
fRCO3(i)=fRCO3(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P059
i=i+1;
Rnames{i} = 'BZCO3 +  xPROD2 = PRD2  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xPROD2'; 
fBZCO3(i)=fBZCO3(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P060
i=i+1;
Rnames{i} = 'MACO3 +  xPROD2 = PRD2  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xPROD2'; 
fMACO3(i)=fMACO3(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P054 rate doubled and add 3*XC
i=i+1;
Rnames{i} = 'MEO2 +  xPROD2 = 0.5*PRD2 + 3*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xPROD2'; 
fMEO2(i)=fMEO2(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+3;

%P055 rate doubled and add 3*XC
i=i+1;
Rnames{i} = 'RO2C +  xPROD2 = 0.5*PRD2 + 3*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xPROD2'; 
fRO2C(i)=fRO2C(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+3;

%P056 rate doubled and add 3*XC
i=i+1;
Rnames{i} = 'RO2XC +  xPROD2 = 0.5*PRD2 + 3*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xPROD2'; 
fRO2XC(i)=fRO2XC(i)-1; fxPROD2(i)=fxPROD2(i)-1; fPRD2(i)=fPRD2(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+3;

%P052
i=i+1;
Rnames{i} = 'HO2 +  xPROD2 = 6*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xPROD2'; 
fHO2(i)=fHO2(i)-1; fxPROD2(i)=fxPROD2(i)-1; fXC(i)=fXC(i)+6; fHO2(i)=fHO2(i)+1; 

%P061
i=i+1;
Rnames{i} = 'NO +  xGLY = GLY  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xGLY'; 
fNO(i)=fNO(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+1; fNO(i)=fNO(i)+1; 

%P063
i=i+1;
Rnames{i} = 'NO3 +  xGLY = GLY  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xGLY'; 
fNO3(i)=fNO3(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+1; fNO3(i)=fNO3(i)+1; 

%P067
i=i+1;
Rnames{i} = 'MECO3 +  xGLY = GLY  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xGLY'; 
fMECO3(i)=fMECO3(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P068
i=i+1;
Rnames{i} = 'RCO3 +  xGLY = GLY  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xGLY'; 
fRCO3(i)=fRCO3(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P069
i=i+1;
Rnames{i} = 'BZCO3 +  xGLY = GLY  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xGLY'; 
fBZCO3(i)=fBZCO3(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P070
i=i+1;
Rnames{i} = 'MACO3 +  xGLY = GLY  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xGLY'; 
fMACO3(i)=fMACO3(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P064 rate doubled and add XC
i=i+1;
Rnames{i} = 'MEO2 +  xGLY = 0.5*GLY + XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xGLY'; 
fMEO2(i)=fMEO2(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1; 

%P065 rate doubled and add XC
i=i+1;
Rnames{i} = 'RO2C +  xGLY = 0.5*GLY + XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xGLY'; 
fRO2C(i)=fRO2C(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+0.5; fRO2C(i)=fRO2C(i)+1;fXC(i)=fXC(i)+1; 

%P066 rate doubled and add XC
i=i+1;
Rnames{i} = 'RO2XC +  xGLY = 0.5*GLY + XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xGLY'; 
fRO2XC(i)=fRO2XC(i)-1; fxGLY(i)=fxGLY(i)-1; fGLY(i)=fGLY(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+1;

%P062
i=i+1;
Rnames{i} = 'HO2 +  xGLY = 2*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xGLY'; 
fHO2(i)=fHO2(i)-1; fxGLY(i)=fxGLY(i)-1; fXC(i)=fXC(i)+2; fHO2(i)=fHO2(i)+1; 

%P071
i=i+1;
Rnames{i} = 'NO +  xMGLY = MGLY  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xMGLY'; 
fNO(i)=fNO(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+1; fNO(i)=fNO(i)+1; 

%P073
i=i+1;
Rnames{i} = 'NO3 +  xMGLY = MGLY  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xMGLY'; 
fNO3(i)=fNO3(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+1; fNO3(i)=fNO3(i)+1; 

%P077
i=i+1;
Rnames{i} = 'MECO3 +  xMGLY = MGLY  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xMGLY'; 
fMECO3(i)=fMECO3(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P078
i=i+1;
Rnames{i} = 'RCO3 +  xMGLY = MGLY  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xMGLY'; 
fRCO3(i)=fRCO3(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P079
i=i+1;
Rnames{i} = 'BZCO3 +  xMGLY = MGLY  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xMGLY'; 
fBZCO3(i)=fBZCO3(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P080
i=i+1;
Rnames{i} = 'MACO3 +  xMGLY = MGLY  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xMGLY'; 
fMACO3(i)=fMACO3(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P074 rate doubled and added 1.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xMGLY = 0.5*MGLY +  1.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xMGLY'; 
fMEO2(i)=fMEO2(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1.5;

%P075 rate doubled and added 1.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xMGLY = 0.5*MGLY +  1.5*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xMGLY'; 
fRO2C(i)=fRO2C(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+1.5;

%P075 rate doubled and added 1.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xMGLY = 0.5*MGLY +  1.5*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xMGLY'; 
fRO2XC(i)=fRO2XC(i)-1; fxMGLY(i)=fxMGLY(i)-1; fMGLY(i)=fMGLY(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+1.5;

%P072
i=i+1;
Rnames{i} = 'HO2 +  xMGLY = 3*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xMGLY'; 
fHO2(i)=fHO2(i)-1; fxMGLY(i)=fxMGLY(i)-1; fXC(i)=fXC(i)+3; fHO2(i)=fHO2(i)+1; 

%P081
i=i+1;
Rnames{i} = 'NO +  xBACL = BACL  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xBACL'; 
fNO(i)=fNO(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+1; fNO(i)=fNO(i)+1; 

%P083
i=i+1;
Rnames{i} = 'NO3 +  xBACL = BACL  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xBACL'; 
fNO3(i)=fNO3(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+1; fNO3(i)=fNO3(i)+1; 

%P087
i=i+1;
Rnames{i} = 'MECO3 +  xBACL = BACL  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xBACL'; 
fMECO3(i)=fMECO3(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P088
i=i+1;
Rnames{i} = 'RCO3 +  xBACL = BACL  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xBACL'; 
fRCO3(i)=fRCO3(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P089
i=i+1;
Rnames{i} = 'BZCO3 +  xBACL = BACL  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xBACL'; 
fBZCO3(i)=fBZCO3(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P090
i=i+1;
Rnames{i} = 'MACO3 +  xBACL = BACL  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xBACL'; 
fMACO3(i)=fMACO3(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P084 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'MEO2 +  xBACL = 0.5*BACL + 2*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xBACL'; 
fMEO2(i)=fMEO2(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+2; 

%P085 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2C +  xBACL = 0.5*BACL + 2*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xBACL'; 
fRO2C(i)=fRO2C(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+2; 

%P086 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2XC +  xBACL = 0.5*BACL + 2*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xBACL'; 
fRO2XC(i)=fRO2XC(i)-1; fxBACL(i)=fxBACL(i)-1; fBACL(i)=fBACL(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+2; 

%P082
i=i+1;
Rnames{i} = 'HO2 +  xBACL = 4*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xBACL'; 
fHO2(i)=fHO2(i)-1; fxBACL(i)=fxBACL(i)-1; fXC(i)=fXC(i)+4; fHO2(i)=fHO2(i)+1; 

%P091
i=i+1;
Rnames{i} = 'NO +  xBALD = BALD  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xBALD'; 
fNO(i)=fNO(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+1; fNO(i)=fNO(i)+1; 

%P093
i=i+1;
Rnames{i} = 'NO3 +  xBALD = BALD  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xBALD'; 
fNO3(i)=fNO3(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+1; fNO3(i)=fNO3(i)+1; 

%P097
i=i+1;
Rnames{i} = 'MECO3 +  xBALD = BALD  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xBALD'; 
fMECO3(i)=fMECO3(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P098
i=i+1;
Rnames{i} = 'RCO3 +  xBALD = BALD  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xBALD'; 
fRCO3(i)=fRCO3(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P099
i=i+1;
Rnames{i} = 'BZCO3 +  xBALD = BALD  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xBALD'; 
fBZCO3(i)=fBZCO3(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P100
i=i+1;
Rnames{i} = 'MACO3 +  xBALD = BALD  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xBALD'; 
fMACO3(i)=fMACO3(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P094 rate doubled and 3.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xBALD = 0.5*BALD + 3.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xBALD'; 
fMEO2(i)=fMEO2(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+0.5; fMEO2(i)=fMEO2(i)+1;fXC(i)=fXC(i)+3.5; 

%P095 rate doubled and 3.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xBALD = 0.5*BALD + 3.5*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xBALD'; 
fRO2C(i)=fRO2C(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+3.5; 

%P096 rate doubled and 3.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xBALD = 0.5*BALD + 3.5*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xBALD'; 
fRO2XC(i)=fRO2XC(i)-1; fxBALD(i)=fxBALD(i)-1; fBALD(i)=fBALD(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+3.5; 

%P092
i=i+1;
Rnames{i} = 'HO2 +  xBALD = 7*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xBALD'; 
fHO2(i)=fHO2(i)-1; fxBALD(i)=fxBALD(i)-1; fXC(i)=fXC(i)+7; fHO2(i)=fHO2(i)+1; 

%P101
i=i+1;
Rnames{i} = 'NO +  xAFG1 = AFG1  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xAFG1'; 
fNO(i)=fNO(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+1; fNO(i)=fNO(i)+1; 

%P103
i=i+1;
Rnames{i} = 'NO3 +  xAFG1 = AFG1  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xAFG1'; 
fNO3(i)=fNO3(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+1; fNO3(i)=fNO3(i)+1; 

%P107
i=i+1;
Rnames{i} = 'MECO3 +  xAFG1 = AFG1  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xAFG1'; 
fMECO3(i)=fMECO3(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P108
i=i+1;
Rnames{i} = 'RCO3 +  xAFG1 = AFG1  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xAFG1'; 
fRCO3(i)=fRCO3(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P109
i=i+1;
Rnames{i} = 'BZCO3 +  xAFG1 = AFG1  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xAFG1'; 
fBZCO3(i)=fBZCO3(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P110
i=i+1;
Rnames{i} = 'MACO3 +  xAFG1 = AFG1  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xAFG1'; 
fMACO3(i)=fMACO3(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P104 rate doubled and add 2.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xAFG1 = 0.5*AFG1 + 2.5*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xAFG1'; 
fMEO2(i)=fMEO2(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+2.5;

%P105 rate doubled and add 2.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xAFG1 = 0.5*AFG1 + 2.5*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xAFG1'; 
fRO2C(i)=fRO2C(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+2.5;

%P106 rate doubled and add 2.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xAFG1 = 0.5*AFG1 + 2.5*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xAFG1'; 
fRO2XC(i)=fRO2XC(i)-1; fxAFG1(i)=fxAFG1(i)-1; fAFG1(i)=fAFG1(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+2.5;

%P102
i=i+1;
Rnames{i} = 'HO2 +  xAFG1 = 5*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xAFG1'; 
fHO2(i)=fHO2(i)-1; fxAFG1(i)=fxAFG1(i)-1; fXC(i)=fXC(i)+5; fHO2(i)=fHO2(i)+1; 

%P111
i=i+1;
Rnames{i} = 'NO +  xAFG2 = AFG2  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xAFG2'; 
fNO(i)=fNO(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+1; fNO(i)=fNO(i)+1; 

%P113
i=i+1;
Rnames{i} = 'NO3 +  xAFG2 = AFG2  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xAFG2'; 
fNO3(i)=fNO3(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+1; fNO3(i)=fNO3(i)+1; 

%P117
i=i+1;
Rnames{i} = 'MECO3 +  xAFG2 = AFG2  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xAFG2'; 
fMECO3(i)=fMECO3(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P118
i=i+1;
Rnames{i} = 'RCO3 +  xAFG2 = AFG2  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xAFG2'; 
fRCO3(i)=fRCO3(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P119
i=i+1;
Rnames{i} = 'BZCO3 +  xAFG2 = AFG2  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xAFG2'; 
fBZCO3(i)=fBZCO3(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P120
i=i+1;
Rnames{i} = 'MACO3 +  xAFG2 = AFG2  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xAFG2'; 
fMACO3(i)=fMACO3(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P114 rate doubled and add 2.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xAFG2 = 0.5*AFG2 + 2.5*XC  + MEO2';
k(:,i) =  2.00e-13*0.5;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xAFG2'; 
fMEO2(i)=fMEO2(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+0.5; fMEO2(i)=fMEO2(i)+1;fXC(i)=fXC(i)+2.5; 

%P115 rate doubled and add 2.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xAFG2 = 0.5*AFG2 + 2.5*XC  + RO2C';
k(:,i) =  3.50e-14*0.5;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xAFG2'; 
fRO2C(i)=fRO2C(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+0.5; fRO2C(i)=fRO2C(i)+1;fXC(i)=fXC(i)+2.5; 

%P116 rate doubled and add 2.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xAFG2 = 0.5*AFG2 + 2.5*XC  + RO2XC';
k(:,i) =  3.50e-14*0.5;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xAFG2'; 
fRO2XC(i)=fRO2XC(i)-1; fxAFG2(i)=fxAFG2(i)-1; fAFG2(i)=fAFG2(i)+0.5; fRO2XC(i)=fRO2XC(i)+1;fXC(i)=fXC(i)+2.5; 

%P112
i=i+1;
Rnames{i} = 'HO2 +  xAFG2 = 5*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xAFG2'; 
fHO2(i)=fHO2(i)-1; fxAFG2(i)=fxAFG2(i)-1; fXC(i)=fXC(i)+5; fHO2(i)=fHO2(i)+1; 

%P121
i=i+1;
Rnames{i} = 'NO +  xAFG3 = AFG3  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xAFG3'; 
fNO(i)=fNO(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+1; fNO(i)=fNO(i)+1; 

%P123
i=i+1;
Rnames{i} = 'NO3 +  xAFG3 = AFG3  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xAFG3'; 
fNO3(i)=fNO3(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+1; fNO3(i)=fNO3(i)+1; 

%P127
i=i+1;
Rnames{i} = 'MECO3 +  xAFG3 = AFG3  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xAFG3'; 
fMECO3(i)=fMECO3(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P128
i=i+1;
Rnames{i} = 'RCO3 +  xAFG3 = AFG3  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xAFG3'; 
fRCO3(i)=fRCO3(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P129
i=i+1;
Rnames{i} = 'BZCO3 +  xAFG3 = AFG3  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xAFG3'; 
fBZCO3(i)=fBZCO3(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P130
i=i+1;
Rnames{i} = 'MACO3 +  xAFG3 = AFG3  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xAFG3'; 
fMACO3(i)=fMACO3(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P124 rate doubled and 3.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xAFG3 = 0.5*AFG3 + 3.5*XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xAFG3'; 
fMEO2(i)=fMEO2(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+3.5;

%P125 rate doubled and 3.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xAFG3 = 0.5*AFG3 + 3.5*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xAFG3'; 
fRO2C(i)=fRO2C(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+3.5;

%P126 rate doubled and 3.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xAFG3 = 0.5*AFG3 + 3.5*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xAFG3'; 
fRO2XC(i)=fRO2XC(i)-1; fxAFG3(i)=fxAFG3(i)-1; fAFG3(i)=fAFG3(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+3.5;

%P122
i=i+1;
Rnames{i} = 'HO2 +  xAFG3 = 7*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xAFG3'; 
fHO2(i)=fHO2(i)-1; fxAFG3(i)=fxAFG3(i)-1; fXC(i)=fXC(i)+7; fHO2(i)=fHO2(i)+1; 

%P131
i=i+1;
Rnames{i} = 'NO +  xMACR = MACR  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xMACR'; 
fNO(i)=fNO(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+1; fNO(i)=fNO(i)+1; 

%P133
i=i+1;
Rnames{i} = 'NO3 +  xMACR = MACR  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xMACR'; 
fNO3(i)=fNO3(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+1; fNO3(i)=fNO3(i)+1; 

%P137
i=i+1;
Rnames{i} = 'MECO3 +  xMACR = MACR  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xMACR'; 
fMECO3(i)=fMECO3(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P138
i=i+1;
Rnames{i} = 'RCO3 +  xMACR = MACR  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xMACR'; 
fRCO3(i)=fRCO3(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P139
i=i+1;
Rnames{i} = 'BZCO3 +  xMACR = MACR  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xMACR'; 
fBZCO3(i)=fBZCO3(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P140
i=i+1;
Rnames{i} = 'MACO3 +  xMACR = MACR  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xMACR'; 
fMACO3(i)=fMACO3(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P134 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'MEO2 +  xMACR = 0.5*MACR + 2*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xMACR'; 
fMEO2(i)=fMEO2(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+0.5; fMEO2(i)=fMEO2(i)+1;fXC(i)=fXC(i)+2; 

%P135 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2C +  xMACR = 0.5*MACR + 2*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xMACR'; 
fRO2C(i)=fRO2C(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+0.5; fRO2C(i)=fRO2C(i)+1;fXC(i)=fXC(i)+2; 
 
%P136 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2XC +  xMACR = 0.5*MACR + 2*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xMACR'; 
fRO2XC(i)=fRO2XC(i)-1; fxMACR(i)=fxMACR(i)-1; fMACR(i)=fMACR(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+2;

%P132
i=i+1;
Rnames{i} = 'HO2 +  xMACR = 4*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xMACR'; 
fHO2(i)=fHO2(i)-1; fxMACR(i)=fxMACR(i)-1; fXC(i)=fXC(i)+4; fHO2(i)=fHO2(i)+1; 

%P141
i=i+1;
Rnames{i} = 'NO +  xMVK = MVK  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xMVK'; 
fNO(i)=fNO(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+1; fNO(i)=fNO(i)+1; 

%P143
i=i+1;
Rnames{i} = 'NO3 +  xMVK = MVK  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xMVK'; 
fNO3(i)=fNO3(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+1; fNO3(i)=fNO3(i)+1; 

%P147
i=i+1;
Rnames{i} = 'MECO3 +  xMVK = MVK  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xMVK'; 
fMECO3(i)=fMECO3(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P148
i=i+1;
Rnames{i} = 'RCO3 +  xMVK = MVK  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xMVK'; 
fRCO3(i)=fRCO3(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P149
i=i+1;
Rnames{i} = 'BZCO3 +  xMVK = MVK  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xMVK'; 
fBZCO3(i)=fBZCO3(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P150
i=i+1;
Rnames{i} = 'MACO3 +  xMVK = MVK  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xMVK'; 
fMACO3(i)=fMACO3(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P144 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'MEO2 +  xMVK = 0.5*MVK + 2*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xMVK'; 
fMEO2(i)=fMEO2(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+2;

%P145 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2C +  xMVK = 0.5*MVK + 2*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xMVK'; 
fRO2C(i)=fRO2C(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+2;

%P146 rate doubled and add 2*XC
i=i+1;
Rnames{i} = 'RO2XC +  xMVK = 0.5*MVK + 2*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xMVK'; 
fRO2XC(i)=fRO2XC(i)-1; fxMVK(i)=fxMVK(i)-1; fMVK(i)=fMVK(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+2;

%P142
i=i+1;
Rnames{i} = 'HO2 +  xMVK = 4*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xMVK'; 
fHO2(i)=fHO2(i)-1; fxMVK(i)=fxMVK(i)-1; fXC(i)=fXC(i)+4; fHO2(i)=fHO2(i)+1; 

%P151
i=i+1;
Rnames{i} = 'NO +  xIPRD = IPRD  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xIPRD'; 
fNO(i)=fNO(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+1; fNO(i)=fNO(i)+1; 

%P153
i=i+1;
Rnames{i} = 'NO3 +  xIPRD = IPRD  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xIPRD'; 
fNO3(i)=fNO3(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+1; fNO3(i)=fNO3(i)+1; 

%P157
i=i+1;
Rnames{i} = 'MECO3 +  xIPRD = IPRD  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xIPRD'; 
fMECO3(i)=fMECO3(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P158
i=i+1;
Rnames{i} = 'RCO3 +  xIPRD = IPRD  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xIPRD'; 
fRCO3(i)=fRCO3(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P159
i=i+1;
Rnames{i} = 'BZCO3 +  xIPRD = IPRD  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xIPRD'; 
fBZCO3(i)=fBZCO3(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P160
i=i+1;
Rnames{i} = 'MACO3 +  xIPRD = IPRD  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xIPRD'; 
fMACO3(i)=fMACO3(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P154 rate doubled and 2.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xIPRD = 0.5*IPRD + 2.5*XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xIPRD'; 
fMEO2(i)=fMEO2(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+2.5;

%P155 rate doubled and 2.5*XC
i=i+1;
Rnames{i} = 'RO2C +  xIPRD = 0.5*IPRD + 2.5*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xIPRD'; 
fRO2C(i)=fRO2C(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+2.5; 

%P156 rate doubled and 2.5*XC
i=i+1;
Rnames{i} = 'RO2XC +  xIPRD = 0.5*IPRD + 2.5*XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xIPRD'; 
fRO2XC(i)=fRO2XC(i)-1; fxIPRD(i)=fxIPRD(i)-1; fIPRD(i)=fIPRD(i)+0.5; fRO2XC(i)=fRO2XC(i)+1;fXC(i)=fXC(i)+2.5; 

%P152
i=i+1;
Rnames{i} = 'HO2 +  xIPRD = 5*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xIPRD'; 
fHO2(i)=fHO2(i)-1; fxIPRD(i)=fxIPRD(i)-1; fXC(i)=fXC(i)+5; fHO2(i)=fHO2(i)+1; 

%P161
i=i+1;
Rnames{i} = 'NO +  xRNO3 = RNO3  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xRNO3'; 
fNO(i)=fNO(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+1; fNO(i)=fNO(i)+1; 

%P163
i=i+1;
Rnames{i} = 'NO3 +  xRNO3 = RNO3  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xRNO3'; 
fNO3(i)=fNO3(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+1; fNO3(i)=fNO3(i)+1; 

%P167
i=i+1;
Rnames{i} = 'MECO3 +  xRNO3 = RNO3  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xRNO3'; 
fMECO3(i)=fMECO3(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P168
i=i+1;
Rnames{i} = 'RCO3 +  xRNO3 = RNO3  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xRNO3'; 
fRCO3(i)=fRCO3(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P169
i=i+1;
Rnames{i} = 'BZCO3 +  xRNO3 = RNO3  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xRNO3'; 
fBZCO3(i)=fBZCO3(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P170
i=i+1;
Rnames{i} = 'MACO3 +  xRNO3 = RNO3  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xRNO3'; 
fMACO3(i)=fMACO3(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P164 rate doubled and add 0.5XN and 3XC
i=i+1;
Rnames{i} = 'MEO2 +  xRNO3 = 0.5*RNO3 + 0.5*XN + 3*XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xRNO3'; 
fMEO2(i)=fMEO2(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXN(i)=fXN(i)+0.5;fXC(i)=fXC(i)+3;

%P165 rate doubled and add 0.5XN and 3XC
i=i+1;
Rnames{i} = 'RO2C + xRNO3 = 0.5*RNO3 + 0.5*XN + 3*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xRNO3'; 
fRO2C(i)=fRO2C(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXN(i)=fXN(i)+0.5;fXC(i)=fXC(i)+3;

%P166 rate doubled and add 0.5XN and 3XC
i=i+1;
Rnames{i} = 'RO2XC + xRNO3 = 0.5*RNO3 + 0.5*XN + 3*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xRNO3'; 
fRO2XC(i)=fRO2XC(i)-1; fxRNO3(i)=fxRNO3(i)-1; fRNO3(i)=fRNO3(i)+0.5; fRO2XC(i)=fRO2XC(i)+1;fXN(i)=fXN(i)+0.5;fXC(i)=fXC(i)+3;

%P162
i=i+1;
Rnames{i} = 'HO2 +  xRNO3 = 6*XC + XN  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xRNO3'; 
fHO2(i)=fHO2(i)-1; fxRNO3(i)=fxRNO3(i)-1; fXC(i)=fXC(i)+6; fXN(i)=fXN(i)+1; fHO2(i)=fHO2(i)+1; 

%PX161
i=i+1;
Rnames{i} = 'xMTNO3 + NO = NO + MTNO3';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'xMTNO3'; Gstr{i,2} = 'NO'; 
fxMTNO3(i)=fxMTNO3(i)-1; fNO(i)=fNO(i)-1; fNO(i)=fNO(i)+1; fMTNO3(i)=fMTNO3(i)+1; 

%PX163
i=i+1;
Rnames{i} = 'xMTNO3 + NO3 = NO3 + MTNO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xMTNO3'; 
fxMTNO3(i)=fxMTNO3(i)-1; fNO3(i)=fNO3(i)-1; fMTNO3(i)=fMTNO3(i)+1; fNO3(i)=fNO3(i)+1; 

%PX167
i=i+1;
Rnames{i} = 'xMTNO3 + MECO3 = MECO3 + MTNO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xMTNO3'; 
fMECO3(i)=fMECO3(i)-1; fxMTNO3(i)=fxMTNO3(i)-1; fMTNO3(i)=fMTNO3(i)+1; fMECO3(i)=fMECO3(i)+1; 

%PX168
i=i+1;
Rnames{i} = 'xMTNO3 + RCO3 = RCO3 + MTNO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xMTNO3'; 
fRCO3(i)=fRCO3(i)-1; fxMTNO3(i)=fxMTNO3(i)-1; fMTNO3(i)=fMTNO3(i)+1; fRCO3(i)=fRCO3(i)+1; 

%PX169
i=i+1;
Rnames{i} = 'BZCO3 +  xMTNO3 = MTNO3  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xMTNO3'; 
fBZCO3(i)=fBZCO3(i)-1; fxMTNO3(i)=fxMTNO3(i)-1; fMTNO3(i)=fMTNO3(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P170
i=i+1;
Rnames{i} = 'MACO3 +  xMTNO3 = MTNO3  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xMTNO3'; 
fMACO3(i)=fMACO3(i)-1; fxMTNO3(i)=fxMTNO3(i)-1; fMTNO3(i)=fMTNO3(i)+1; fMACO3(i)=fMACO3(i)+1; 

%PX164 rate doubled and add 0.5XN and 3XC
i=i+1;
Rnames{i} = 'xMTNO3 + MEO2 = MEO2 + 0.5*MTNO3 + 0.5*XN + 3*XC';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xMTNO3'; 
fMEO2(i)=fMEO2(i)-1; fxMTNO3(i)=fxMTNO3(i)-1; fMTNO3(i)=fMTNO3(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXN(i)=fXN(i)+0.5;fXC(i)=fXC(i)+3;

%PX165 rate doubled and add 0.5XN and 3XC
i=i+1;
Rnames{i} = 'RO2C +  xMTNO3 = 0.5*RNO3 + 0.5*XN + 3*XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xMTNO3'; 
fRO2C(i)=fRO2C(i)-1; fxMTNO3(i)=fxMTNO3(i)-1; fMTNO3(i)=fMTNO3(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXN(i)=fXN(i)+0.5;fXC(i)=fXC(i)+3;

%PX166 rate doubled and add 0.5XN and 3XC
i=i+1;
Rnames{i} = 'RO2XC +  xMTNO3 = 0.5*RNO3 + 0.5*XN + 3*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xMTNO3'; 
fRO2XC(i)=fRO2XC(i)-1; fxMTNO3(i)=fxMTNO3(i)-1; fMTNO3(i)=fMTNO3(i)+0.5; fRO2XC(i)=fRO2XC(i)+1;fXN(i)=fXN(i)+0.5;fXC(i)=fXC(i)+3;

%PX162
i=i+1;
Rnames{i} = 'HO2 +  xMTNO3 = 6*XC + XN  + HO2';
k(:,i) =   2.65e-13.*exp(1300./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xMTNO3'; 
fHO2(i)=fHO2(i)-1; fxMTNO3(i)=fxMTNO3(i)-1; fXC(i)=fXC(i)+6; fXN(i)=fXN(i)+1; fHO2(i)=fHO2(i)+1; 

%P201 
i=i+1;
Rnames{i} = 'NO +  zRNO3 = RNO3 + -1*XN  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'zRNO3'; 
fNO(i)=fNO(i)-1; fzRNO3(i)=fzRNO3(i)-1; fRNO3(i)=fRNO3(i)+1; fXN(i)=fXN(i)+-1; fNO(i)=fNO(i)+1; 

%P203
i=i+1;
Rnames{i} = 'NO3 +  zRNO3 = PRD2 + HO2  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'zRNO3'; 
fNO3(i)=fNO3(i)-1; fzRNO3(i)=fzRNO3(i)-1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1; fNO3(i)=fNO3(i)+1; 

%P207
i=i+1;
Rnames{i} = 'MECO3 +  zRNO3 = PRD2 + HO2  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'zRNO3'; 
fMECO3(i)=fMECO3(i)-1; fzRNO3(i)=fzRNO3(i)-1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1; fMECO3(i)=fMECO3(i)+1; 

%P208
i=i+1;
Rnames{i} = 'RCO3 +  zRNO3 = PRD2 + HO2  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'zRNO3'; 
fRCO3(i)=fRCO3(i)-1; fzRNO3(i)=fzRNO3(i)-1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1; fRCO3(i)=fRCO3(i)+1; 

%P209
i=i+1;
Rnames{i} = 'BZCO3 +  zRNO3 = PRD2 + HO2  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'zRNO3'; 
fBZCO3(i)=fBZCO3(i)-1; fzRNO3(i)=fzRNO3(i)-1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%P210
i=i+1;
Rnames{i} = 'MACO3 +  zRNO3 = PRD2 + HO2  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'zRNO3'; 
fMACO3(i)=fMACO3(i)-1; fzRNO3(i)=fzRNO3(i)-1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1; fMACO3(i)=fMACO3(i)+1; 

%P204 rate doubled and add 0.5*HO2 and 3*XC
i=i+1;
Rnames{i} = 'MEO2 +  zRNO3 = 0.5*PRD2 + 0.5*HO2 + 3*XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'zRNO3'; 
fMEO2(i)=fMEO2(i)-1; fzRNO3(i)=fzRNO3(i)-1; fPRD2(i)=fPRD2(i)+0.5; fHO2(i)=fHO2(i)+0.5; fMEO2(i)=fMEO2(i)+1;
fXC(i)=fXC(i)+3;

%P205 rate doubled and add 0.5*HO2 and 3*XC
i=i+1;
Rnames{i} = 'RO2C +  zRNO3 = 0.5*PRD2 + 0.5*HO2 + 3*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'zRNO3'; 
fRO2C(i)=fRO2C(i)-1; fzRNO3(i)=fzRNO3(i)-1; fPRD2(i)=fPRD2(i)+0.5; fHO2(i)=fHO2(i)+0.5; fRO2C(i)=fRO2C(i)+1; 
fXC(i)=fXC(i)+3;

%P206 rate doubled and add 0.5*HO2 and 3*XC
i=i+1;
Rnames{i} = 'RO2XC +  zRNO3 = 0.5*PRD2 + 0.5*HO2 + 3*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'zRNO3'; 
fRO2XC(i)=fRO2XC(i)-1; fzRNO3(i)=fzRNO3(i)-1; fPRD2(i)=fPRD2(i)+0.5; fHO2(i)=fHO2(i)+0.5; fRO2XC(i)=fRO2XC(i)+1;
fXC(i)=fXC(i)+3;

%P202
i=i+1;
Rnames{i} = 'HO2 +  zRNO3 = 6*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'zRNO3'; 
fHO2(i)=fHO2(i)-1; fzRNO3(i)=fzRNO3(i)-1; fXC(i)=fXC(i)+6; fHO2(i)=fHO2(i)+1; 

%P172
i=i+1;
Rnames{i} = 'HO2 +  yROOH = ROOH + -3*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'yROOH'; 
fHO2(i)=fHO2(i)-1; fyROOH(i)=fyROOH(i)-1; fROOH(i)=fROOH(i)+1; fXC(i)=fXC(i)+-3; fHO2(i)=fHO2(i)+1; 

%P174 rate doubled (changed to -2*XC)
i=i+1;
Rnames{i} = 'MEO2 +  yROOH = 0.5*MEK + -2*XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'yROOH'; 
fMEO2(i)=fMEO2(i)-1; fyROOH(i)=fyROOH(i)-1; fMEK(i)=fMEK(i)+10.5; fXC(i)=fXC(i)+-2; fMEO2(i)=fMEO2(i)+1; 

%P175 rate doubled (changed to -2*XC)
i=i+1;
Rnames{i} = 'RO2C +  yROOH = 0.5*MEK + -2*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'yROOH'; 
fRO2C(i)=fRO2C(i)-1; fyROOH(i)=fyROOH(i)-1; fMEK(i)=fMEK(i)+0.5; fXC(i)=fXC(i)+-2; fRO2C(i)=fRO2C(i)+1; 

%P176 rate doubled (changed to -2*XC)
i=i+1;
Rnames{i} = 'RO2XC +  yROOH = 0.5*MEK + -2*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'yROOH'; 
fRO2XC(i)=fRO2XC(i)-1; fyROOH(i)=fyROOH(i)-1; fMEK(i)=fMEK(i)+0.5; fXC(i)=fXC(i)+-2; fRO2XC(i)=fRO2XC(i)+1; 

%P171
i=i+1;
Rnames{i} = 'NO +  yROOH =   + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'yROOH'; 
fNO(i)=fNO(i)-1; fyROOH(i)=fyROOH(i)-1; fNO(i)=fNO(i)+1; 

%P173
i=i+1;
Rnames{i} = 'NO3 +  yROOH =   + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'yROOH'; 
fNO3(i)=fNO3(i)-1; fyROOH(i)=fyROOH(i)-1; fNO3(i)=fNO3(i)+1; 

%P177
i=i+1;
Rnames{i} = 'MECO3 +  yROOH =   + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'yROOH'; 
fMECO3(i)=fMECO3(i)-1; fyROOH(i)=fyROOH(i)-1; fMECO3(i)=fMECO3(i)+1; 

%P178
i=i+1;
Rnames{i} = 'RCO3 +  yROOH =   + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'yROOH'; 
fRCO3(i)=fRCO3(i)-1; fyROOH(i)=fyROOH(i)-1; fRCO3(i)=fRCO3(i)+1; 

%P179
i=i+1;
Rnames{i} = 'BZCO3 +  yROOH =   + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'yROOH'; 
fBZCO3(i)=fBZCO3(i)-1; fyROOH(i)=fyROOH(i)-1; fBZCO3(i)=fBZCO3(i)+1; 

%P180
i=i+1;
Rnames{i} = 'MACO3 +  yROOH =   + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'yROOH'; 
fMACO3(i)=fMACO3(i)-1; fyROOH(i)=fyROOH(i)-1; fMACO3(i)=fMACO3(i)+1; 

%P182
i=i+1;
Rnames{i} = 'HO2 +  yR6OOH = R6OOH + -6*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'yR6OOH'; 
fHO2(i)=fHO2(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fR6OOH(i)=fR6OOH(i)+1; fXC(i)=fXC(i)+-6; fHO2(i)=fHO2(i)+1; 

%P184 rate doubled 
i=i+1;
Rnames{i} = 'MEO2 +  yR6OOH = 0.5*PRD2 - 3*XC + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'yR6OOH'; 
fMEO2(i)=fMEO2(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+-3; fMEO2(i)=fMEO2(i)+1; 

%P185 rate doubled
i=i+1;
Rnames{i} = 'RO2C +  yR6OOH = 0.5*PRD2 - 3*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'yR6OOH'; 
fRO2C(i)=fRO2C(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+-3; fRO2C(i)=fRO2C(i)+1; 

%P186 rate doubled
i=i+1;
Rnames{i} = 'RO2XC +  yR6OOH = 0.5*PRD2 - 3*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'yR6OOH'; 
fRO2XC(i)=fRO2XC(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+-3; fRO2XC(i)=fRO2XC(i)+1; 

%P181
i=i+1;
Rnames{i} = 'NO +  yR6OOH =   + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'yR6OOH'; 
fNO(i)=fNO(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fNO(i)=fNO(i)+1; 

%P183
i=i+1;
Rnames{i} = 'NO3 +  yR6OOH =   + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'yR6OOH'; 
fNO3(i)=fNO3(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fNO3(i)=fNO3(i)+1; 

%P187
i=i+1;
Rnames{i} = 'MECO3 +  yR6OOH =   + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'yR6OOH'; 
fMECO3(i)=fMECO3(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fMECO3(i)=fMECO3(i)+1; 

%P188
i=i+1;
Rnames{i} = 'RCO3 +  yR6OOH =   + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'yR6OOH'; 
fRCO3(i)=fRCO3(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fRCO3(i)=fRCO3(i)+1; 

%P189
i=i+1;
Rnames{i} = 'BZCO3 +  yR6OOH =   + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'yR6OOH'; 
fBZCO3(i)=fBZCO3(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fBZCO3(i)=fBZCO3(i)+1; 

%P190
i=i+1;
Rnames{i} = 'MACO3 +  yR6OOH =   + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'yR6OOH'; 
fMACO3(i)=fMACO3(i)-1; fyR6OOH(i)=fyR6OOH(i)-1; fMACO3(i)=fMACO3(i)+1; 

%P192
i=i+1;
Rnames{i} = 'HO2 +  yRAOOH = RAOOH + -8*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'yRAOOH'; 
fHO2(i)=fHO2(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fRAOOH(i)=fRAOOH(i)+1; fXC(i)=fXC(i)+-8; fHO2(i)=fHO2(i)+1; 

%P194 rate doubled 
i=i+1;
Rnames{i} = 'MEO2 +  yRAOOH = 0.5*PRD2 - 3*XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'yRAOOH'; 
fMEO2(i)=fMEO2(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+-3; fMEO2(i)=fMEO2(i)+1; 

%P195 rate doubled
i=i+1;
Rnames{i} = 'RO2C +  yRAOOH = 0.5*PRD2 - 3*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'yRAOOH'; 
fRO2C(i)=fRO2C(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+-3; fRO2C(i)=fRO2C(i)+1; 

%P196 rate doubled
i=i+1;
Rnames{i} = 'RO2XC +  yRAOOH = 0.5*PRD2 - 3*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'yRAOOH'; 
fRO2XC(i)=fRO2XC(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+-3; fRO2XC(i)=fRO2XC(i)+1; 

%P191
i=i+1;
Rnames{i} = 'NO +  yRAOOH =   + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'yRAOOH'; 
fNO(i)=fNO(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fNO(i)=fNO(i)+1; 

%P193
i=i+1;
Rnames{i} = 'NO3 +  yRAOOH =   + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'yRAOOH'; 
fNO3(i)=fNO3(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fNO3(i)=fNO3(i)+1; 

%P197
i=i+1;
Rnames{i} = 'MECO3 +  yRAOOH =   + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'yRAOOH'; 
fMECO3(i)=fMECO3(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fMECO3(i)=fMECO3(i)+1; 

%P198
i=i+1;
Rnames{i} = 'RCO3 +  yRAOOH =   + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'yRAOOH'; 
fRCO3(i)=fRCO3(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fRCO3(i)=fRCO3(i)+1; 

%P199
i=i+1;
Rnames{i} = 'BZCO3 +  yRAOOH =   + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'yRAOOH'; 
fBZCO3(i)=fBZCO3(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fBZCO3(i)=fBZCO3(i)+1; 

%P200
i=i+1;
Rnames{i} = 'MACO3 +  yRAOOH =   + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'yRAOOH'; 
fMACO3(i)=fMACO3(i)-1; fyRAOOH(i)=fyRAOOH(i)-1; fMACO3(i)=fMACO3(i)+1; 

%PZ202
i=i+1;
Rnames{i} = 'zMTNO3 + HO2 = HO2 + 6*XC ';
k(:,i) =  2.65e-13.*exp(1300./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'zMTNO3'; 
fHO2(i)=fHO2(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fXC(i)=fXC(i)+6; fHO2(i)=fHO2(i)+1; 

%PZ204 new added 
i=i+1;
Rnames{i} = 'zMTNO3 + MEO2 = MEO2 + 0.5*PRD2 + 0.5*HO2 + 3*XC';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'zMTNO3'; 
fMEO2(i)=fMEO2(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+3; fMEO2(i)=fMEO2(i)+1;fHO2(i)=fHO2(i)+0.5; 

%PZ205 new added
i=i+1;
Rnames{i} = 'zMTNO3 + RO2C = RO2C + 0.5*PRD2 + 0.5*HO2 + 3*XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'zMTNO3'; 
fRO2C(i)=fRO2C(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+3; fRO2C(i)=fRO2C(i)+1; fHO2(i)=fHO2(i)+0.5;

%PZ206 new added
i=i+1;
Rnames{i} = 'zMTNO3 + RO2XC = RO2XC + 0.5*PRD2 + 0.5*HO2 + 3*XC ';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'zMTNO3'; 
fRO2XC(i)=fRO2XC(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)+3; fRO2XC(i)=fRO2XC(i)+1;fHO2(i)=fHO2(i)+0.5; 

%PZ201
i=i+1;
Rnames{i} = 'zMTNO3 + NO = NO + MTNO3 - 1*XN';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'zMTNO3'; 
fNO(i)=fNO(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fNO(i)=fNO(i)+1; fMTNO3(i)=fMTNO3(i)+1; fXN(i)=fXN(i)-1; 

%PZ203
i=i+1;
Rnames{i} = 'zMTNO3 + NO3 = NO3 + PRD2 + HO2';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'zMTNO3'; 
fNO3(i)=fNO3(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fNO3(i)=fNO3(i)+1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1; 

%PZ207
i=i+1;
Rnames{i} = 'zMTNO3 + MECO3 = MECO3 + PRD2 + HO2';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'zMTNO3'; 
fMECO3(i)=fMECO3(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fMECO3(i)=fMECO3(i)+1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1;

%PZ208
i=i+1;
Rnames{i} = 'zMTNO3 + RCO3 = RCO3 + PRD2 + HO2';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'zMTNO3'; 
fRCO3(i)=fRCO3(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fRCO3(i)=fRCO3(i)+1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1;

%PZ209
i=i+1;
Rnames{i} = 'zMTNO3 + BZCO3 = BZCO3 + PRD2 + HO2';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'zMTNO3'; 
fBZCO3(i)=fBZCO3(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fBZCO3(i)=fBZCO3(i)+1;fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1; 

%PZ210a
i=i+1;
Rnames{i} = 'zMTNO3 + MACO3 = MACO3 + PRD2 + HO2';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'zMTNO3'; 
fMACO3(i)=fMACO3(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fMACO3(i)=fMACO3(i)+1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1;

%PZ210b
i=i+1;
Rnames{i} = 'zMTNO3 + IMACO3 = IMACO3 + PRD2 + HO2';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'zMTNO3'; 
fIMACO3(i)=fIMACO3(i)-1; fzMTNO3(i)=fzMTNO3(i)-1; fIMACO3(i)=fIMACO3(i)+1; fPRD2(i)=fPRD2(i)+1; fHO2(i)=fHO2(i)+1;

%P212
i=i+1;
Rnames{i} = 'xHOCCHO + HO2 = HO2 + 2*XC ';
k(:,i) =  3.8e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xHOCCHO'; 
fHO2(i)=fHO2(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fXC(i)=fXC(i)+2; fHO2(i)=fHO2(i)+1; 

%P214  
i=i+1;
Rnames{i} = 'xHOCCHO + MEO2 = MEO2 + 0.5*HOCCHO + XC ';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xHOCCHO'; 
fMEO2(i)=fMEO2(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1; fHOCCHO(i)=fHOCCHO(i)+0.5;

%P215 
i=i+1;
Rnames{i} = 'xHOCCHO + RO2C = RO2C + 0.5*HOCCHO + XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xHOCCHO'; 
fRO2C(i)=fRO2C(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fXC(i)=fXC(i)+1; fRO2C(i)=fRO2C(i)+1; fHOCCHO(i)=fHOCCHO(i)+0.5;

%P216
i=i+1;
Rnames{i} = 'xHOCCHO + RO2XC = RO2XC + 0.5*HOCCHO + XC ';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xHOCCHO'; 
fRO2XC(i)=fRO2XC(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1;  fXC(i)=fXC(i)+1; fRO2XC(i)=fRO2XC(i)+1;fHOCCHO(i)=fHOCCHO(i)+0.5;

%P211
i=i+1;
Rnames{i} = 'xHOCCHO + NO = NO + HOCCHO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xHOCCHO'; 
fNO(i)=fNO(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fNO(i)=fNO(i)+1; fHOCCHO(i)=fHOCCHO(i)+1; 

%P213
i=i+1;
Rnames{i} = 'xHOCCHO + NO3 = NO3 + HOCCHO';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xHOCCHO'; 
fNO3(i)=fNO3(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fNO3(i)=fNO3(i)+1; fHOCCHO(i)=fHOCCHO(i)+1; 

%P217
i=i+1;
Rnames{i} = 'xHOCCHO + MECO3 = MECO3 + HOCCHO';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xHOCCHO'; 
fMECO3(i)=fMECO3(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fMECO3(i)=fMECO3(i)+1; fHOCCHO(i)=fHOCCHO(i)+1;

%P218
i=i+1;
Rnames{i} = 'xHOCCHO + RCO3 = RCO3 + HOCCHO';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xHOCCHO'; 
fRCO3(i)=fRCO3(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fRCO3(i)=fRCO3(i)+1;  fHOCCHO(i)=fHOCCHO(i)+1;

%P219
i=i+1;
Rnames{i} = 'xHOCCHO + BZCO3 = BZCO3 + HOCCHO';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xHOCCHO'; 
fBZCO3(i)=fBZCO3(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fBZCO3(i)=fBZCO3(i)+1; fHOCCHO(i)=fHOCCHO(i)+1; 

%P220
i=i+1;
Rnames{i} = 'xHOCCHO + MACO3 = MACO3 + HOCCHO';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xHOCCHO'; 
fMACO3(i)=fMACO3(i)-1; fxHOCCHO(i)=fxHOCCHO(i)-1; fMACO3(i)=fMACO3(i)+1;  fHOCCHO(i)=fHOCCHO(i)+1;

%P222
i=i+1;
Rnames{i} = 'xACROLEIN + HO2 = HO2 + 3*XC ';
k(:,i) =  3.8e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xACROLEIN'; 
fHO2(i)=fHO2(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fXC(i)=fXC(i)+3; fHO2(i)=fHO2(i)+1; 

%P224  
i=i+1;
Rnames{i} = 'xACROLEIN + MEO2 = MEO2 + 0.5*ACROLEIN + 1.5*XC';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xACROLEIN'; 
fMEO2(i)=fMEO2(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1.5; fACROLEIN(i)=fACROLEIN(i)+0.5;

%P225 
i=i+1;
Rnames{i} = 'xACROLEIN + RO2C = RO2C + 0.5*ACROLEIN + 1.5*XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xACROLEIN'; 
fRO2C(i)=fRO2C(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fXC(i)=fXC(i)+1.5; fRO2C(i)=fRO2C(i)+1; fACROLEIN(i)=fACROLEIN(i)+0.5;

%P226
i=i+1;
Rnames{i} = 'xACROLEIN + RO2XC = RO2XC + 0.5*ACROLEIN + 1.5*XC ';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xACROLEIN'; 
fRO2XC(i)=fRO2XC(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1;  fXC(i)=fXC(i)+1.5; fRO2XC(i)=fRO2XC(i)+1;fACROLEIN(i)=fACROLEIN(i)+0.5;

%P221
i=i+1;
Rnames{i} = 'xACROLEIN + NO = NO + ACROLEIN';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xACROLEIN'; 
fNO(i)=fNO(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fNO(i)=fNO(i)+1; fACROLEIN(i)=fACROLEIN(i)+1; 

%P223
i=i+1;
Rnames{i} = 'xACROLEIN + NO3 = NO3 + ACROLEIN';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xACROLEIN'; 
fNO3(i)=fNO3(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fNO3(i)=fNO3(i)+1; fACROLEIN(i)=fACROLEIN(i)+1; 

%P227
i=i+1;
Rnames{i} = 'xACROLEIN + MECO3 = MECO3 + ACROLEIN';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xACROLEIN'; 
fMECO3(i)=fMECO3(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fMECO3(i)=fMECO3(i)+1; fACROLEIN(i)=fACROLEIN(i)+1;

%P228
i=i+1;
Rnames{i} = 'xACROLEIN + RCO3 = RCO3 + ACROLEIN';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xACROLEIN'; 
fRCO3(i)=fRCO3(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fRCO3(i)=fRCO3(i)+1;  fACROLEIN(i)=fACROLEIN(i)+1;

%P229
i=i+1;
Rnames{i} = 'xACROLEIN + BZCO3 = BZCO3 + ACROLEIN';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xACROLEIN'; 
fBZCO3(i)=fBZCO3(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fBZCO3(i)=fBZCO3(i)+1; fACROLEIN(i)=fACROLEIN(i)+1; 

%P230
i=i+1;
Rnames{i} = 'xACROLEIN + MACO3 = MACO3 + ACROLEIN';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xACROLEIN'; 
fMACO3(i)=fMACO3(i)-1; fxACROLEIN(i)=fxACROLEIN(i)-1; fMACO3(i)=fMACO3(i)+1;  fACROLEIN(i)=fACROLEIN(i)+1;

%CP29
i=i+1;
Rnames{i} = 'NO +  xCL = CL  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xCL'; 
fNO(i)=fNO(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+1; fNO(i)=fNO(i)+1; 

%CP31
i=i+1;
Rnames{i} = 'NO3 +  xCL = CL  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xCL'; 
fNO3(i)=fNO3(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+1; fNO3(i)=fNO3(i)+1; 

%CP35
i=i+1;
Rnames{i} = 'MECO3 +  xCL = CL  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xCL'; 
fMECO3(i)=fMECO3(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+1; fMECO3(i)=fMECO3(i)+1; 

%CP36
i=i+1;
Rnames{i} = 'RCO3 +  xCL = CL  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xCL'; 
fRCO3(i)=fRCO3(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+1; fRCO3(i)=fRCO3(i)+1; 

%CP37
i=i+1;
Rnames{i} = 'BZCO3 +  xCL = CL  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xCL'; 
fBZCO3(i)=fBZCO3(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%CP38
i=i+1;
Rnames{i} = 'MACO3 +  xCL = CL  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xCL'; 
fMACO3(i)=fMACO3(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+1; fMACO3(i)=fMACO3(i)+1; 

%CP32 rate doubled and 0.5*CL
i=i+1;
Rnames{i} = 'MEO2 +  xCL = 0.5*CL  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xCL'; 
fMEO2(i)=fMEO2(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+0.5; fMEO2(i)=fMEO2(i)+1; 

%CP33 rate doubled and 0.5*CL
i=i+1;
Rnames{i} = 'RO2C +  xCL =0.5*CL  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xCL'; 
fRO2C(i)=fRO2C(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+0.5; fRO2C(i)=fRO2C(i)+1; 

%CP34 rate doubled and 0.5*CL
i=i+1;
Rnames{i} = 'RO2XC +  xCL = 0.5*CL  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xCL'; 
fRO2XC(i)=fRO2XC(i)-1; fxCL(i)=fxCL(i)-1; fCL(i)=fCL(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; 

%CP30
i=i+1;
Rnames{i} = 'HO2 +  xCL =   + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xCL'; 
fHO2(i)=fHO2(i)-1; fxCL(i)=fxCL(i)-1; fHO2(i)=fHO2(i)+1; 

%CP39
i=i+1;
Rnames{i} = 'NO +  xCLCCHO = CLCCHO  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xCLCCHO'; 
fNO(i)=fNO(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+1; fNO(i)=fNO(i)+1; 

%CP41
i=i+1;
Rnames{i} = 'NO3 +  xCLCCHO = CLCCHO  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xCLCCHO'; 
fNO3(i)=fNO3(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+1; fNO3(i)=fNO3(i)+1; 

%CP45
i=i+1;
Rnames{i} = 'MECO3 +  xCLCCHO = CLCCHO  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xCLCCHO'; 
fMECO3(i)=fMECO3(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%CP46
i=i+1;
Rnames{i} = 'RCO3 +  xCLCCHO = CLCCHO  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xCLCCHO'; 
fRCO3(i)=fRCO3(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+1; fRCO3(i)=fRCO3(i)+1; 

%CP47
i=i+1;
Rnames{i} = 'BZCO3 +  xCLCCHO = CLCCHO  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xCLCCHO'; 
fBZCO3(i)=fBZCO3(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%CP48
i=i+1;
Rnames{i} = 'MACO3 +  xCLCCHO = CLCCHO  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xCLCCHO'; 
fMACO3(i)=fMACO3(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+1; fMACO3(i)=fMACO3(i)+1; 

%CP42 rate doubled and 0.5*CLCCHO + XC
i=i+1;
Rnames{i} = 'MEO2 +  xCLCCHO = 0.5*CLCCHO + XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xCLCCHO'; 
fMEO2(i)=fMEO2(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1; 

%CP43 rate doubled and 0.5*CLCCHO + XC
i=i+1;
Rnames{i} = 'RO2C +  xCLCCHO = 0.5*CLCCHO + XC + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xCLCCHO'; 
fRO2C(i)=fRO2C(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+0.5; fRO2C(i)=fRO2C(i)+1;fXC(i)=fXC(i)+1; 

%CP44 rate doubled and 0.5*CLCCHO + XC
i=i+1;
Rnames{i} = 'RO2XC +  xCLCCHO = 0.5*CLCCHO + XC + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xCLCCHO'; 
fRO2XC(i)=fRO2XC(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fCLCCHO(i)=fCLCCHO(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+1;

%CP40
i=i+1;
Rnames{i} = 'HO2 +  xCLCCHO = 2*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xCLCCHO'; 
fHO2(i)=fHO2(i)-1; fxCLCCHO(i)=fxCLCCHO(i)-1; fXC(i)=fXC(i)+2; fHO2(i)=fHO2(i)+1; 

%CP49
i=i+1;
Rnames{i} = 'NO +  xCLACET = CLACET  + NO';
k(:,i) =  2.60e-12.*exp(380./ T);
Gstr{i,1} = 'NO'; Gstr{i,2} = 'xCLACET'; 
fNO(i)=fNO(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+1; fNO(i)=fNO(i)+1; 

%CP51
i=i+1;
Rnames{i} = 'NO3 +  xCLACET = CLACET  + NO3';
k(:,i) =  2.30e-12;
Gstr{i,1} = 'NO3'; Gstr{i,2} = 'xCLACET'; 
fNO3(i)=fNO3(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+1; fNO3(i)=fNO3(i)+1; 

%CP55
i=i+1;
Rnames{i} = 'MECO3 +  xCLACET = CLACET  + MECO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MECO3'; Gstr{i,2} = 'xCLACET'; 
fMECO3(i)=fMECO3(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+1; fMECO3(i)=fMECO3(i)+1; 

%CP56
i=i+1;
Rnames{i} = 'RCO3 +  xCLACET = CLACET  + RCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'RCO3'; Gstr{i,2} = 'xCLACET'; 
fRCO3(i)=fRCO3(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+1; fRCO3(i)=fRCO3(i)+1; 

%CP57
i=i+1;
Rnames{i} = 'BZCO3 +  xCLACET = CLACET  + BZCO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'BZCO3'; Gstr{i,2} = 'xCLACET'; 
fBZCO3(i)=fBZCO3(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+1; fBZCO3(i)=fBZCO3(i)+1; 

%CP58
i=i+1;
Rnames{i} = 'MACO3 +  xCLACET = CLACET  + MACO3';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'MACO3'; Gstr{i,2} = 'xCLACET'; 
fMACO3(i)=fMACO3(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+1; fMACO3(i)=fMACO3(i)+1; 

%CP52 rate doubled and 0.5*CLACET + 1.5*XC
i=i+1;
Rnames{i} = 'MEO2 +  xCLACET = 0.5*CLACET + 1.5*XC  + MEO2';
k(:,i) =  2.00e-13;
Gstr{i,1} = 'MEO2'; Gstr{i,2} = 'xCLACET'; 
fMEO2(i)=fMEO2(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+0.5; fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+1.5; 

%CP53
i=i+1;
Rnames{i} = 'RO2C +  xCLACET = 0.5*CLACET + 1.5*XC  + RO2C';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2C'; Gstr{i,2} = 'xCLACET'; 
fRO2C(i)=fRO2C(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+0.5; fRO2C(i)=fRO2C(i)+1; fXC(i)=fXC(i)+1.5; 

%CP54
i=i+1;
Rnames{i} = 'RO2XC +  xCLACET = 0.5*CLACET + 1.5*XC  + RO2XC';
k(:,i) =  3.50e-14;
Gstr{i,1} = 'RO2XC'; Gstr{i,2} = 'xCLACET'; 
fRO2XC(i)=fRO2XC(i)-1; fxCLACET(i)=fxCLACET(i)-1; fCLACET(i)=fCLACET(i)+0.5; fRO2XC(i)=fRO2XC(i)+1; fXC(i)=fXC(i)+1.5; 

%CP50
i=i+1;
Rnames{i} = 'HO2 +  xCLACET = 3*XC  + HO2';
k(:,i) =  3.80e-13.*exp(900./ T);
Gstr{i,1} = 'HO2'; Gstr{i,2} = 'xCLACET'; 
fHO2(i)=fHO2(i)-1; fxCLACET(i)=fxCLACET(i)-1; fXC(i)=fXC(i)+3; fHO2(i)=fHO2(i)+1; 

%AE51 new added
i=i+1;
Rnames{i} = 'BENZRO2 + NO = NO + 0.034*SVAVB2 + 0.392*SVAVB4';
k(:,i) =  2.6e-12.*exp(380./ T);
Gstr{i,1} = 'BENZRO2'; Gstr{i,2} = 'NO'; 
fBENZRO2(i)=fBENZRO2(i)-1; fNO(i)=fNO(i)-1; fNO(i)=fNO(i)+1; fSVAVB2(i)=fSVAVB2(i)+0.034; fSVAVB4(i)=fSVAVB4(i)+0.392; 

%AE52 new added
i=i+1;
Rnames{i} = 'BENZRO2 + HO2 = HO2 + 0.146*SVAVB1';
k(:,i) =  3.8e-13.*exp(900./ T);
Gstr{i,1} = 'BENZRO2'; Gstr{i,2} = 'HO2'; 
fBENZRO2(i)=fBENZRO2(i)-1; fHO2(i)=fHO2(i)-1; fHO2(i)=fHO2(i)+1; fSVAVB1(i)=fSVAVB1(i)+0.146; 

%AE53 new added
i=i+1;
Rnames{i} = 'XYLRO2 + NO = NO + 0.015*SVAVB2 + 0.023*SVAVB3 + 0.06*SVAVB4';
k(:,i) =  2.6e-12.*exp(380./ T);
Gstr{i,1} = 'XYLRO2'; Gstr{i,2} = 'NO'; 
fXYLRO2(i)=fXYLRO2(i)-1; fNO(i)=fNO(i)-1; fNO(i)=fNO(i)+1; fSVAVB2(i)=fSVAVB2(i)+0.015; fSVAVB4(i)=fSVAVB4(i)+0.06;
fSVAVB3(i)=fSVAVB3(i)+0.023;

%AE54 new added
i=i+1;
Rnames{i} = 'XYLRO2 + HO2 = HO2 + 0.193*SVAVB1';
k(:,i) =  3.8e-13.*exp(900./ T);
Gstr{i,1} = 'XYLRO2'; Gstr{i,2} = 'HO2'; 
fXYLRO2(i)=fXYLRO2(i)-1; fHO2(i)=fHO2(i)-1; fHO2(i)=fHO2(i)+1; fSVAVB1(i)=fSVAVB1(i)+0.193; 

%AE55 new added
i=i+1;
Rnames{i} = 'TOLRO2 + NO = NO + 0.016*SVAVB2 + 0.051*SVAVB3 + 0.047*SVAVB4';
k(:,i) =  2.6e-12.*exp(380./ T);
Gstr{i,1} = 'TOLRO2'; Gstr{i,2} = 'NO'; 
fTOLRO2(i)=fTOLRO2(i)-1; fNO(i)=fNO(i)-1; fNO(i)=fNO(i)+1; fSVAVB2(i)=fSVAVB2(i)+0.016; fSVAVB4(i)=fSVAVB4(i)+0.047;
fSVAVB3(i)=fSVAVB3(i)+0.051;

%AE56 new added
i=i+1;
Rnames{i} = 'TOLRO2 + HO2 = HO2 + 0.14*SVAVB1 ';
k(:,i) =  3.8e-13.*exp(900./ T);
Gstr{i,1} = 'TOLRO2'; Gstr{i,2} = 'HO2'; 
fTOLRO2(i)=fTOLRO2(i)-1; fHO2(i)=fHO2(i)-1; fHO2(i)=fHO2(i)+1; fSVAVB1(i)=fSVAVB1(i)+0.14;

%AE57 new added
i=i+1;
Rnames{i} = 'PAHRO2 + NO = NO + 0.028*SVAVB2 + 0.225*SVAVB3 + 0.191*SVAVB4 ';
k(:,i) =  2.6e-12.*exp(380./ T);
Gstr{i,1} = 'PAHRO2'; Gstr{i,2} = 'NO'; 
fPAHRO2(i)=fPAHRO2(i)-1; fNO(i)=fNO(i)-1; fNO(i)=fNO(i)+1; fSVAVB2(i)=fSVAVB2(i)+0.028; fSVAVB4(i)=fSVAVB4(i)+0.191;
fSVAVB3(i)=fSVAVB3(i)+0.225;

%AE58 new added
i=i+1;
Rnames{i} = 'PAHRO2 + HO2 = HO2 + 0.473*SVAVB1 ';
k(:,i) =  3.8e-13.*exp(900./ T);
Gstr{i,1} = 'PAHRO2'; Gstr{i,2} = 'HO2'; 
fPAHRO2(i)=fPAHRO2(i)-1; fHO2(i)=fHO2(i)-1; fHO2(i)=fHO2(i)+1; fSVAVB1(i)=fSVAVB1(i)+0.473;

%BT01 new added
i=i+1;
Rnames{i} = 'PROPENE + OH = 0.984*xHO2 + 0.984*RO2C + 0.016*RO2XC + 0.016*zRNO3 + 0.984*xHCHO + 0.984*xCCHO + yROOH - 0.048*XC';
k(:,i) = 4.85e-12.*exp(504./ T);
Gstr{i,1} = 'PROPENE'; Gstr{i,2} = 'OH'; 
fPROPENE(i)=fPROPENE(i)-1;fOH(i)=fOH(i)-1;fxHO2(i)=fxHO2(i)+0.984;fRO2C(i)=fRO2C(i)+0.984;fRO2XC(i)=fRO2XC(i)+0.016;
fzRNO3(i)=fzRNO3(i)+0.016;fxHCHO(i)=fxHCHO(i)+0.984;fxCCHO(i)=fxCCHO(i)+0.984;
fyROOH(i)=fyROOH(i)+1;fXC(i)=fXC(i)-0.048;

%BT02 new added
i=i+1;
Rnames{i} = 'PROPENE + O3 = 0.165*HO2 + 0.35*OH + 0.355*MEO2 + 0.525*CO + 0.215*CO2 + 0.5*HCHO + 0.5*CCHO + 0.185*FACD + 0.075*CCOOH + 0.07*XC';
k(:,i) = 5.51e-15.*exp(-1878./ T);
Gstr{i,1} = 'PROPENE'; Gstr{i,2} = 'O3'; 
fPROPENE(i)=fPROPENE(i)-1;fO3(i)=fO3(i)-1;fHO2(i)=fHO2(i)+0.165;fOH(i)=fOH(i)+0.35;fMEO2(i)=fMEO2(i)+0.355;
fCO(i)=fCO(i)+0.525;fCO2(i)=fCO2(i)+0.215;fCCHO(i)=fCCHO(i)+0.5;fHCHO(i)=fHCHO(i)+0.5;fFACD(i)=fFACD(i)+0.185;
fCCOOH(i)=fCCOOH(i)+0.075;fXC(i)=fXC(i)+0.07;

%BT03 new added
i=i+1;
Rnames{i} = 'PROPENE + NO3 = 0.949*xHO2 + 0.949*RO2C + 0.051*RO2XC + 0.051*zRNO3 + yROOH + XN + 2.694*XC';
k(:,i) = 4.59e-13.*exp(-1156./ T);
Gstr{i,1} = 'PROPENE'; Gstr{i,2} = 'NO3'; 
fPROPENE(i)=fPROPENE(i)-1;fNO3(i)=fNO3(i)-1;fxHO2(i)=fxHO2(i)+0.949;fRO2C(i)=fRO2C(i)+0.949;fzRNO3(i)=fzRNO3(i)+0.051;
fyROOH(i)=fyROOH(i)+1;fXC(i)=fXC(i)+2.694;fXN(i)=fXN(i)+1;

%BT04 new added
i=i+1;
Rnames{i} = 'PROPENE + O3P = 0.45*RCHO + 0.55*MEK - 0.55*XC';
k(:,i) = 1.02e-11.*exp(280./ T);
Gstr{i,1} = 'PROPENE'; Gstr{i,2} = 'O3P'; 
fPROPENE(i)=fPROPENE(i)-1;fO3P(i)=fO3P(i)-1;fRCHO(i)=fRCHO(i)+0.45;fMEK(i)=fMEK(i)+0.55;fXC(i)=fXC(i)-0.55;

%BT05 new added
i=i+1;
Rnames{i} = 'BUTADIENE13 + OH = 0.951*xHO2 + 1.189*RO2C + 0.049*RO2XC + 0.049*zRNO3 + 0.708*xHCHO + 0.58*xACROLEIN + 0.471*xIPRD + yROOH - 0.797*XC';
k(:,i) = 1.48e-11.*exp(448./ T);
Gstr{i,1} = 'BUTADIENE13'; Gstr{i,2} = 'OH'; 
fBUTADIENE13(i)=fBUTADIENE13(i)-1;fOH(i)=fOH(i)-1;fxHO2(i)=fxHO2(i)+0.951;fRO2C(i)=fRO2C(i)+1.189;fzRNO3(i)=fzRNO3(i)+0.049;
fyROOH(i)=fyROOH(i)+1;fXC(i)=fXC(i)-0.797;fxHCHO(i)=fxHCHO(i)+0.708;fRO2XC(i)=fRO2XC(i)+0.049;fxACROLEIN(i)=fxACROLEIN(i)+0.58;
fxIPRD(i)=fxIPRD(i)+0.471;

%BT06 new added
i=i+1;
Rnames{i} = 'BUTADIENE13 + O3 = 0.08*HO2 + 0.08*OH + 0.255*CO + 0.185*CO2 + 0.5*HCHO + 0.185*FACD + 0.5*ACROLEIN + 0.375*MVK + 0.125*PRD2 - 0.875*XC';
k(:,i) = 1.34e-14.*exp(-2283./ T);
Gstr{i,1} = 'BUTADIENE13'; Gstr{i,2} = 'O3'; 
fBUTADIENE13(i)=fBUTADIENE13(i)-1;fO3(i)=fO3(i)-1;fHO2(i)=fHO2(i)+0.08;fOH(i)=fOH(i)+0.08;fCO(i)=fCO(i)+0.255;
fCO2(i)=fCO2(i)+0.185;fHCHO(i)=fHCHO(i)+0.5;fFACD(i)=fFACD(i)+0.185;fACROLEIN(i)=fACROLEIN(i)+0.5;fMVK(i)=fMVK(i)+0.375;
fPRD2(i)=fPRD2(i)+0.125;fXC(i)=fXC(i)-0.875;

%BT07 new added
i=i+1;
Rnames{i} = 'BUTADIENE13 + NO3 = 0.815*xHO2 + 0.12*xNO2 + 1.055*RO2C + 0.065*RO2XC + 0.065*zRNO3 + 0.115*xHCHO + 0.46*xMVK + 0.12*xIPRD + 0.355*xRNO3 + yROOH + 0.525*XN - 1.075*XC';
k(:,i) = 1e-13;
Gstr{i,1} = 'BUTADIENE13'; Gstr{i,2} = 'NO3'; 
fBUTADIENE13(i)=fBUTADIENE13(i)-1;fNO3(i)=fNO3(i)-1;fxHO2(i)=fxHO2(i)+0.815;fRO2C(i)=fRO2C(i)+1.055;fzRNO3(i)=fzRNO3(i)+0.065;
fxHCHO(i)=fxHCHO(i)+0.115;fxMVK(i)=fxMVK(i)+0.46;fxIPRD(i)=fxIPRD(i)+0.12;fxRNO3(i)=fxRNO3(i)+0.355;
fyROOH(i)=fyROOH(i)+1;fxNO2(i)=fxNO2(i)+0.12;fRO2XC(i)=fRO2XC(i)+0.065;fXN(i)=fXN(i)+0.525;fXC(i)=fXC(i)-1.075;

%BT08 new added
i=i+1;
Rnames{i} = 'BUTADIENE13 + O3P = 0.25*HO2 + 0.117*xHO2 + 0.118*xMACO3 + 0.235*RO2C + 0.015*RO2XC + 0.015*zRNO3 + 0.115*xCO + 0.115*xACROLEIN + 0.001*xAFG1 + 0.001*xAFG2 + 0.75*PRD2 + 0.25*yROOH - 1.532*XC';
k(:,i) = 2.26e-11.*exp(40./ T);
Gstr{i,1} = 'BUTADIENE13'; Gstr{i,2} = 'O3P'; 
fBUTADIENE13(i)=fBUTADIENE13(i)-1;fO3P(i)=fO3P(i)-1;fHO2(i)=fHO2(i)+0.25;fxHO2(i)=fxHO2(i)+0.117;fRO2C(i)=fRO2C(i)+0.235;
fzRNO3(i)=fzRNO3(i)+0.015;fxMACO3(i)=fxMACO3(i)+0.118;
fxCO(i)=fxCO(i)+0.115;fxACROLEIN(i)=fxACROLEIN(i)+0.115;fxAFG1(i)=fxAFG1(i)+0.001;fxAFG2(i)=fxAFG2(i)+0.001;
fyROOH(i)=fyROOH(i)+0.25;fPRD2(i)=fPRD2(i)+0.75;fRO2XC(i)=fRO2XC(i)+0.015;fXC(i)=fXC(i)-1.532;

%BT09 new added
i=i+1;
Rnames{i} = 'APIN + OH = 0.799*xHO2 + 0.004*xRCO3 + 1.042*RO2C + 0.197*RO2XC + 0.197*zRNO3 + 0.002*xCO + 0.022*xHCHO + 0.776*xRCHO + 0.034*xACET + 0.02*xMGLY + 0.023*xBACL + yR6OOH + TRPRXN + 6.2*XC';
k(:,i) = 1.21e-11.*exp(436./ T);
Gstr{i,1} = 'APIN'; Gstr{i,2} = 'OH'; 
fAPIN(i)=fAPIN(i)-1;fOH(i)=fOH(i)-1;fxHO2(i)=fxHO2(i)+0.799;fRO2C(i)=fRO2C(i)+1.042;fxRCO3(i)=fxRCO3(i)+0.004;
fzRNO3(i)=fzRNO3(i)+0.197;fxHCHO(i)=fxHCHO(i)+0.022;fxRCHO(i)=fxRCHO(i)+0.776;
fxCO(i)=fxCO(i)+0.002;fxACET(i)=fxACET(i)+0.034;fxMGLY(i)=fxMGLY(i)+0.02;fxBACL(i)=fxBACL(i)+0.023;
fyR6OOH(i)=fyR6OOH(i)+1;fTRPRXN(i)=fTRPRXN(i)+1;fRO2XC(i)=fRO2XC(i)+0.197;fXC(i)=fXC(i)+6.2;

%BT10 new added
i=i+1;
Rnames{i} = 'APIN + O3 = 0.009*HO2 + 0.102*xHO2 + 0.728*OH + 0.001*xMECO3 + 0.297*xRCO3 + 1.511*RO2C + 0.337*RO2XC + 0.337*zRNO3 + 0.029*CO + 0.051*xCO + 0.017*CO2 + 0.344*xHCHO + 0.24*xRCHO + 0.345*xACET + 0.008*MEK + 0.002*xGLY + 0.081*xBACL + 0.255*PRD2 + 0.737*yR6OOH + TRPRXN + 2.999*XC';
k(:,i) = 5e-16.*exp(-530./ T);
Gstr{i,1} = 'APIN'; Gstr{i,2} = 'O3'; 
fAPIN(i)=fAPIN(i)-1;fO3(i)=fO3(i)-1;fHO2(i)=fHO2(i)+0.009;fxHO2(i)=fxHO2(i)+0.102;fOH(i)=fOH(i)+0.728;
fxMECO3(i)=fxMECO3(i)+0.001;fRO2C(i)=fRO2C(i)+1.511;fxRCO3(i)=fxRCO3(i)+0.297;fRO2XC(i)=fRO2XC(i)+0.337;
fzRNO3(i)=fzRNO3(i)+0.337;fxHCHO(i)=fxHCHO(i)+0.344;fxRCHO(i)=fxRCHO(i)+0.24;fxCO(i)=fxCO(i)+0.051;
fCO(i)=fCO(i)+0.029;fxACET(i)=fxACET(i)+0.345;fCO2(i)=fCO2(i)+0.017;fxBACL(i)=fxBACL(i)+0.081;
fyR6OOH(i)=fyR6OOH(i)+0.737;fTRPRXN(i)=fTRPRXN(i)+1;fXC(i)=fXC(i)+2.999;fPRD2(i)=fPRD2(i)+0.255;
fMEK(i)=fMEK(i)+0.008;fxGLY(i)=fxGLY(i)+0.002;

%BT11 new added
i=i+1;
Rnames{i} = 'APIN + NO3 = 0.056*xHO2 + 0.643*xNO2 + 0.007*xRCO3 + 1.05*RO2C + 0.293*RO2XC + 0.293*zRNO3 + 0.005*xCO + 0.007*xHCHO + 0.684*xRCHO + 0.069*xACET + 0.002*xMGLY + 0.056*xRNO3 + yR6OOH + 0.301*XN + 5.608*XC ';
k(:,i) = 1.19e-12.*exp(490./ T);
Gstr{i,1} = 'APIN'; Gstr{i,2} = 'NO3'; 
fAPIN(i)=fAPIN(i)-1;fNO3(i)=fNO3(i)-1;fxHO2(i)=fxHO2(i)+0.056;fxNO2(i)=fxNO2(i)+0.643;
fRO2C(i)=fRO2C(i)+1.05;fxRCO3(i)=fxRCO3(i)+0.007;fRO2XC(i)=fRO2XC(i)+0.293;
fzRNO3(i)=fzRNO3(i)+0.293;fxRCHO(i)=fxRCHO(i)+0.684;fxCO(i)=fxCO(i)+0.005;
fxHCHO(i)=fxHCHO(i)+0.007;fxACET(i)=fxACET(i)+0.069;fxMGLY(i)=fxMGLY(i)+0.002;
fyR6OOH(i)=fyR6OOH(i)+1;fxRNO3(i)=fxRNO3(i)+0.056;fXC(i)=fXC(i)+5.608;fXN(i)=fXN(i)+0.301;

%BT12 new added
i=i+1;
Rnames{i} = 'APIN + O3P = PRD2 + TRPRXN + 4*XC ';
k(:,i) = 3.2e-11;
Gstr{i,1} = 'APIN'; Gstr{i,2} = 'O3P'; 
fAPIN(i)=fAPIN(i)-1;fO3P(i)=fO3P(i)-1;fPRD2(i)=fPRD2(i)+1;fTRPRXN(i)=fTRPRXN(i)+1;
fXC(i)=fXC(i)+4;

%BT13 new added
i=i+1;
Rnames{i} = 'TOLUENE + OH = 0.181*HO2 + 0.454*xHO2 + 0.312*OH + 0.454*RO2C + 0.054*RO2XC + 0.054*zRNO3 + 0.238*xGLY + 0.151*xMGLY + 0.181*CRES + 0.065*xBALD + 0.195*xAFG1 + 0.195*xAFG2 + 0.312*AFG3 + 0.073*yR6OOH + 0.435*yRAOOH + TOLRO2 - 0.109*XC';
k(:,i) = 1.81e-12.*exp(338./ T);
Gstr{i,1} = 'TOLUENE'; Gstr{i,2} = 'OH'; 
fTOLUENE(i)=fTOLUENE(i)-1;fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+0.181;fxHO2(i)=fxHO2(i)+0.454;
fRO2C(i)=fRO2C(i)+0.454;fRO2XC(i)=fRO2XC(i)+0.054;fOH(i)=fOH(i)+0.312;
fzRNO3(i)=fzRNO3(i)+0.054;fxMGLY(i)=fxMGLY(i)+0.151;fxGLY(i)=fxGLY(i)+0.238;fCRES(i)=fCRES(i)+0.181;
fxAFG1(i)=fxAFG1(i)+0.195;fxAFG2(i)=fxAFG2(i)+0.195;fAFG3(i)=fAFG3(i)+0.312;fxBALD(i)=fxBALD(i)+0.065;
fyR6OOH(i)=fyR6OOH(i)+0.073;fyRAOOH(i)=fyRAOOH(i)+0.435;fTOLRO2(i)=fTOLRO2(i)+1;fXC(i)=fXC(i)-0.109;

%BT14 new added

i=i+1;
Rnames{i} = 'MXYL + OH = 0.159*HO2 + 0.52*xHO2 + 0.239*OH + 0.52*RO2C + 0.082*RO2XC + 0.082*zRNO3 + 0.1*xGLY + 0.38*xMGLY + 0.159*CRES + 0.041*xBALD + 0.336*xAFG1 + 0.144*xAFG2 + 0.239*AFG3 + 0.047*yR6OOH + 0.555*yRAOOH + XYLRO2 + 0.695*XC';
k(:,i) = 2.31e-11;
Gstr{i,1} = 'MXYL'; Gstr{i,2} = 'OH'; 
fMXYL(i)=fMXYL(i)-1;fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+0.159;fxHO2(i)=fxHO2(i)+0.52;
fRO2C(i)=fRO2C(i)+0.52;fRO2XC(i)=fRO2XC(i)+0.082;fOH(i)=fOH(i)+0.239;
fzRNO3(i)=fzRNO3(i)+0.082;fxMGLY(i)=fxMGLY(i)+0.38;fxGLY(i)=fxGLY(i)+0.1;fCRES(i)=fCRES(i)+0.159;
fxAFG1(i)=fxAFG1(i)+0.336;fxAFG2(i)=fxAFG2(i)+0.144;fAFG3(i)=fAFG3(i)+0.239;fxBALD(i)=fxBALD(i)+0.041;
fyR6OOH(i)=fyR6OOH(i)+0.047;fyRAOOH(i)=fyRAOOH(i)+0.555;fXYLRO2(i)=fXYLRO2(i)+1;fXC(i)=fXC(i)+0.695;

%BT15 new added
i=i+1;
Rnames{i} = 'OXYL + OH = 0.161*HO2 + 0.554*xHO2 + 0.198*OH + 0.554*RO2C + 0.087*RO2XC + 0.087*zRNO3 + 0.084*xGLY + 0.238*xMGLY + 0.185*xBACL + 0.161*CRES + 0.047*xBALD + 0.253*xAFG1 + 0.253*xAFG2 + 0.198*AFG3 + 0.055*yR6OOH + 0.586*yRAOOH + XYLRO2 + 0.484*XC';
k(:,i) = 1.36e-11;
Gstr{i,1} = 'OXYL'; Gstr{i,2} = 'OH'; 
fOXYL(i)=fOXYL(i)-1;fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+0.161;fxHO2(i)=fxHO2(i)+0.554;
fRO2C(i)=fRO2C(i)+0.554;fRO2XC(i)=fRO2XC(i)+0.087;fOH(i)=fOH(i)+0.198;fxBACL(i)=fxBACL(i)+0.185;
fzRNO3(i)=fzRNO3(i)+0.087;fxMGLY(i)=fxMGLY(i)+0.238;fxGLY(i)=fxGLY(i)+0.084;fCRES(i)=fCRES(i)+0.161;
fxAFG1(i)=fxAFG1(i)+0.253;fxAFG2(i)=fxAFG2(i)+0.253;fAFG3(i)=fAFG3(i)+0.198;fxBALD(i)=fxBALD(i)+0.047;
fyR6OOH(i)=fyR6OOH(i)+0.055;fyRAOOH(i)=fyRAOOH(i)+0.586;fXYLRO2(i)=fXYLRO2(i)+1;fXC(i)=fXC(i)+0.484;

%BT16 new added
i=i+1;
Rnames{i} = 'PXYL + OH = 0.159*HO2 + 0.487*xHO2 + 0.278*OH + 0.487*RO2C + 0.076*RO2XC + 0.076*zRNO3 + 0.286*xGLY + 0.112*xMGLY + 0.159*CRES + 0.088*xBALD + 0.045*xAFG1 + 0.067*xAFG2 + 0.278*AFG3 + 0.286*xAFG3 + 0.102*yR6OOH + 0.461*yRAOOH + XYLRO2 + 0.399*XC';
k(:,i) = 1.43e-11;
Gstr{i,1} = 'PXYL'; Gstr{i,2} = 'OH'; 
fPXYL(i)=fPXYL(i)-1;fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+0.159;fxHO2(i)=fxHO2(i)+0.487;
fRO2C(i)=fRO2C(i)+0.487;fRO2XC(i)=fRO2XC(i)+0.076;fOH(i)=fOH(i)+0.278;
fzRNO3(i)=fzRNO3(i)+0.076;fxMGLY(i)=fxMGLY(i)+0.112;fxGLY(i)=fxGLY(i)+0.286;fCRES(i)=fCRES(i)+0.159;
fxAFG1(i)=fxAFG1(i)+0.045;fxAFG2(i)=fxAFG2(i)+0.067;fAFG3(i)=fAFG3(i)+0.278;fxBALD(i)=fxBALD(i)+0.088;
fyR6OOH(i)=fyR6OOH(i)+0.102;fyRAOOH(i)=fyRAOOH(i)+0.461;fXYLRO2(i)=fXYLRO2(i)+1;fXC(i)=fXC(i)+0.399;fxAFG3(i)=fxAFG3(i)+0.286;

%BT17 new added
i=i+1;
Rnames{i} = 'TMBENZ124 + OH = 0.022*HO2 + 0.627*xHO2 + 0.23*OH + 0.627*RO2C + 0.121*RO2XC + 0.121*zRNO3 + 0.074*xGLY + 0.405*xMGLY + 0.112*xBACL + 0.022*CRES + 0.036*xBALD + 0.088*xAFG1 + 0.352*xAFG2 + 0.23*AFG3 + 0.151*xAFG3 + 0.043*yR6OOH + 0.705*yRAOOH + XYLRO2 +  1.19*XC ';
k(:,i) = 3.25e-11;
Gstr{i,1} = 'TMBENZ124'; Gstr{i,2} = 'OH'; 
fTMBENZ124(i)=fTMBENZ124(i)-1;fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+0.022;fxHO2(i)=fxHO2(i)+0.627;
fRO2C(i)=fRO2C(i)+0.627;fRO2XC(i)=fRO2XC(i)+0.121;fOH(i)=fOH(i)+0.23;fxBACL(i)=fxBACL(i)+0.112;
fzRNO3(i)=fzRNO3(i)+0.121;fxMGLY(i)=fxMGLY(i)+0.405;fxGLY(i)=fxGLY(i)+0.074;fCRES(i)=fCRES(i)+0.022;
fxAFG1(i)=fxAFG1(i)+0.088;fxAFG2(i)=fxAFG2(i)+0.352;fAFG3(i)=fAFG3(i)+0.23;fxBALD(i)=fxBALD(i)+0.036;
fyR6OOH(i)=fyR6OOH(i)+0.043;fyRAOOH(i)=fyRAOOH(i)+0.705;fXYLRO2(i)=fXYLRO2(i)+1;fXC(i)=fXC(i)+1.19;fxAFG3(i)=fxAFG3(i)+0.151;

%BT18 new added
i=i+1;
Rnames{i} = 'ETOH + OH = 0.95*HO2 + 0.05*xHO2 + 0.05*RO2C + 0.081*xHCHO + 0.95*CCHO + 0.01*xHOCCHO + 0.05*yROOH - 0.001*XC ';
k(:,i) = 5.49e-13.*(T./300).^2.00.*exp(530./T);
Gstr{i,1} = 'ETOH'; Gstr{i,2} = 'OH'; 
fETOH(i)=fETOH(i)-1;fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+0.95;fxHO2(i)=fxHO2(i)+0.05;fRO2C(i)=fRO2C(i)+0.05;fxHCHO(i)=fxHCHO(i)+0.081;
fyROOH(i)=fyROOH(i)+0.05;fXC(i)=fXC(i)-0.001;fCCHO(i)=fCCHO(i)+0.95;fxHOCCHO(i)=fxHOCCHO(i)+0.01;

%CP07mtp new added
i=i+1;
Rnames{i} = 'MTNO3 + CL = HCL + 0.038*NO2 + 0.055*HO2 + 1.282*RO2C + 0.202*RO2XC + 0.202*zMTNO3 + 0.009*RCHO + 0.018*MEK + 0.012*PRD2 + 0.055*MTNO3 + 0.159*xNO2 + 0.547*xHO2 + 0.045*xHCHO + 0.3*xCCHO + 0.02*xRCHO + 0.003*xACET + 0.041*xMEK + 0.046*xPROD2 + 0.547*xMTNO3 + 0.908*yR6OOH + 0.201*XN - 0.149*XC';
k(:,i) = 1.92e-10;
Gstr{i,1} = 'MTNO3'; Gstr{i,2} = 'CL'; 
fMTNO3(i)=fMTNO3(i)-1;fCL(i)=fCL(i)-1;fHCL(i)=fHCL(i)+1;fHO2(i)=fHO2(i)+0.055;fNO2(i)=fNO2(i)+0.038; 
fRO2C(i)=fRO2C(i)+1.282; fRO2XC(i)=fRO2XC(i)+0.202; fzMTNO3(i)=fzMTNO3(i)+0.202; 
fRCHO(i)=fRCHO(i)+0.009; fMEK(i)=fMEK(i)+0.018; fPRD2(i)=fPRD2(i)+0.012; fMTNO3(i)=fMTNO3(i)+0.055; 
fxNO2(i)=fxNO2(i)+0.159; fxHO2(i)=fxHO2(i)+0.547; fxHCHO(i)=fxHCHO(i)+0.045; fxCCHO(i)=fxCCHO(i)+0.3; 
fxRCHO(i)=fxRCHO(i)+0.02;fxACET(i)=fxACET(i)+0.003;fxMEK(i)=fxMEK(i)+0.041;fxPROD2(i)=fxPROD2(i)+0.046;
fxMTNO3(i)=fxMTNO3(i)+0.547;fyR6OOH(i)=fyR6OOH(i)+0.908;fXN(i)=fXN(i)+0.201;fXC(i)=fXC(i)-0.149;

%BP70mtp new added
i=i+1;
Rnames{i} = 'MTNO3 + OH = 0.189*HO2 + 0.305*xHO2 + 0.019*NO2 + 0.313*xNO2 + 0.976*RO2C + 0.175*RO2XC + 0.175*zMTNO3 + 0.011*xHCHO + 0.429*xCCHO + 0.001*RCHO + 0.036*xRCHO + 0.004*xACET + 0.01*MEK + 0.17*xMEK + 0.008*PRD2 + 0.031*xPROD2 + 0.189*MTNO3 + 0.305*xMTNO3 + 0.157*yROOH + 0.636*yR6OOH + 0.174*XN + 0.04*XC';
k(:,i) = 7.2e-12;
Gstr{i,1} = 'MTNO3'; Gstr{i,2} = 'OH'; 
fMTNO3(i)=fMTNO3(i)-1;fOH(i)=fOH(i)-1;
fHO2(i)=fHO2(i)+0.189;fNO2(i)=fNO2(i)+0.019; fxHO2(i)=fxHO2(i)+0.305;fxNO2(i)=fxNO2(i)+0.313;
fRO2C(i)=fRO2C(i)+0.976; fRO2XC(i)=fRO2XC(i)+0.175; fzMTNO3(i)=fzMTNO3(i)+0.175; 
fxHCHO(i)=fxHCHO(i)+0.011;fxCCHO(i)=fxCCHO(i)+0.429;fRCHO(i)=fRCHO(i)+0.001; fxRCHO(i)=fxRCHO(i)+0.036;fMEK(i)=fMEK(i)+0.01; 
fPRD2(i)=fPRD2(i)+0.008; fMTNO3(i)=fMTNO3(i)+0.189; 
fxMEK(i)=fxMEK(i)+0.17; fxPROD2(i)=fxPROD2(i)+0.031;fxMTNO3(i)=fxMTNO3(i)+0.305; 
fxACET(i)=fxACET(i)+0.004;fyROOH(i)=fyROOH(i)+0.157;
fyR6OOH(i)=fyR6OOH(i)+0.636;fXN(i)=fXN(i)+0.174;fXC(i)=fXC(i)+0.04;

%BP71mtp new added
i=i+1;
Rnames{i} = 'MTNO3 + hv = 0.344*HO2 + 0.554*xHO2 + NO2 + 0.721*RO2C + 0.102*RO2XC + 0.102*zMTNO3 + 0.074*HCHO + 0.061*xHCHO + 0.214*CCHO + 0.23*xCCHO + 0.074*RCHO + 0.063*xRCHO + 0.008*xACET + 0.124*MEK + 0.083*xMEK + 0.19*PRD2 + 0.261*xPROD2 + 0.066*yROOH + 0.591*yR6OOH + 0.396*XC';
k(:,i) =  1.0.*JIC3ONO2;
Gstr{i,1} = 'MTNO3';  
fMTNO3(i)=fMTNO3(i)-1;
fHO2(i)=fHO2(i)+0.344;fNO2(i)=fNO2(i)+1; fxHO2(i)=fxHO2(i)+0.554;
fRO2C(i)=fRO2C(i)+0.721; fRO2XC(i)=fRO2XC(i)+0.102; fzMTNO3(i)=fzMTNO3(i)+0.102; fHCHO(i)=fHCHO(i)+0.074;
fxHCHO(i)=fxHCHO(i)+0.061;fCCHO(i)=fCCHO(i)+0.214;fxCCHO(i)=fxCCHO(i)+0.23;fRCHO(i)=fRCHO(i)+0.074; fxRCHO(i)=fxRCHO(i)+0.063;
fxACET(i)=fxACET(i)+0.008;fMEK(i)=fMEK(i)+0.124; fxMEK(i)=fxMEK(i)+0.083; 
fPRD2(i)=fPRD2(i)+0.19; fxPROD2(i)=fxPROD2(i)+0.261;
fyROOH(i)=fyROOH(i)+0.066;
fyR6OOH(i)=fyR6OOH(i)+0.591;fXC(i)=fXC(i)+0.396;

% Below are isoprene rxns in SAPRC07tic, replaced by the updated mechanism
%% Isoprene oxidation
%IS1. updated with the rxns below. The four reactions are based on the
%Caltech condensed mechanism, except that the 3% yield epoxide product (ICPE) is kept. See Wennberg et al., 2018
%Figure 9 and Figure 10.
% i=i+1;
% Rnames{i} = ' ISOP + OH = ISOPO2 + ISOPRXN';
% k(:,i) =  2.54e-11.*exp(410./ T);
% Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'OH'; 
% fISOP(i)=fISOP(i)-1; fOH(i)=fOH(i)-1; fISOPO2(i)=fISOPO2(i)+1; fISOPRXN(i)=fISOPRXN(i)+1;

i=i+1;
Rnames{i} = 'ISOP + OH = ISOP1OHOO';
k(:,i) = KIHOO1;
Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'OH'; 
fISOP(i)=fISOP(i)-1; fOH(i)=fOH(i)-1; fISOP1OHOO(i)=fISOP1OHOO(i)+1;

i=i+1;
Rnames{i} = 'ISOP + OH = ISOP4OHOO';
k(:,i) = KIHOO4;
Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'OH'; 
fISOP(i)=fISOP(i)-1; fOH(i)=fOH(i)-1; fISOP4OHOO(i)=fISOP4OHOO(i)+1;

i=i+1;
Rnames{i} = 'ISOP + OH = 0.15*HPALD1 + 0.25*HPALD2 + 0.4*HO2 + 0.03*OH + 0.03*ICPE + 0.57*CO + 1.455*OH + 0.285*HCHO + 0.285*MGLY + 0.285*HPETHNL + 0.285*MECO3';
% HPALD1 is sum of beta-HPALD isomers (2,1- and 3,4-). HPALD2 is sum of delta-HPALD isomers.
k(:,i) = KISO1;
Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'OH'; 
fISOP(i)=fISOP(i)-1; fOH(i)=fOH(i)+0.455; fHPALD1(i)=fHPALD1(i)+0.15; fHPALD2(i)=fHPALD2(i)+0.25; fHO2(i)=fHO2(i)+0.4; fOH(i)=fOH(i)+0.03; fICPE(i)=fICPE(i)+0.03; fCO(i)=fCO(i)+0.57; 
fHCHO(i)=fHCHO(i)+0.285; fMGLY(i)=fMGLY(i)+0.285; fHPETHNL(i)=fHPETHNL(i)+0.285; fMECO3(i)=fMECO3(i)+0.285;

i=i+1;
Rnames{i} = 'ISOP + OH = 0.15*HPALD1 + 0.25*HPALD2 + 0.685*HO2 + 1.455*OH + 0.03*ICPE + 0.285*HCHO + 0.855*CO + 0.285*MGLY + 0.285*HPAC';
% HPALD1 is sum of beta-HPALD isomers (2,1- and 3,4-). HPALD2 is sum of delta-HPALD isomers.
k(:,i) = KISO4;
Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'OH'; 
fISOP(i)=fISOP(i)-1; fOH(i)=fOH(i)+0.455; fHPALD1(i)=fHPALD1(i)+0.15; fHPALD2(i)=fHPALD2(i)+0.25; fHO2(i)=fHO2(i)+0.685; fICPE(i)=fICPE(i)+0.03; fCO(i)=fCO(i)+0.855;
fHCHO(i)=fHCHO(i)+0.285; fMGLY(i)=fMGLY(i)+0.285; fHPAC(i)=fHPAC(i)+0.285;

% %BE07. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' ISOP + O3 = 0.266*OH + 0.066*HO2 + 0.192*RO2C + 0.008*RO2XC + 0.008*zRNO3 + 0.275*CO + 0.122*CO2 + 0.4*HCHO + 0.1*PRD2 + 0.39*MACR + 0.16*MVK + 0.15*IPRD + 0.204*FACD + 0.192*xMACO3 + 0.192*xHCHO +  0.2*yR6OOH + -0.559*XC ';
% k(:,i) =  7.86e-15.*exp(-1912./ T);
% Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'O3'; 
% fISOP(i)=fISOP(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.266; fHO2(i)=fHO2(i)+0.066; 
% fRO2C(i)=fRO2C(i)+0.192; fRO2XC(i)=fRO2XC(i)+0.008; fzRNO3(i)=fzRNO3(i)+0.008; 
% fCO(i)=fCO(i)+0.275; fCO2(i)=fCO2(i)+0.122; fHCHO(i)=fHCHO(i)+0.4; fPRD2(i)=fPRD2(i)+0.1; 
% fMACR(i)=fMACR(i)+0.39; fMVK(i)=fMVK(i)+0.16; fIPRD(i)=fIPRD(i)+0.15; fFACD(i)=fFACD(i)+0.204; 
% fxMACO3(i)=fxMACO3(i)+0.192; fxHCHO(i)=fxHCHO(i)+0.192; fyR6OOH(i)=fyR6OOH(i)+0.2; fXC(i)=fXC(i)+-0.559; 

% HOx yield modified based on Caltech mechanism
i=i+1;
Rnames{i} = ' ISOP + O3 = 0.28*OH + 0.16*HO2 + 0.39*MACR + 0.16*MVK + 0.4*HCHO + 0.275*CO + 0.192*RO2C + 0.008*RO2XC + 0.008*zRNO3  + 0.122*CO2 + 0.1*PRD2 + 0.15*IPRD + 0.204*FACD + 0.192*xMACO3 + 0.192*xHCHO + 0.2*yR6OOH + -0.559*XC ';
k(:,i) =  7.86e-15.*exp(-1912./ T);
Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'O3'; 
fISOP(i)=fISOP(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.28; fHO2(i)=fHO2(i)+0.16;
fRO2C(i)=fRO2C(i)+0.192; fRO2XC(i)=fRO2XC(i)+0.008; fzRNO3(i)=fzRNO3(i)+0.008; 
fCO(i)=fCO(i)+0.275; fCO2(i)=fCO2(i)+0.122; fHCHO(i)=fHCHO(i)+0.4; fPRD2(i)=fPRD2(i)+0.1; 
fMACR(i)=fMACR(i)+0.39; fMVK(i)=fMVK(i)+0.16; fIPRD(i)=fIPRD(i)+0.15; fFACD(i)=fFACD(i)+0.204; 
fxMACO3(i)=fxMACO3(i)+0.192; fxHCHO(i)=fxHCHO(i)+0.192; fyR6OOH(i)=fyR6OOH(i)+0.2; fXC(i)=fXC(i)+-0.559; 

%IS9. Unchanged. But NISOPO2 is a lumped RO2 that represent 6 different
%isomers, based on the Caltech and FZJ mechanisms. The branching ratios are
%slightly different between the two mechanisms. In the Caltech mechanism,
%~42% of the NISOPO2 is beta-1,2-NISOPO2 that cannot form nitrooxycarbonyl.
%In the FZJ mechanism, this branching ratio is high, ~64%.
%
i=i+1;
Rnames{i} = ' ISOP + NO3 = NISOPO2';
k(:,i) =  3.03e-12.*exp(-448./ T);
Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'NO3'; 
fISOP(i)=fISOP(i)-1; fNO3(i)=fNO3(i)-1; fNISOPO2(i)=fNISOPO2(i)+1; 

%BE09. Unchanged.
i=i+1;
Rnames{i} = ' ISOP + O3P = 0.25*MEO2 + 0.24*RO2C + 0.01*RO2XC + 0.01*zRNO3 + 0.75*PRD2 + 0.24*xMACO3 + 0.24*xHCHO + 0.25*yR6OOH + -1.01*XC';
k(:,i) =  3.50e-11;
Gstr{i,1} = 'ISOP'; Gstr{i,2} = 'O3P'; 
fISOP(i)=fISOP(i)-1; fO3P(i)=fO3P(i)-1; fMEO2(i)=fMEO2(i)+0.25; fRO2C(i)=fRO2C(i)+0.24; fRO2XC(i)=fRO2XC(i)+0.01; fzRNO3(i)=fzRNO3(i)+0.01; fPRD2(i)=fPRD2(i)+0.75; fxMACO3(i)=fxMACO3(i)+0.24; fxHCHO(i)=fxHCHO(i)+0.24; fyR6OOH(i)=fyR6OOH(i)+0.25; fXC(i)=fXC(i)+-1.01; 

%% MACR rxns, remained the same as SAPRC07tic
%IS00
i=i+1;
Rnames{i} = ' MACR + OH = 0.53*MACROO + 0.47*IMACO3 ';
k(:,i) =  8.00e-12.*exp(380./ T);
Gstr{i,1} = 'MACR'; Gstr{i,2} = 'OH'; 
fMACR(i)=fMACR(i)-1; fOH(i)=fOH(i)-1; fIMACO3(i)=fIMACO3(i)+0.47; fMACROO(i)=fMACROO(i)+0.53;

%BP55
i=i+1;
Rnames{i} = ' MACR + O3 = 0.208*OH + 0.108*HO2 + 0.1*RO2C + 0.45*CO + 0.117*CO2 + 0.1*HCHO + 0.9*MGLY + 0.333*FACD + 0.1*xRCO3 + 0.1*xHCHO + 0.1*yROOH +  -0.1*XC ';
k(:,i) =  1.40e-15.*exp(-2100./ T);
Gstr{i,1} = 'MACR'; Gstr{i,2} = 'O3'; 
fMACR(i)=fMACR(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.208; fHO2(i)=fHO2(i)+0.108; fRO2C(i)=fRO2C(i)+0.1; fCO(i)=fCO(i)+0.45; fCO2(i)=fCO2(i)+0.117; fHCHO(i)=fHCHO(i)+0.1; fMGLY(i)=fMGLY(i)+0.9; fFACD(i)=fFACD(i)+0.333; fxRCO3(i)=fxRCO3(i)+0.1; fxHCHO(i)=fxHCHO(i)+0.1; fyROOH(i)=fyROOH(i)+0.1; fXC(i)=fXC(i)+-0.1; 

%BP56
i=i+1;
Rnames{i} = ' MACR + NO3 = 0.5*IMACO3 + 0.5*RO2C + 0.5*HNO3 + 0.5*xHO2 + 0.5*xCO +0.5*yROOH + 1.5*XC + 0.5*XN ';
k(:,i) =  1.50e-12.*exp(-1815./ T);
Gstr{i,1} = 'MACR'; Gstr{i,2} = 'NO3'; 
fMACR(i)=fMACR(i)-1; fNO3(i)=fNO3(i)-1; fIMACO3(i)=fIMACO3(i)+0.5; fRO2C(i)=fRO2C(i)+0.5; fHNO3(i)=fHNO3(i)+0.5; 
fxHO2(i)=fxHO2(i)+0.5; fxCO(i)=fxCO(i)+0.5; fyROOH(i)=fyROOH(i)+0.5; fXC(i)=fXC(i)+1.5; fXN(i)=fXN(i)+0.5; 

%BP57
i=i+1;
Rnames{i} = ' MACR + O3P = RCHO + XC ';
k(:,i) =  6.34e-12;
Gstr{i,1} = 'MACR'; Gstr{i,2} = 'O3P'; 
fMACR(i)=fMACR(i)-1; fO3P(i)=fO3P(i)-1; fRCHO(i)=fRCHO(i)+1; fXC(i)=fXC(i)+1; 

%BP58
i=i+1;
Rnames{i} = ' MACR + hv = 0.33*OH + 0.67*HO2 + 0.34*MECO3 + 0.33*MACO3 + 0.33*RO2C + 0.67*CO + 0.34*HCHO + 0.33*xMECO3 + 0.33*xHCHO + 0.33*yROOH';
k(:,i) =  1.0.*JMACR_06;
Gstr{i,1} = 'MACR'; 
fMACR(i)=fMACR(i)-1; fOH(i)=fOH(i)+0.33; fHO2(i)=fHO2(i)+0.67; fMECO3(i)=fMECO3(i)+0.34; fMACO3(i)=fMACO3(i)+0.33; fRO2C(i)=fRO2C(i)+0.33; fCO(i)=fCO(i)+0.67; fHCHO(i)=fHCHO(i)+0.34; fxMECO3(i)=fxMECO3(i)+0.33; fxHCHO(i)=fxHCHO(i)+0.33; fyROOH(i)=fyROOH(i)+0.33; 

%% MVK rxns, remained the same as SAPRC07tic
% IS56 new added
i=i+1;
Rnames{i} = ' MVK + OH = MVKOO';
k(:,i) =  2.60e-12.*exp(610./ T);
Gstr{i,1} = 'MVK'; Gstr{i,2} = 'OH'; 
fMVK(i)=fMVK(i)-1; fOH(i)=fOH(i)-1; fMVKOO(i)=fMVKOO(i)+1; 

%BP60
i=i+1;
Rnames{i} = ' MVK + O3 = 0.164*OH + 0.064*HO2 + 0.05*RO2C + 0.05*xHO2 + 0.475*CO + 0.124*CO2 + 0.05*HCHO + 0.95*MGLY + 0.351*FACD + 0.05*xRCO3 + 0.05*xHCHO + 0.05*yROOH + -0.05*XC ';
k(:,i) =  8.50e-16.*exp(-1520./ T);
Gstr{i,1} = 'MVK'; Gstr{i,2} = 'O3'; 
fMVK(i)=fMVK(i)-1; fO3(i)=fO3(i)-1; fOH(i)=fOH(i)+0.164; fHO2(i)=fHO2(i)+0.064; fRO2C(i)=fRO2C(i)+0.05; fxHO2(i)=fxHO2(i)+0.05; fCO(i)=fCO(i)+0.475; fCO2(i)=fCO2(i)+0.124; fHCHO(i)=fHCHO(i)+0.05; fMGLY(i)=fMGLY(i)+0.95; fFACD(i)=fFACD(i)+0.351; fxRCO3(i)=fxRCO3(i)+0.05; fxHCHO(i)=fxHCHO(i)+0.05; fyROOH(i)=fyROOH(i)+0.05; fXC(i)=fXC(i)+-0.05; 

%BP62
i=i+1;
Rnames{i} = ' MVK + O3P = 0.45*RCHO + 0.55*MEK + 0.45*XC ';
k(:,i) =  4.32e-12;
Gstr{i,1} = 'MVK'; Gstr{i,2} = 'O3P'; 
fMVK(i)=fMVK(i)-1; fO3P(i)=fO3P(i)-1; fRCHO(i)=fRCHO(i)+0.45; fMEK(i)=fMEK(i)+0.55; fXC(i)=fXC(i)+0.45; 

%BP63
i=i+1;
Rnames{i} = ' MVK + hv = 0.4*MEO2 + 0.6*CO + 0.6*PRD2 + 0.4*MACO3 + -2.2*XC ';
k(:,i) =  1.0.*JMVK_06;
Gstr{i,1} = 'MVK'; 
fMVK(i)=fMVK(i)-1; fMEO2(i)=fMEO2(i)+0.4; fCO(i)=fCO(i)+0.6; fPRD2(i)=fPRD2(i)+0.6; fMACO3(i)=fMACO3(i)+0.4; fXC(i)=fXC(i)+-2.2; 

%% RO2 isomerization
% %IS107. updated with the rxns below on 20220912
% i=i+1;
% Rnames{i} = ' ISOPO2 = HO2 + HPALD ';
% k(:,i) = 4.07e8.*exp(-7694./ T);
% Gstr{i,1} = 'ISOPO2'; 
% fISOPO2(i)=fISOPO2(i)-1;
% fHO2(i)=fHO2(i)+1;fHPALD(i)=fHPALD(i)+1;

% --------------ISOP1OHOO-----------------
i=i+1;
Rnames{i} = 'ISOP1OHOO = HCHO + OH + MVK';
%1,5-H shift. Same as the Caltech mechanism
k(:,i) = (1.1644-T.*7.0485E-4).*1.04E11.*exp(-9746./T); 
Gstr{i,1} = 'ISOP1OHOO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1; fHCHO(i)=fHCHO(i)+1; fOH(i)=fOH(i)+1; fMVK(i)=fMVK(i)+1;

i=i+1;
Rnames{i} = 'ISOP1OHOO = 0.15*HPALD1 + 0.25*HPALD2 + 0.4*HO2 + 0.03*OH + 0.03*ICPE + 0.57*CO + 1.455*OH + 0.285*HCHO + 0.285*MGLY + 0.285*HPETHNL + 0.285*MECO3';
%1,6-H shift. Same as the Caltech mechanism.
k(:,i) = (T.*5.1242E-5-0.0128).*5.05E15.*exp(-12200./T).*exp(1E8./T.^3);
Gstr{i,1} = 'ISOP1OHOO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1; fOH(i)=fOH(i)+1.455; fHPALD1(i)=fHPALD1(i)+0.15; fHPALD2(i)=fHPALD2(i)+0.25; fHO2(i)=fHO2(i)+0.4; fOH(i)=fOH(i)+0.03; fICPE(i)=fICPE(i)+0.03; fCO(i)=fCO(i)+0.57; 
fHCHO(i)=fHCHO(i)+0.285; fMGLY(i)=fMGLY(i)+0.285; fHPETHNL(i)=fHPETHNL(i)+0.285; fMECO3(i)=fMECO3(i)+0.285;
% --------------ISOP4OHOO-----------------
i=i+1;
Rnames{i} = 'ISOP4OHOO = MACR + OH + HCHO';
%1,5-H shift. Same as the Caltech mechanism
k(:,i) = (1.2038-T.*9.0435E-4).*1.88E11.*exp(-9752./T); 
Gstr{i,1} = 'ISOP4OHOO'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1; fMACR(i)=fMACR(i)+1; fOH(i)=fOH(i)+1; fHCHO(i)=fHCHO(i)+1; 

i=i+1;
Rnames{i} = 'ISOP4OHOO = 0.15*HPALD1 + 0.25*HPALD2 + 0.685*HO2 + 1.455*OH + 0.03*ICPE + 0.285*HCHO + 0.855*CO + 0.285*MGLY + 0.285*HPAC';
%1,6-H shift. Same as the Caltech mechanism.
k(:,i) = (T.*1.1346E-4-0.0306).*2.22E9.*exp(-7160./T).*exp(1E8./T.^3);
Gstr{i,1} = 'ISOP4OHOO'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1; fOH(i)=fOH(i)+1.455; fHPALD1(i)=fHPALD1(i)+0.15; fHPALD2(i)=fHPALD2(i)+0.25; fHO2(i)=fHO2(i)+0.685; fICPE(i)=fICPE(i)+0.03; fCO(i)=fCO(i)+0.855;
fHCHO(i)=fHCHO(i)+0.285; fMGLY(i)=fMGLY(i)+0.285; fHPAC(i)=fHPAC(i)+0.285;
% --------------MACROO-----------------
%IA80. Unchanged.
i=i+1;
Rnames{i} ='MACROO = HACET + CO + OH ';
k(:,i) = 2.90e7.*exp(-5297./ T);
Gstr{i,1} = 'MACROO'; 
fMACROO(i)=fMACROO(i)-1;fCO(i)=fCO(i)+1;fHACET(i)=fHACET(i)+1;fOH(i)=fOH(i)+1;

% below are new additional RO2 isomerization rxns. Updated on 20230331 by
% HZ
% --------------ISOPOOHOO-----------------
% three isomers
% i=i+1;
% Rnames{i} = 'ISOPOOHOO1 = IDHPE + OH';
% k(:,i) = F0AM_isop_TUN(T,M,6.80E12,1.12E4,8.46E7); 
% Gstr{i,1} = 'ISOPOOHOO1'; 
% fISOPOOHOO1(i)=fISOPOOHOO1(i)-1; fIDHPE(i)=fIDHPE(i)+1; fOH(i)=fOH(i)+1;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO2 = 0.32*ICPDH + 0.68*IDHPE + OH';
% k(:,i) = F0AM_isop_TUN(T,M,3.73E12,1.04E4,9.95E7); 
% Gstr{i,1} = 'ISOPOOHOO2'; 
% fISOPOOHOO2(i)=fISOPOOHOO2(i)-1; fICPDH(i)=fICPDH(i)+0.32; fIDHPE(i)=fIDHPE(i)+0.68; fOH(i)=fOH(i)+1; 
% i=i+1;
% Rnames{i} = 'ISOPOOHOO3 = IDHPE + OH';
% k(:,i) = F0AM_isop_TUN(T,M,1.87E12,9.63E3,8.02E7);
% Gstr{i,1} = 'ISOPOOHOO3'; 
% fISOPOOHOO3(i)=fISOPOOHOO3(i)-1; fIDHPE(i)=fIDHPE(i)+1; fOH(i)=fOH(i)+1;
% lumped ISOPOOHOO
i=i+1;
Rnames{i} = 'ISOPOOHOO = IDHPE + OH';
k(:,i) = 0.1.*0.15.*F0AM_isop_TUN(T,M,6.80E12,1.12E4,8.46E7); 
Gstr{i,1} = 'ISOPOOHOO'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fIDHPE(i)=fIDHPE(i)+1; fOH(i)=fOH(i)+1;
i=i+1;
Rnames{i} = 'ISOPOOHOO = 0.32ICPDH + 0.68IDHPE + OH';
k(:,i) = 0.1.*0.1*F0AM_isop_TUN(T,M,3.73E12,1.04E4,9.95E7); % this rate was updated on 20230919, by HZ
Gstr{i,1} = 'ISOPOOHOO'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fICPDH(i)=fICPDH(i)+0.32; fIDHPE(i)=fIDHPE(i)+0.68; fOH(i)=fOH(i)+1; 
i=i+1;
Rnames{i} = 'ISOPOOHOO = IDHPE + OH';
k(:,i) = 0.1.*0.25.*F0AM_isop_TUN(T,M,1.87E12,9.63E3,8.02E7); 
Gstr{i,1} = 'ISOPOOHOO'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fIDHPE(i)=fIDHPE(i)+1; fOH(i)=fOH(i)+1;
% --------------IEPOXOO-----------------
i=i+1;
Rnames{i} = 'IEPOXOO = 0.6*IDCHP + 1.0*HO2 + 0.4*HACET + 0.4*OH + 0.8*CO';
% lumped HC5OO, IEPOXAOO, and IEPOXBOO, at 0.4:0.4:0.2
k(:,i) = 1.875E13.*exp(-10000./T);
Gstr{i,1} = 'IEPOXOO';
fIEPOXOO(i)=fIEPOXOO(i)-1; fIDCHP(i)=fIDCHP(i)+0.6; fHO2(i)=fHO2(i)+1; fCO(i)=fCO(i)+0.8; fHACET(i)=fHACET(i)+0.4; fOH(i)=fOH(i)+0.4;
i=i+1;
Rnames{i} = 'IEPOXOO = OH + CO + C4DH';
k(:,i) = 0.3.*1.0E7.*exp(-5000./T);% Assuming 20% of IEPOXOO is IEPOXBOO that undergoes this pathway.
Gstr{i,1} = 'IEPOXOO'; 
fIEPOXOO(i)=fIEPOXOO(i)-1; fOH(i)=fOH(i)+1; fCO(i)=fCO(i)+1; fC4DH(i)=fC4DH(i)+1;
% --------------ISOPNOO-----------------
i=i+1;
Rnames{i} = 'ISOPNOO = ICHNP + HO2';
k(:,i) = 1.822E13.*exp(-10000./T); % Considered different rates from isomers.
Gstr{i,1} = 'ISOPNOO'; 
fISOPNOO(i)=fISOPNOO(i)-1; fICHNP(i)=fICHNP(i)+1; fHO2(i)=fHO2(i)+1;
% --------------NISOPO2-----------------
i=i+1;
Rnames{i} = 'NISOPO2 = HPALD2 + NO2';
% based on the FZJ mechanism. Considered branching ratios of RO2 that can
% isomerize.
k(:,i) = 5.37E-79.*exp(4158./T).*T.^28.02 + 6.55E-77.*exp(4374./T).*T.^27.06; 
Gstr{i,1} = 'NISOPO2';
fNISOPO2(i)=fNISOPO2(i)-1; fHPALD2(i)=fHPALD2(i)+1; fNO2(i)=fNO2(i)+1;
% --------------IHPNOO-----------------
i=i+1;
Rnames{i} = 'IHPNOO = 0.74*ICHNP + 0.26*IHNPE + OH';
k(:,i) = 7.68E12.*exp(-10000./T); % considered different rates from isomers.
Gstr{i,1} = 'IHPNOO'; 
fIHPNOO(i)=fIHPNOO(i)-1; fICHNP(i)=fICHNP(i)+0.74; fIHNPE(i)=fIHNPE(i)+0.74; fOH(i)=fOH(i)+1;
% --------------NIT1OHOO-----------------
i=i+1;
Rnames{i} = 'NIT1OHOO = MACRN + CO + OH';
k(:,i) = 6.55E12.*exp(-10000./T);
Gstr{i,1} = 'NIT1OHOO'; 
fNIT1OHOO(i)=fNIT1OHOO(i)-1; fMACRN(i)=fMACRN(i)+1;fCO(i)=fCO(i)+1;fOH(i)=fOH(i)+1;
% --------------NIEPOXOO-----------------
i=i+1;
Rnames{i} = 'NIEPOXOO = ICPE + NO2';
% based on the FZJ mechanism. 
k(:,i) = 1.77e-83.*exp(4035./T).*T.^30.09; 
Gstr{i,1} = 'NIEPOXOO'; 
fNIEPOXOO(i)=fNIEPOXOO(i)-1; fICPE(i)=fICPE(i)+1; fNO2(i)=fNO2(i)+1;
%% RO2 + NO
% %IS2. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' ISOPO2 + NO = 0.4*MVK + 0.26*MACR + 0.07*ISPOND + 0.047*ISOPNB + 0.66HCHO + 0.1*HC5 + 0.883*NO2 + 0.043*ARO2MN + 0.08*DIBOO + 0.803*HO2';
% k(:,i) = 2.6e-12.*exp(380./T);
% Gstr{i,1} = 'ISOPO2'; Gstr{i,2} = 'NO';
% fISOPO2(i)=fISOPO2(i)-1;fNO(i)=fNO(i)-1;
% fMVK(i)=fMVK(i)+0.4;fMACR(i)=fMACR(i)+0.26;fISPOND(i)=fISPOND(i)+0.07;
% fHO2(i)=fHO2(i)+0.803;fISOPNB(i)=fISOPNB(i)+0.047;fHCHO(i)=fHCHO(i)+0.66;
% fNO2(i)=fNO2(i)+0.883;fHC5(i)=fHC5(i)+0.1;fARO2MN(i)=fARO2MN(i)+0.043;
% fDIBOO(i)=fDIBOO(i)+0.08;

% --------------ISOP1OHOO-----------------
i=i+1;
Rnames{i} = 'ISOP1OHOO + NO = ISOP1OH2N';
% beta-1,2-ISOPOO rxn. ISOP1OH2N is the same as the Caltech mechanism's
% 1,2-IHN. See Wennberg et al., 2018 Figure 5
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,1.19,6,1.1644,7.05E-4);
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'NO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1; fNO(i)=fNO(i)-1; fISOP1OH2N(i)=fISOP1OH2N(i)+1;

i=i+1;
Rnames{i} = 'ISOP1OHOO + NO = NO2 + MVK + HO2 + HCHO';
% beta-1,2-ISOPOO rxn. See Wennberg et al., 2018 Figure 5
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,1.19,6,1.1644,7.05E-4);
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'NO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fHO2(i)=fHO2(i)+1; fMVK(i)=fMVK(i)+1; fHCHO(i)=fHCHO(i)+1;

i=i+1;
Rnames{i} = 'ISOP1OHOO + NO = ISOPHND';
% delta-1,4-ISOPOO rxn. ISOPHND is the lumped delta-hydroxynitrates. See
% Wennberg et al., 2018 Figure 6
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,1.421,6,-0.1644,-7.05E-4);
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'NO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1; fNO(i)=fNO(i)-1; fISOPHND(i)=fISOPHND(i)+1;

i=i+1;
Rnames{i} = 'ISOP1OHOO + NO = NO2 + 0.45*HC5 + 0.45*HO2 + 0.55*C4HP + 0.55*CO + 0.55*OH';
% delta-1,4-ISOPOO rxn. See Wennberg et al., 2018 Figure 6 and Figure 7.
% The 55% RO2 is assumed to all undergo isomerization
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,1.421,6,-0.1644,-7.05E-4);
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'NO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fHO2(i)=fHO2(i)+0.45; fHC5(i)=fHC5(i)+0.45; fC4HP(i)=fC4HP(i)+0.55; fOH(i)=fOH(i)+0.55; fCO(i)=fCO(i)+0.55;
% --------------ISOP4OHOO-----------------
i=i+1;
Rnames{i} = 'ISOP4OHOO + NO = ISOP3N4OH';
% beta-4,3-ISOPOO rxn. ISOP3N4OH is the same as the Caltech mechanism's
% 4,3-IHN. See Wennberg et al., 2018 Figure 5
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,1.297,6,1.2038,9.04E-4);
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'NO'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1; fNO(i)=fNO(i)-1; fISOP3N4OH(i)=fISOP3N4OH(i)+1;

i=i+1;
Rnames{i} = 'ISOP4OHOO + NO = NO2 + MACR + HO2 + HCHO';
% beta-4,3-ISOPOO rxn. See Wennberg et al., 2018 Figure 5
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,1.297,6,1.2038,9.04E-4);
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'NO'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fMACR(i)=fMACR(i)+1; fHO2(i)=fHO2(i)+1; fHCHO(i)=fHCHO(i)+1;

i=i+1;
Rnames{i} = 'ISOP4OHOO + NO = ISOPHND';
% delta-4,1-ISOPOO rxn. ISOPHND is the lumped delta-hydroxynitrates. See Wennberg et al., 2018 Figure 6
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,1.421,6,-0.2038,-9.04E-4);
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'NO'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1; fNO(i)=fNO(i)-1; fISOPHND(i)=fISOPHND(i)+1;

i=i+1;
Rnames{i} = 'ISOP4OHOO + NO = NO2 + 0.45*HO2 + 0.45*HC5 + 0.55*C4HP + 0.55*CO + 0.55*OH';
% delta-4,1-ISOPOO rxn. See Wennberg et al., 2018 Figure 6 and Figure 7. 
% The 55% RO2 is assumed to all undergo isomerization
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,1.421,6,-0.2038,-9.04E-4);
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'NO'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fHO2(i)=fHO2(i)+0.45; fHC5(i)=fHC5(i)+0.45; fC4HP(i)=fC4HP(i)+0.55; fCO(i)=fCO(i)+0.55; fOH(i)=fOH(i)+0.55; 
% --------------MACROO-----------------
% %IS63. updated with the rxns below.
% i=i+1;
% Rnames{i} =' MACROO + NO = 0.85*NO2 + 0.85*HO2 + 0.72*HACET + 0.72*CO + 0.13*HCHO + 0.13*MGLY + 0.15*MACRN';
% k(:,i) = 2.6e-12.*exp(380./ T);
% Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'NO'; 
% fMACROO(i)=fMACROO(i)-1; fNO(i)=fNO(i)-1;fHO2(i)=fHO2(i)+0.85;fNO2(i)=fNO2(i)+0.85;
% fCO(i)=fCO(i)+0.72;fMGLY(i)=fMGLY(i)+0.13;fHCHO(i)=fHCHO(i)+0.13;fHACET(i)=fHACET(i)+0.72;
% fMACRN(i)=fMACRN(i)+0.15;

i=i+1;
Rnames{i} = 'MACROO + NO = 0.86*HACET + 0.86*CO + 0.86*HO2 + NO2 + 0.14*MGLY + 0.14*HCHO';
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,2.985,6,1,0);
Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'NO'; 
fMACROO(i)=fMACROO(i)-1; fNO(i)=fNO(i)-1; fHACET(i)=fHACET(i)+0.86; fCO(i)=fCO(i)+0.86; fHO2(i)=fHO2(i)+0.86; fNO2(i)=fNO2(i)+1; fMGLY(i)=fMGLY(i)+0.14; fHCHO(i)=fHCHO(i)+0.14; 
i=i+1;
Rnames{i} = 'MACROO + NO = MACRN';
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,2.985,6,1,0);
Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'NO'; 
fMACROO(i)=fMACROO(i)-1; fNO(i)=fNO(i)-1; fMACRN(i)=fMACRN(i)+1;
% --------------IMACO3-----------------
% %IA69. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + NO = NO2 + CO + CO2 + HCHO + MEO2';
% k(:,i) = 6.7e-12.*exp(340./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'NO'; 
% fIMACO3(i)=fIMACO3(i)-1;fNO(i)=fNO(i)-1;fNO2(i)=fNO2(i)+1;fCO(i)=fCO(i)+1;fCO2(i)=fCO2(i)+1;
% fHCHO(i)=fHCHO(i)+1;fMEO2(i)=fMEO2(i)+1;

i=i+1;
Rnames{i} = 'IMACO3 + NO = 0.35*MECO3 + 0.65*MEO2 + 0.65*CO + HCHO + CO2 + NO2';
k(:,i) = 8.7E-12*exp(290./T); 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'NO'; 
fIMACO3(i)=fIMACO3(i)-1; fNO(i)=fNO(i)-1; fMECO3(i)=fMECO3(i)+0.35; fMEO2(i)=fMEO2(i)+0.65; fCO(i)=fCO(i)+0.65; fHCHO(i)=fHCHO(i)+1; fNO2(i)=fNO2(i)+1; 
% --------------MVKOO-----------------
% %IS57. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' MVKOO + NO = 0.625*HOCCHO + 0.625*MECO3 + 0.265*MGLY + 0.265*HCHO + 0.265*HO2 + 0.11*MVKN + 0.89*NO2';
% k(:,i) =  2.60e-12.*exp(380./ T);
% Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'NO'; 
% fMVKOO(i)=fMVKOO(i)-1; fNO(i)=fNO(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.625; fMECO3(i)=fMECO3(i)+0.625; fMGLY(i)=fMGLY(i)+0.265; 
% fHCHO(i)=fHCHO(i)+0.265; fHO2(i)=fHO2(i)+0.265; fMVKN(i)=fMVKN(i)+0.11;fNO2(i)=fNO2(i)+0.89;

i=i+1;
Rnames{i} = 'MVKOO + NO = 0.758*MECO3 + 0.758*HOCCHO + 0.242*MGLY + 0.242*HCHO + 0.242*HO2 + NO2';
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,4.573,6,1,0);
Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'NO'; 
fMVKOO(i)=fMVKOO(i)-1; fNO(i)=fNO(i)-1; fMECO3(i)=fMECO3(i)+0.758; fHOCCHO(i)=fHOCCHO(i)+0.758; fMGLY(i)=fMGLY(i)+0.242; fHCHO(i)=fHCHO(i)+0.242; fHO2(i)=fHO2(i)+0.242; fNO2(i)=fNO2(i)+1; 
i=i+1;
Rnames{i} = 'MVKOO + NO = MVKN';
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,4.573,6,1,0);
Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'NO'; 
fMVKOO(i)=fMVKOO(i)-1; fNO(i)=fNO(i)-1; fMVKN(i)=fMVKN(i)+1;
% --------------NISOPO2-----------------
% %IS11. updated with the rxns below.
% i=i+1;
% Rnames{i} = 'NISOPO2 + NO = 0.70*NIT1 + 0.035*MVK + 0.035*MACR + 1.3*NO2 + 0.80*HO2 + 0.070*HCHO + 0.23*HC5';
% k(:,i) =   2.6e-12.*exp(380./ T);
% Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'NO'; 
% fNISOPO2(i)=fNISOPO2(i)-1; fNO(i)=fNO(i)-1; fNIT1(i)=fNIT1(i)+0.7; fMVK(i)=fMVK(i)+0.035;
% fMACR(i)=fMACR(i)+0.035;fNO2(i)=fNO2(i)+1.3;fHCHO(i)=fHCHO(i)+0.07;fHC5(i)=fHC5(i)+0.23;fHO2(i)=fHO2(i)+0.8;

% combined mechanism, assuming 100% of the beta-1-2-INO forms NIEPOXOO.
i=i+1;
Rnames{i} = 'NISOPO2 + NO = 1.054*NO2 + 0.008*MVK + 0.046*MACR + 0.054*HCHO + 0.152*NIT1 + 0.152*HO2 + 0.385*HC5 + 0.409*NIEPOXOO';
k(:,i) =   F0AM_isop_ALK(T,M,2.7E-12,350.,2.76,9.,1.,0.);
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'NO'; 
fNISOPO2(i)=fNISOPO2(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1.054;fMVK(i)=fMVK(i)+0.008;fMACR(i)=fMACR(i)+0.046;fHCHO(i)=fHCHO(i)+0.054;
fNIT1(i)=fNIT1(i)+0.152;fHO2(i)=fHO2(i)+0.152;fHC5(i)=fHC5(i)+0.385;fNIEPOXOO(i)=fNIEPOXOO(i)+0.409;

i=i+1;
Rnames{i} = 'NISOPO2 + NO = IDN';
k(:,i) =   F0AM_isop_NIT(T,M,2.7E-12,350.,2.76,9.,1.,0.);
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'NO'; 
fNISOPO2(i)=fNISOPO2(i)-1; fNO(i)=fNO(i)-1; fIDN(i)=fIDN(i)+1;

% %IS18. Removed. HC5OO is lumped with IEPOXOO.
% i=i+1;
% Rnames{i} = 'HC5OO + NO = NO2 + 0.234*HOCCHO + 0.234*MGLY + 0.216*GLY + 0.216*HACET + 0.29*DHMOB + 0.17*RCOOH + 0.09*PRD2 + 0.09*CO + HO2 + 0.16*XC';
% k(:,i) =  2.6e-12.*exp(380./ T);
% Gstr{i,1} = 'HC5OO'; Gstr{i,2} = 'NO'; 
% fHC5OO(i)=fHC5OO(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1; fHOCCHO(i)=fHOCCHO(i)+0.234; fMGLY(i)=fMGLY(i)+0.234; 
% fGLY(i)=fGLY(i)+0.216; fHACET(i)=fHACET(i)+0.216; fDHMOB(i)=fDHMOB(i)+0.29; fRCOOH(i)=fRCOOH(i)+0.17; 
% fPRD2(i)=fPRD2(i)+0.09; fCO(i)=fCO(i)+0.09; fHO2(i)=fHO2(i)+1; fXC(i)=fXC(i)+0.16; 

% %IS26. Removed.
% i=i+1;
% Rnames{i} = 'ISOPNOOD + NO = 0.34*PRD2 + 0.15*PROPNN + 0.44*HACET + 0.07*MVKN + 0.13*ETHLN + 0.31*FACD + 0.31*NO3 + 0.72*HCHO + 0.15*HOCCHO +  1.34*NO2 + 0.35*HO2 - 0.68*XC ';
% k(:,i) =   2.4e-12.*exp(360./ T);
% Gstr{i,1} = 'ISOPNOOD'; Gstr{i,2} = 'NO'; 
% fISOPNOOD(i)=fISOPNOOD(i)-1; fNO(i)=fNO(i)-1; fPRD2(i)=fPRD2(i)+0.34;fPROPNN(i)=fPROPNN(i)+0.15;
% fHACET(i)=fHACET(i)+0.44;fMVKN(i)=fMVKN(i)+0.07;fETHLN(i)=fETHLN(i)+0.13;fFACD(i)=fFACD(i)+0.31;fNO3(i)=fNO3(i)+0.31;
% fHCHO(i)=fHCHO(i)+0.72;fHOCCHO(i)=fHOCCHO(i)+0.15;fNO2(i)=fNO2(i)+1.34;fHO2(i)=fHO2(i)+0.35;
% fXC(i)=fXC(i)-0.68;

% %IS29. updated with the rxns below.
% i=i+1;
% Rnames{i} = 'ISOPNOOB + NO = 0.6*HOCCHO + 0.6*HACET + 0.4*HCHO + 0.4*HO2 + 0.26*MACRN + 0.14*MVKN + 1.6*NO2 ';
% k(:,i) =  2.4e-12.*exp(360./ T);
% Gstr{i,1} = 'ISOPNOOB'; Gstr{i,2} = 'NO'; 
% fISOPNOOB(i)=fISOPNOOB(i)-1; fNO(i)=fNO(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.6;fHACET(i)=fHACET(i)+0.6;fHCHO(i)=fHCHO(i)+0.4;
% fHO2(i)=fHO2(i)+0.4;fMACRN(i)=fMACRN(i)+0.26;fMVKN(i)=fMVKN(i)+0.14;fNO2(i)=fNO2(i)+1.6;

% --------------ISOPNOO-----------------
i=i+1;
Rnames{i} = 'ISOPNOO + NO = 1.45*NO2 + 0.55*HO2 + 0.506*HCHO + 0.468*HOCCHO + 0.475*HACET + 0.019*PROPNN + 0.025*ETHLN + 0.169*MACRN + 0.337*MVKN';
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,6.4,11,1,0);
Gstr{i,1} = 'ISOPNOO'; Gstr{i,2} = 'NO'; 
fISOPNOO(i)=fISOPNOO(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1.45; fHO2(i)=fHO2(i)+0.55; fHCHO(i)=fHCHO(i)+0.506; fHOCCHO(i)=fHOCCHO(i)+0.468;
fHACET(i)=fHACET(i)+0.475; fPROPNN(i)=fPROPNN(i)+0.019; fETHLN(i)=fETHLN(i)+0.025; ffMACRN(i)=fMACRN(i)+0.169; fMVKN(i)=fMVKN(i)+0.337;
i=i+1;
Rnames{i} = 'ISOPNOO + NO = IDHDN';
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,6.4,11,1,0);
Gstr{i,1} = 'ISOPNOO'; Gstr{i,2} = 'NO'; 
fISOPNOO(i)=fISOPNOO(i)-1; fNO(i)=fNO(i)-1; fIDHDN(i)=fIDHDN(i)+1;
% --------------NIT1NO3OOA-----------------
%IS34. Unchanged
i=i+1;
Rnames{i} ='NIT1NO3OOA + NO =  NO2 + PROPNN + CO + CO2 + HO2 ';
k(:,i) =  6.7e-12.*exp(340./ T);
Gstr{i,1} = 'NIT1NO3OOA'; Gstr{i,2} = 'NO'; 
fNIT1NO3OOA(i)=fNIT1NO3OOA(i)-1; fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1;fPROPNN(i)=fPROPNN(i)+1;fCO(i)=fCO(i)+1;
fCO2(i)=fCO2(i)+1;fHO2(i)=fHO2(i)+1;

% %IS35. Removed.
% i=i+1;
% Rnames{i} =' NIT1NO3OOB + NO = 0.94*ISOPNN + 0.94*GLY + 0.94*NO2 + 0.06*RNO3I - 0.06*XC + 0.13*XN  ';
% k(:,i) = 2.60e-12.*exp(380./ T);
% Gstr{i,1} = 'NIT1NO3OOB'; Gstr{i,2} = 'NO'; 
% fNIT1NO3OOB(i)=fNIT1NO3OOB(i)-1; fNO(i)=fNO(i)-1;fISOPNN(i)=fISOPNN(i)+0.94;fGLY(i)=fGLY(i)+0.94;
% fNO2(i)=fNO2(i)+0.94;fRNO3I(i)=fRNO3I(i)+0.06;fXC(i)=fXC(i)-0.06;fXN(i)=fXN(i)+0.13;

% --------------NIT1OHOO-----------------
% %IS48. updated with the rxns below.
% i=i+1;
% Rnames{i} =' NIT1OHOO + NO = 0.919*PROPNN + 0.919*GLY + 0.015*CO + 0.015*RNO3I + 0.934*NO2 + 0.934*HO2 + 0.066*RNO3I - 0.096*XC +  0.066*XN';
% k(:,i) = 2.6e-12.*exp(380./ T);
% Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'NO'; 
% fNIT1OHOO(i)=fNIT1OHOO(i)-1; fNO(i)=fNO(i)-1;fPROPNN(i)=fPROPNN(i)+0.919;fGLY(i)=fGLY(i)+0.919;
% fCO(i)=fCO(i)+0.015;fRNO3I(i)=fRNO3I(i)+0.015;fNO2(i)=fNO2(i)+0.934;fHO2(i)=fHO2(i)+0.934;fRNO3I(i)=fRNO3I(i)+0.066;
% fXC(i)=fXC(i)-0.096;fXN(i)=fXN(i)+0.066;

i=i+1;
Rnames{i} ='NIT1OHOO + NO = NO2 + 0.75*MACRN + 0.75*CO + HO2 + 0.25*PROPNN + 0.25*GLY';
k(:,i) = 2.6e-12.*exp(380./ T);
Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'NO'; 
fNIT1OHOO(i)=fNIT1OHOO(i)-1; fNO(i)=fNO(i)-1;fNO2(i)=fNO2(i)+1;fMACRN(i)=fMACRN(i)+0.75;
fCO(i)=fCO(i)+0.75;fHO2(i)=fHO2(i)+1;fPROPNN(i)=fPROPNN(i)+0.25;fGLY(i)=fGLY(i)+0.25;

% %IS55. Removed.
% i=i+1;
% Rnames{i} =' DIBOO + NO = NO2 + HO2 + 0.52*HOCCHO + 0.52*MGLY + 0.48*GLY + 0.48*HACET ';
% k(:,i) = 2.6e-12.*exp(380./ T);
% Gstr{i,1} = 'DIBOO'; Gstr{i,2} = 'NO'; 
% fDIBOO(i)=fDIBOO(i)-1; fNO(i)=fNO(i)-1;fNO2(i)=fNO2(i)+1;fHO2(i)=fHO2(i)+1;
% fHOCCHO(i)=fHOCCHO(i)+0.52;fMGLY(i)=fMGLY(i)+0.52;fGLY(i)=fGLY(i)+0.48;fHACET(i)=fHACET(i)+0.48;

% --------------IEPOXOO-----------------
% %IS96. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IEPOXOO + NO = 0.725*HACET + 0.275*HOCCHO + 0.275*GLY + 0.275*MGLY + 0.125*OH + 0.825*HO2 + 0.200*CO2 + 0.375*HCHO + 0.074*FACD + 0.251*CO + NO2';
% k(:,i) = 2.6e-12.*exp(380./ T);
% Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'NO'; 
% fIEPOXOO(i)=fIEPOXOO(i)-1;fNO(i)=fNO(i)-1;fHACET(i)=fHACET(i)+0.725;fHOCCHO(i)=fHOCCHO(i)+0.275;fGLY(i)=fGLY(i)+0.275;
% fMGLY(i)=fMGLY(i)+0.275;fOH(i)=fOH(i)+0.125;fHO2(i)=fHO2(i)+0.825;fCO2(i)=fCO2(i)+0.2;fHCHO(i)=fHCHO(i)+0.375;
% fFACD(i)=fFACD(i)+0.074;fCO(i)=fCO(i)+0.251;fNO2(i)=fNO2(i)+1;

i=i+1;
Rnames{i} = 'IEPOXOO + NO = NO2 + HO2 + 0.2*CO + 0.2*C4DH  + 0.6*HOCCHO + 0.6*MGLY + 0.2*GLY + 0.2*HACET';
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,13.098,8,1,0);
Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'NO'; 
fIEPOXOO(i)=fIEPOXOO(i)-1; fNO(i)=fNO(i)-1; 
fC4DH(i)=fC4DH(i)+0.2; fHO2(i)=fHO2(i)+1; fNO2(i)=fNO2(i)+1; fCO(i)=fCO(i)+0.2; fHOCCHO(i)=fHOCCHO(i)+0.6; fMGLY(i)=fMGLY(i)+0.6; fGLY(i)=fGLY(i)+0.2; fHACET(i)=fHACET(i)+0.2; 

i=i+1;
Rnames{i} = 'IEPOXOO + NO = IDHCN';
k(:,i) =  F0AM_isop_NIT(T,M,2.7E-12,350,13.098,8,1,0);
Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'NO'; 
fIEPOXOO(i)=fIEPOXOO(i)-1; fNO(i)=fNO(i)-1; fIDHCN(i)=fIDHCN(i)+1;

% below are new additional RO2 + NO rxns, updated on 20220912 by HZ
% --------------ISOPOOHOO-----------------
% explicit three isomers
% i=i+1;
% Rnames{i} = 'ISOPOOHOO1 + NO = 0.17*C4HP + 0.17*HCHO + 0.83*HPETHNL + 0.83*HACET + NO2 + HO2';
% k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,2.1,9,1,0);
% Gstr{i,1} = 'ISOPOOHOO1'; Gstr{i,2} = 'NO'; 
% fISOPOOHOO1(i)=fISOPOOHOO1(i)-1; fNO(i)=fNO(i)-1; fC4HP(i)=fC4HP(i)+0.17; fHCHO(i)=fHCHO(i)+0.17; fHPETHNL(i)=fHPETHNL(i)+0.83; fHACET(i)=fHACET(i)+0.83; fHO2(i)=fHO2(i)+1; fNO2(i)=fNO2(i)+1; 
% i=i+1;
% Rnames{i} = 'ISOPOOHOO1 + NO = IDHPN';
% k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,2.1,9,1,0.);
% Gstr{i,1} = 'ISOPOOHOO1'; Gstr{i,2} = 'NO'; 
% fISOPOOHOO1(i)=fISOPOOHOO1(i)-1; fNO(i)=fNO(i)-1; fIDHPN(i)=fIDHPN(i)+1;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO2 + NO = 0.847*C4HP + 0.847*HCHO + 0.153*HOCCHO + 0.153*HPAC + NO2 + HO2';
% k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,2.315,9,1,0);
% Gstr{i,1} = 'ISOPOOHOO2'; Gstr{i,2} = 'NO'; 
% fISOPOOHOO2(i)=fISOPOOHOO2(i)-1; fNO(i)=fNO(i)-1; fC4HP(i)=fC4HP(i)+0.847; fHCHO(i)=fHCHO(i)+0.847; fHOCCHO(i)=fHOCCHO(i)+0.153; fHPAC(i)=fHPAC(i)+0.153; fNO2(i)=fNO2(i)+1; fHO2(i)=fHO2(i)+1; 
% i=i+1;
% Rnames{i} = 'ISOPOOHOO2 + NO = IDHPN';
% k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,2.315,9,1,0);
% Gstr{i,1} = 'ISOPOOHOO2'; Gstr{i,2} = 'NO'; 
% fISOPOOHOO2(i)=fISOPOOHOO2(i)-1; fNO(i)=fNO(i)-1; fIDHPN(i)=fIDHPN(i)+1;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO3 + NO = HOCCHO + HACET + NO2 + OH';
% k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,3.079,9,1,0);
% Gstr{i,1} = 'ISOPOOHOO3'; Gstr{i,2} = 'NO'; 
% fISOPOOHOO3(i)=fISOPOOHOO3(i)-1; fNO(i)=fNO(i)-1; fHACET(i)=fHACET(i)+1; fHOCCHO(i)=fHOCCHO(i)+1; fOH(i)=fOH(i)+1; fNO2(i)=fNO2(i)+1; 
% i=i+1;
% Rnames{i} = 'ISOPOOHOO3 + NO = IDHPN';
% k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,3.079,9,1,0);
% Gstr{i,1} = 'ISOPOOHOO3'; Gstr{i,2} = 'NO'; 
% fISOPOOHOO3(i)=fISOPOOHOO3(i)-1; fNO(i)=fNO(i)-1; fIDHPN(i)=fIDHPN(i)+1;
% lumped ISOPOOHOO
i=i+1;
Rnames{i} = 'ISOPOOHOO + NO = 0.22*C4HP + 0.22*HCHO + 0.25*HPETHNL + 0.75*HACET + 0.53*HOCCHO + 0.03*HPAC + 0.5*HO2 + 0.5*OH + NO2';
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,2.9,9,1,0);
Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'NO'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fNO(i)=fNO(i)-1; 
fC4HP(i)=fC4HP(i)+0.22;fHCHO(i)=fHCHO(i)+0.22;fHPETHNL(i)=fHPETHNL(i)+0.25;fHACET(i)=fHACET(i)+0.75;fHO2(i)=fHO2(i)+0.5;fNO2(i)=fNO2(i)+1;fHOCCHO(i)=fHOCCHO(i)+0.53;fHPAC(i)=fHPAC(i)+0.03;fOH(i)=fOH(i)+0.5;
i=i+1;
Rnames{i} = 'ISOPOOHOO + NO = IDHPN';
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,2.9,9,1,0.);
Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'NO'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fNO(i)=fNO(i)-1; fIDHPN(i)=fIDHPN(i)+1;
% --------------IHPNOO-----------------
i=i+1;
Rnames{i} = 'IHPNOO + NO = NO2 + PROPNN + HO2 + HPETHNL';
k(:,i) = F0AM_isop_ALK(T,M,2.7E-12,350,4.383,12.,1.,0.);
Gstr{i,1} = 'IHPNOO'; Gstr{i,2} = 'NO'; 
fIHPNOO(i)=fIHPNOO(i)-1; fNO(i)=fNO(i)-1;fNO2(i)=fNO2(i)+1;fPROPNN(i)=fPROPNN(i)+1;fHO2(i)=fHO2(i)+1;fHPETHNL(i)=fHPETHNL(i)+1;
i=i+1;
Rnames{i} = 'IHPNOO + NO = IHPDN';
k(:,i) = F0AM_isop_NIT(T,M,2.7E-12,350,4.383,12.,1.,0.);
Gstr{i,1} = 'IHPNOO'; Gstr{i,2} = 'NO'; 
fIHPNOO(i)=fIHPNOO(i)-1; fNO(i)=fNO(i)-1;fIHPDN(i)=fIHPDN(i)+1;
% --------------IHDNOO-----------------
i=i+1;
Rnames{i} = 'IHDNOO + NO = 2*NO2 + HCHO + MVKN';
k(:,i) =  2.7e-12.*exp(350./ T);
Gstr{i,1} = 'IHDNOO'; Gstr{i,2} = 'NO'; 
fIHDNOO(i)=fIHDNOO(i)-1; fNO(i)=fNO(i)-1;fNO2(i)=fNO2(i)+2;fHCHO(i)=fHCHO(i)+1;fMVKN(i)=fMVKN(i)+1;
% --------------NIEPOXOO-----------------
i=i+1;
Rnames{i} =' NIEPOXOO + NO = 1.5*NO2 + 0.5*ICHE + 0.5*ICNE ';
k(:,i) = 2.7e-12.*exp(350./ T);
Gstr{i,1} = 'NIEPOXOO'; Gstr{i,2} = 'NO';
fNIEPOXOO(i)=fNIEPOXOO(i)-1;fNO(i)=fNO(i)-1; fNO2(i)=fNO2(i)+1.5; fICHE(i)=fICHE(i)+0.5; fICNE(i)=fICNE(i)+0.5;
%% RO2 + NO2
%IS109. Unchanged
i=i+1;
Rnames{i} =' NIT1NO3OOA + NO2 =  MAPAN + XN + XC ';
k(:,i) = 1.21e-11.*(T./300).^-1.07.*exp(0./T);
Gstr{i,1} = 'NIT1NO3OOA'; Gstr{i,2} = 'NO2'; 
fNIT1NO3OOA(i)=fNIT1NO3OOA(i)-1; fNO2(i)=fNO2(i)-1; fMAPAN(i)=fMAPAN(i)+1;fXN(i)=fXN(i)+1;fXC(i)=fXC(i)+1;
 
% %IA51. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + NO2 = IMAPAN ';
% k(:,i) = 1.21e-11.*(T./300).^-1.07.*exp(0./T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'NO2'; 
% fIMACO3(i)=fIMACO3(i)-1;fNO2(i)=fNO2(i)-1;fIMAPAN(i)=fIMAPAN(i)+1;
% %IA52 new added
% i=i+1;
% Rnames{i} =' IMAPAN = IMACO3 + NO2 ';
% k(:,i) = 1.6e16.*exp(-13486./ T);
% Gstr{i,1} = 'IMAPAN';  
% fIMAPAN(i)=fIMAPAN(i)-1;fNO2(i)=fNO2(i)+1;fIMACO3(i)=fIMACO3(i)+1;

% --------------IMACO3-----------------
i=i+1;
Rnames{i} = 'IMACO3 + NO2 = IMAPAN';
k(:,i) = F0AM_isop_TROE(2.591E-28,0,-6.87,1.125E-11,0,-1.105,0.3,T,M);
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'NO2'; 
fIMACO3(i)=fIMACO3(i)-1; fNO2(i)=fNO2(i)-1; fIMAPAN(i)=fIMAPAN(i)+1; 
i=i+1;
Rnames{i} = 'IMAPAN = IMACO3 + NO2';
k(:,i) = 1.58E16*exp(-13500./T);
Gstr{i,1} = 'IMAPAN'; 
fIMAPAN(i)=fIMAPAN(i)-1; fIMACO3(i)=fIMACO3(i)+1; fNO2(i)=fNO2(i)+1;

%% RO2 + HO2
% %IS3. updated with the rxns below. Based on the Caltech mechanism. See
% Wennberg et al., 2018, Figure 8.
% i=i+1;
% Rnames{i} = ' ISOPO2 + HO2 = 0.880*ISOPOOH + 0.120*OH + 0.047*MACR + 0.073*MVK + 0.120*HO2 + 0.120*HCHO  ';
% k(:,i) = 2.06e-13.*exp(1300./T);
% Gstr{i,1} = 'ISOPO2'; Gstr{i,2} = 'HO2';
% fISOPO2(i)=fISOPO2(i)-1;fHO2(i)=fHO2(i)-1;
% fISOPOOH(i)=fISOPOOH(i)+0.88;fMACR(i)=fMACR(i)+0.047;fOH(i)=fOH(i)+0.12;fMVK(i)=fMVK(i)+0.073;
% fHO2(i)=fHO2(i)+0.12;fHCHO(i)=fHCHO(i)+0.12;

% --------------ISOP1OHOO-----------------
i=i+1;
Rnames{i} = 'ISOP1OHOO + HO2 = 0.063*MVK + 0.063*OH + 0.063*HO2 + 0.063*HCHO + 0.937*ISOPOOH12';
k(:,i) = (1.1644-T.*7.0485E-4).*2.12E-13.*exp(1300./T);
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'HO2'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1; fHO2(i)=fHO2(i)-0.937; fISOPOOH12(i)=fISOPOOH12(i)+0.937; fHCHO(i)=fHCHO(i)+0.063; fMVK(i)=fMVK(i)+0.063; fOH(i)=fOH(i)+0.063;
i=i+1;
Rnames{i} = 'ISOP1OHOO + HO2 = ISOPOOHD';
k(:,i) = (T.*7.0485E-4-0.1644).*2.12E-13.*exp(1300./T); 
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'HO2'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1; fHO2(i)=fHO2(i)-0.937; fISOPOOHD(i)=fISOPOOHD(i)+1;
% --------------ISOP4OHOO-----------------
i=i+1;
Rnames{i} = 'ISOP4OHOO + HO2 = 0.063*MACR + 0.063*OH + 0.063*HO2 + 0.063*HCHO + 0.937*ISOPOOH43';
k(:,i) = (1.2038-T.*9.0435E-4).*2.12E-13.*exp(1300./T);
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'HO2'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1; fHO2(i)=fHO2(i)-0.937; fMACR(i)=fMACR(i)+0.063; fOH(i)=fOH(i)+0.063; fHCHO(i)=fHCHO(i)+0.063; fISOPOOH43(i)=fISOPOOH43(i)+0.937; 
i=i+1;
Rnames{i} = 'ISOP4OHOO + HO2 = ISOPOOHD';
k(:,i) = (T.*9.0435E-4-0.2038).*2.12E-13.*exp(1300./T); 
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'HO2'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1; fHO2(i)=fHO2(i)-1; fISOPOOHD(i)=fISOPOOHD(i)+1;
% --------------MACROO-----------------
% %IS64. updated with the rxns below.
% i=i+1;
% Rnames{i} =' MACROO + HO2 = ROOH + XC';
% k(:,i) = 1.82e-13.*exp(1300./ T);
% Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'HO2'; 
% fMACROO(i)=fMACROO(i)-1; fHO2(i)=fHO2(i)-1;fROOH(i)=fROOH(i)+1;fXC(i)=fXC(i)+1;

i=i+1;
Rnames{i} = 'MACROO + HO2 = 0.41*C4HP + 0.51*HACET + 0.51*CO + 0.51*HO2 + 0.59*OH + 0.08*MGLY + 0.08*HCHO';
k(:,i) = 2.12E-13*exp(1300./T) ;
Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'HO2'; 
fMACROO(i)=fMACROO(i)-1; fHO2(i)=fHO2(i)-0.49; fC4HP(i)=fC4HP(i)+0.41; fHACET(i)=fHACET(i)+0.51; fCO(i)=fCO(i)+0.51; fMGLY(i)=fMGLY(i)+0.08; fHCHO(i)=fHCHO(i)+0.08; fOH(i)=fOH(i)+0.59;
% --------------IMACO3-----------------
% %IA70. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + HO2 = 0.75*IMPAA + 0.25*RCOOH + 0.25*O3 + XC';
% k(:,i) = 5.20e-13.*exp(980./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'HO2'; 
% fIMACO3(i)=fIMACO3(i)-1;fHO2(i)=fHO2(i)-1;fIMPAA(i)=fIMPAA(i)+0.75;fRCOOH(i)=fRCOOH(i)+0.25;fO3(i)=fO3(i)+0.25;
% fXC(i)=fXC(i)+1;

i=i+1;
Rnames{i} = 'IMACO3 + HO2 = 0.37*IMPAA + 0.63*HCHO + 0.325*CO + 0.455*MEO2 + 0.305*MECO3 + 0.5*CO2 + 0.5*OH + 0.13*O3';
k(:,i) = 3.14E-12*exp(580./T) ; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'HO2'; 
fIMACO3(i)=fIMACO3(i)-1; fHO2(i)=fHO2(i)-1; fIMPAA(i)=fIMPAA(i)+0.37; fHCHO(i)=fHCHO(i)+0.63; fCO(i)=fCO(i)+0.325; fMEO2(i)=fMEO2(i)+0.455; fMECO3(i)=fMECO3(i)+0.305; fOH(i)=fOH(i)+0.5; fO3(i)=fO3(i)+0.13;

% --------------MVKOO-----------------
% %IS58. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' MVKOO + HO2 = ROOH + XC';
% k(:,i) =  1.82e-13.*exp(1300./ T);
% Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'HO2'; 
% fMVKOO(i)=fMVKOO(i)-1; fHO2(i)=fHO2(i)-1; fROOH(i)=fROOH(i)+1; fXC(i)=fXC(i)+1;

i=i+1;
Rnames{i} = 'MVKOO + HO2 = 0.36*MECO3 + 0.36*HOCCHO + 0.665*OH + 0.305*HO2 + 0.255*C4HC + 0.335*C4HP + 0.05*MGLY + 0.05*HCHO';
k(:,i) = 2.12E-13*exp(1300./T); 
Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'HO2'; 
fMVKOO(i)=fMVKOO(i)-1; fHO2(i)=fHO2(i)-0.695; fMECO3(i)=fMECO3(i)+0.36; fHOCCHO(i)=fHOCCHO(i)+0.36; fOH(i)=fOH(i)+0.665; fC4HC(i)=fC4HC(i)+0.255; fC4HP(i)=fC4HP(i)+0.335; fMGLY(i)=fMGLY(i)+0.05; fHCHO(i)=fHCHO(i)+0.05; 
% --------------NISOPO2-----------------
% %IS12. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' NISOPO2 + HO2 = NISOPOOH';
% k(:,i) =   2.06e-13.*exp(1300./ T);
% Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'HO2'; 
% fNISOPO2(i)=fNISOPO2(i)-1; fHO2(i)=fHO2(i)-1; fNISOPOOH(i)=fNISOPOOH(i)+1;

% combined mechanism, assuming 100% of the beta-1-2-INO forms NIEPOXOO.
i=i+1;
Rnames{i} = ' NISOPO2 + HO2 = 0.756*NISOPOOH + 0.244*OH + 0.004*MVK + 0.023*MACR + 0.027*HCHO + 0.027*NO2 + 0.217*NIEPOXOO';
k(:,i) =   2.06e-13.*exp(1300./ T);
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'HO2';
fNISOPO2(i)=fNISOPO2(i)-1; fHO2(i)=fHO2(i)-1; fNISOPOOH(i)=fNISOPOOH(i)+0.756;fOH(i)=fOH(i)+0.244;
fMVK(i)=fMVK(i)+0.004;fMACR(i)=fMACR(i)+0.023;fHCHO(i)=fHCHO(i)+0.027;fNO2(i)=fNO2(i)+0.027;fNIEPOXOO(i)=fNIEPOXOO(i)+0.217;

% %IS19. Removed. HC5OO lumped with IEPOXOO.
% i=i+1;
% Rnames{i} = 'HC5OO + HO2 = R6OOH - XC';
% k(:,i) =  2.06e-13.*exp(1300./ T);
% Gstr{i,1} = 'HC5OO'; Gstr{i,2} = 'HO2'; 
% fHC5OO(i)=fHC5OO(i)-1; fHO2(i)=fHO2(i)-1; fR6OOH(i)=fR6OOH(i)+1; fXC(i)=fXC(i)-1; 
% --------------ISOPNOO-----------------
% %IS141. Removed.
% i=i+1;
% Rnames{i} = 'ISOPNOOD + HO2 = RNO3I - XC  ';
% k(:,i) =   2.06e-13.*exp(1300./ T);
% Gstr{i,1} = 'ISOPNOOD'; Gstr{i,2} = 'HO2'; 
% fISOPNOOD(i)=fISOPNOOD(i)-1; fHO2(i)=fHO2(i)-1; fRNO3I(i)=fRNO3I(i)+1;fXC(i)=fXC(i)-0.68;

% %IS145. updated with the rxns below.
% i=i+1;
% Rnames{i} = 'ISOPNOOB + HO2 = RNO3I - XC ';
% k(:,i) =  2.06e-13.*exp(1300./ T);
% Gstr{i,1} = 'ISOPNOOB'; Gstr{i,2} = 'HO2'; 
% fISOPNOOB(i)=fISOPNOOB(i)-1; fHO2(i)=fHO2(i)-1; fRNO3I(i)=fRNO3I(i)+1;fXC(i)=fXC(i)-1;

i=i+1;
Rnames{i} = 'ISOPNOO + HO2 = 0.63IDHPN + 0.03MACRN + 0.07MVKN + 0.07HCHO + 0.26HOCCHO + 0.26HACET + 0.02MGLY + 0.02MECO3 + 0.303HO2 + 0.55OH + 0.27NO2';
k(:,i) = 2.6E-13*exp(1300./T); 
Gstr{i,1} = 'ISOPNOO'; Gstr{i,2} = 'HO2'; 
fISOPNOO(i)=fISOPNOO(i)-1; fHO2(i)=fHO2(i)-0.697;
fIDHPN(i)=fIDHPN(i)+0.63;fMACRN(i)=fMACRN(i)+0.03;fMVKN(i)=fMVKN(i)+0.07;fHCHO(i)=fHCHO(i)+0.07;fHOCCHO(i)=fHOCCHO(i)+0.26;fHACET(i)=fHACET(i)+0.26;fMGLY(i)=fMGLY(i)+0.02;fMECO3(i)=fMECO3(i)+0.00;fNO2(i)=fNO2(i)+0.25;fOH(i)=fOH(i)+0.55;
% --------------NIT1NO3OOA-----------------
% %IS36. updated with the rxn below.
% i=i+1;
% Rnames{i} =' NIT1NO3OOA + HO2 = 0.75*RCOOOH + 0.25*RCOOH + 0.25*O3 +  XN + 2*XC  ';
% k(:,i) = 5.20e-13.*exp(980./ T);
% Gstr{i,1} = 'NIT1NO3OOA'; Gstr{i,2} = 'HO2'; 
% fNIT1NO3OOA(i)=fNIT1NO3OOA(i)-1; fHO2(i)=fHO2(i)-1; fRCOOOH(i)=fRCOOOH(i)+0.75;fXN(i)=fXN(i)+1;fXC(i)=fXC(i)+2;
% fRCOOH(i)=fRCOOH(i)+0.25;fO3(i)=fO3(i)+0.25;

i=i+1;
Rnames{i} ='NIT1NO3OOA + HO2 = 0.37*INPA + 0.13*INCA + 0.13*O3 + 0.5*OH + 0.5*PROPNN + 0.5*CO + 0.5*HO2';
k(:,i) = 5.20e-13.*exp(980./ T);
Gstr{i,1} = 'NIT1NO3OOA'; Gstr{i,2} = 'HO2'; 
fNIT1NO3OOA(i)=fNIT1NO3OOA(i)-1; fHO2(i)=fHO2(i)-1; fINPA(i)=fINPA(i)+0.37; fINCA(i)=fINCA(i)+0.13; fO3(i)=fO3(i)+0.13;
fOH(i)=fOH(i)+0.5; fPROPNN(i)=fPROPNN(i)+0.5; fCO(i)=fCO(i)+0.5; fHO2(i)=fHO2(i)+0.5;

% %IS37. Removed.
% i=i+1;
% Rnames{i} =' NIT1NO3OOB + HO2 = RNO3I - XC + XN  ';
% k(:,i) = 2.06e-13.*exp(1300./ T);
% Gstr{i,1} = 'NIT1NO3OOB'; Gstr{i,2} = 'HO2'; 
% fNIT1NO3OOB(i)=fNIT1NO3OOB(i)-1; fHO2(i)=fHO2(i)-1;
% fRNO3I(i)=fRNO3I(i)+1;fXC(i)=fXC(i)-1;fXN(i)=fXN(i)+1;
% --------------NIT1OHOO-----------------
% %IS50 updated with the rxn below.
% i=i+1;
% Rnames{i} =' NIT1OHOO + HO2 = R6OOH + XN - XC';
% k(:,i) = 2.06e-13.*exp(1300./ T);
% Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'HO2'; 
% fNIT1OHOO(i)=fNIT1OHOO(i)-1; fHO2(i)=fHO2(i)-1;fR6OOH(i)=fR6OOH(i)+1;
% fXC(i)=fXC(i)-1;fXN(i)=fXN(i)+1;

i=i+1;
Rnames{i} =' NIT1OHOO + HO2 = 0.75*OH + 0.19*HO2 + 0.19*PROPNN + 0.19*GLY + 0.56*MACRN + 0.56*CO + 0.56*NO2 + 0.25*ICHNP';
k(:,i) = 2.06e-13.*exp(1300./ T);
Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'HO2'; 
fNIT1OHOO(i)=fNIT1OHOO(i)-1; fHO2(i)=fHO2(i)-1;fOH(i)=fOH(i)+0.75;fHO2(i)=fHO2(i)+0.19;fPROPNN(i)=fPROPNN(i)+0.19;
fGLY(i)=fGLY(i)+0.19;fMACRN(i)=fMACRN(i)+0.56;fCO(i)=fCO(i)+0.56;fNO2(i)=fNO2(i)+0.56;fICHNP(i)=fICHNP(i)+0.56;

% %IS102. Removed.
% i=i+1;
% Rnames{i} =' DIBOO + HO2 =  R6OOH - XC  ';
% k(:,i) = 2.06e-13.*exp(1300./ T);
% Gstr{i,1} = 'DIBOO'; Gstr{i,2} = 'HO2'; 
% fDIBOO(i)=fDIBOO(i)-1; fHO2(i)=fHO2(i)-1;fR6OOH(i)=fR6OOH(i)+1;
% fXC(i)=fXC(i)-1;
% --------------IEPOXOO-----------------
% %IS91. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IEPOXOO + HO2 = 0.725*HACET + 0.275*HOCCHO + 0.275*GLY + 0.275*MGLY + 1.125*OH + 0.825*HO2 + 0.200*CO2 + 0.375*HCHO + 0.074*FACD + 0.251*CO ';
% k(:,i) = 2.06e-13.*exp(1300./ T);
% Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'HO2'; 
% fIEPOXOO(i)=fIEPOXOO(i)-1;fHO2(i)=fHO2(i)-1;fHACET(i)=fHACET(i)+0.725;fHOCCHO(i)=fHOCCHO(i)+0.275;fGLY(i)=fGLY(i)+0.275;
% fMGLY(i)=fMGLY(i)+0.275;fOH(i)=fOH(i)+1.125;fHO2(i)=fHO2(i)+0.825;fCO2(i)=fCO2(i)+0.2;fHCHO(i)=fHCHO(i)+0.375;
% fFACD(i)=fFACD(i)+0.074;fCO(i)=fCO(i)+0.251;
i=i+1;
Rnames{i} = 'IEPOXOO + HO2 = 0.35*ICPDH + 0.65*OH + 0.052*C4HC + 0.26*HCHO  + 0.65*HO2 + 0.302*HACET + 0.286*CO + 0.078*C4DH + 0.312*HOCCHO + 0.218*MGLY';
k(:,i) = 2.38E-13*exp(1300./T);
Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'HO2'; 
fIEPOXOO(i)=fIEPOXOO(i)-1; fHO2(i)=fHO2(i)-0.35; fICPDH(i)=fICPDH(i)+0.35; fOH(i)=fOH(i)+0.65; fC4HC(i)=fC4HC(i)+0.052; fHCHO(i)=fHCHO(i)+0.26;
fHACET(i)=fHACET(i)+0.302; fCO(i)=fCO(i)+0.286; fC4DH(i)=fC4DH(i)+0.078; fHOCCHO(i)=fHOCCHO(i)+0.312; fMGLY(i)=fMGLY(i)+0.218;

% below are new additional RO2 + HO2 rxns.
% --------------ISOPOOHOO-----------------
% explicit three isomers
% i=i+1;
% Rnames{i} = 'ISOPOOHOO1 + HO2 = 0.59*IDHDP + 0.032*C4HP + 0.032*HCHO + 0.378*HPETHNL + 0.378*HACET + 0.41*OH + 0.41*HO2';
% k(:,i) = 2.47E-13*exp(1300./T); 
% Gstr{i,1} = 'ISOPOOHOO1'; Gstr{i,2} = 'HO2'; 
% fISOPOOHOO1(i)=fISOPOOHOO1(i)-1; fHO2(i)=fHO2(i)-0.59; fIDHDP(i)=fIDHDP(i)+0.59; fC4HP(i)=fC4HP(i)+0.032; fOH(i)=fOH(i)+0.41; fHCHO(i)=fHCHO(i)+0.032; fHPETHNL(i)=fHPETHNL(i)+0.378; fHACET(i)=fHACET(i)+0.378; 
% i=i+1;
% Rnames{i} = 'ISOPOOHOO2 + HO2 = 0.76*IDHDP + 0.17*C4HP + 0.17*HCHO + 0.07*HOCCHO + 0.07*HPAC + 0.24*OH + 0.24*HO2';
% k(:,i) = 2.47E-13*exp(1300./T); 
% Gstr{i,1} = 'ISOPOOHOO2'; Gstr{i,2} = 'HO2'; 
% fISOPOOHOO2(i)=fISOPOOHOO2(i)-1; fHO2(i)=fHO2(i)-0.76; fIDHDP(i)=fIDHDP(i)+0.76; fC4HP(i)=fC4HP(i)+0.17; fHCHO(i)=fHCHO(i)+0.17; fHOCCHO(i)=fHOCCHO(i)+0.07; fHPAC(i)=fHPAC(i)+0.07; fOH(i)=fOH(i)+0.24; 
% i=i+1;
% Rnames{i} = 'ISOPOOHOO3 + HO2 = 0.35*IDHDP + 0.65*HOCCHO + 0.65*HACET + 1.3*OH';
% k(:,i) = 2.47E-13*exp(1300./T); 
% Gstr{i,1} = 'ISOPOOHOO3'; Gstr{i,2} = 'HO2'; 
% fISOPOOHOO3(i)=fISOPOOHOO3(i)-1; fHO2(i)=fHO2(i)-1; fIDHDP(i)=fIDHDP(i)+0.35; fHOCCHO(i)=fHOCCHO(i)+0.65; fHACET(i)=fHACET(i)+0.65; fOH(i)=fOH(i)+1.3;

% lumped ISOPOOHOO
i=i+1;
Rnames{i} = 'ISOPOOHOO + HO2 = 0.6*IDHDP + 0.05*C4HP + 0.06*HCHO + 0.05*HPETHNL + 0.3*HACET + 0.34*HOCCHO + 0.02*HPAC + 0.804*OH + 0.154*HO2';
k(:,i) = 2.47E-13*exp(1300./T); 
Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'HO2'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fHO2(i)=fHO2(i)-0.846; 
fIDHDP(i)=fIDHDP(i)+0.6;fC4HP(i)=fC4HP(i)+0.05;fOH(i)=fOH(i)+0.804;fHCHO(i)=fHCHO(i)+0.06; fHPETHNL(i)=fHPETHNL(i)+0.05; fHACET(i)=fHACET(i)+0.3; 
fHOCCHO(i)=fHOCCHO(i)+0.34; fHPAC(i)=fHPAC(i)+0.02;

% --------------IHPNOO-----------------
i=i+1;
Rnames{i} = 'IHPNOO + HO2 = 0.15*IHNDP + 0.85*PROPNN + 0.85*HO2 + 0.85*HPETHNL + 0.85*OH';
k(:,i) = 2.6E-13*exp(1300./T);
Gstr{i,1} = 'IHPNOO'; Gstr{i,2} = 'HO2'; 
fIHPNOO(i)=fIHPNOO(i)-1; fHO2(i)=fHO2(i)-1;
fIHNDP(i)=fIHNDP(i)+0.15;fOH(i)=fOH(i)+0.85;fPROPNN(i)=fPROPNN(i)+0.85;fHO2(i)=fHO2(i)+0.85;
fHPETHNL(i)=fHPETHNL(i)+0.85;
% --------------IHDNOO-----------------
i=i+1;
Rnames{i} = 'IHDNOO + HO2 = 0.2*NO2 + 0.2*HCHO + 0.2*MVKN + 0.8*IHPDN';
k(:,i) = 2.6E-13*exp(1300./T);
Gstr{i,1} = 'IHDNOO'; Gstr{i,2} = 'HO2'; 
fIHDNOO(i)=fIHDNOO(i)-1; fHO2(i)=fHO2(i)-1;fNO2(i)=fNO2(i)+0.2;fHCHO(i)=fHCHO(i)+0.2;fMVKN(i)=fMVKN(i)+0.2;fIHPDN(i)=fIHPDN(i)+0.8;
% --------------NIEPOXOO-----------------
i=i+1;
Rnames{i} = 'NIEPOXOO + HO2 = INPE';
k(:,i) = 2.6E-13*exp(1300./T);
Gstr{i,1} = 'NIEPOXOO'; Gstr{i,2} = 'HO2'; 
fNIEPOXOO(i)=fNIEPOXOO(i)-1; fHO2(i)=fHO2(i)-1; fINPE(i)=fINPE(i)+1;
%% RO2 + RO2
% %IS4. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' ISOPO2 + MEO2 = 0.45*HO2 + 0.37*HCHO + 0.23*MVK + 0.15*MACR + 0.05*DIBOO+ 0.06*HC5 + 0.02*ARO2MN + 0.5*PRD2 + 0.5*HCHO + 0.5*HO2 + 0.25*HCHO +0.25*MEOH - 0.62*XC  ';
% k(:,i) = 1.8e-12;
% Gstr{i,1} = 'ISOPO2'; Gstr{i,2} = 'MEO2';
% fISOPO2(i)=fISOPO2(i)-1;fMEO2(i)=fMEO2(i)-1;
% fHO2(i)=fHO2(i)+0.95;fMACR(i)=fMACR(i)+0.15;fDIBOO(i)=fDIBOO(i)+0.05;fMVK(i)=fMVK(i)+0.23;
% fPRD2(i)=fPRD2(i)+0.5;fHCHO(i)=fHCHO(i)+0.37;fHC5(i)=fHC5(i)+0.06;fARO2MN(i)=fARO2MN(i)+0.02;
% fHCHO(i)=fHCHO(i)+0.75;fMEOH(i)=fMEOH(i)+0.25;fXC(i)=fXC(i)-0.62;

% --------------ISOP1OHOO and ISOP4OHOO-----------------
i=i+1;
Rnames{i} = 'ISOP1OHOO + MEO2 = 0.8*MVK + 1.3*HO2 + 1.55*HCHO + 0.2*IDH + 0.25*MEOH';
k(:,i) = (1.1644-T.*7.0485E-4)*2E-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'MEO2';
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fMEO2(i)=fMEO2(i)-1;fMVK(i)=fMVK(i)+0.8; fHCHO(i)=fHCHO(i)+1.55; fHO2(i)=fHO2(i)+1.3; fIDH(i)=fIDH(i)+0.2;fMEOH(i)=fMEOH(i)+0.25;
i=i+1;
Rnames{i} = 'ISOP1OHOO + MEO2 = 0.86*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.44*C4HP + 0.1*IDH + 0.75*HCHO + 0.25*MEOH';
k(:,i) = (T.*7.0485E-4-0.1644)*2E-12; 
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'MEO2'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fMEO2(i)=fMEO2(i)-1;fHO2(i)=fHO2(i)+0.86;fHC5(i)=fHC5(i)+0.46;fC4HP(i)=fC4HP(i)+0.44; fCO(i)=fCO(i)+0.44; fOH(i)=fOH(i)+0.44;fIDH(i)=fIDH(i)+0.1;fHCHO(i)=fHCHO(i)+0.75;fMEOH(i)=fMEOH(i)+0.25;
i=i+1;
Rnames{i} = 'ISOP4OHOO + MEO2 = 0.8*MACR + 0.8*HO2 + 0.8*HCHO + 0.1*HC5 + 0.1*IDH + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
k(:,i) = (1.2038-T.*9.0435E-4)*2E-12; 
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'MEO2';
fISOP4OHOO(i)=fISOP4OHOO(i)-1;fMEO2(i)=fMEO2(i)-1;fMACR(i)=fMACR(i)+0.8; fHO2(i)=fHO2(i)+1.3; fHCHO(i)=fHCHO(i)+1.55;
fHC5(i)=fHC5(i)+0.1;fIDH(i)=fIDH(i)+0.1;fMEOH(i)=fMEOH(i)+0.25;
i=i+1;
Rnames{i} = 'ISOP4OHOO + MEO2 = 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.44*C4HP + 0.1*IDH + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
k(:,i) = (T.*9.0435E-4-0.2038)*2E-12; 
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'MEO2';
fISOP4OHOO(i)=fISOP4OHOO(i)-1;fMEO2(i)=fMEO2(i)-1;fHO2(i)=fHO2(i)+0.86; fHC5(i)=fHC5(i)+0.46; fC4HP(i)=fC4HP(i)+0.44; fCO(i)=fCO(i)+0.44; fOH(i)=fOH(i)+0.44;fIDH(i)=fIDH(i)+0.1;
fHCHO(i)=fHCHO(i)+0.75;fMEOH(i)=fMEOH(i)+0.25;

% %IS5. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' ISOPO2 + RO2C = 0.45*HO2 + 0.37*HCHO + 0.23*MVK + 0.15*MACR + 0.05*DIBOO+ 0.06*HC5 + 0.02*ARO2MN + 0.5*PRD2 - 0.62*XC ';
% k(:,i) = 6.8e-13;
% Gstr{i,1} = 'ISOPO2'; Gstr{i,2} = 'RO2C';
% fISOPO2(i)=fISOPO2(i)-1;fRO2C(i)=fRO2C(i)-1;
% fHO2(i)=fHO2(i)+0.45;fDIBOO(i)=fDIBOO(i)+0.05;fMVK(i)=fMVK(i)+0.23;fMACR(i)=fMACR(i)+0.15;
% fPRD2(i)=fPRD2(i)+0.5;fHCHO(i)=fHCHO(i)+0.37;fHC5(i)=fHC5(i)+0.06;fARO2MN(i)=fARO2MN(i)+0.02;
% fXC(i)=fXC(i)-0.62;
i=i+1;
Rnames{i} = 'ISOP1OHOO + RO2C = 0.8*MVK + 0.8*HO2 + 0.8*HCHO + 0.2*IDH';
k(:,i) = (1.1644-T.*7.0485E-4)*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'RO2C';
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fRO2C(i)=fRO2C(i)-1;fMVK(i)=fMVK(i)+0.8; fHCHO(i)=fHCHO(i)+0.8; fHO2(i)=fHO2(i)+0.8; fIDH(i)=fIDH(i)+0.2;
i=i+1;
Rnames{i} = 'ISOP1OHOO + RO2C = 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.44*C4HP + 0.1*IDH';
k(:,i) = (T.*7.0485E-4-0.1644)*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'RO2C'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fRO2C(i)=fRO2C(i)-1;fHO2(i)=fHO2(i)+0.36;fHC5(i)=fHC5(i)+0.46;fC4HP(i)=fC4HP(i)+0.44; fCO(i)=fCO(i)+0.44; fOH(i)=fOH(i)+0.44;fIDH(i)=fIDH(i)+0.1;
i=i+1;
Rnames{i} = 'ISOP4OHOO + RO2C = 0.8*MACR + 0.8*HO2 + 0.8*HCHO + 0.1*HC5 + 0.1*IDH';
k(:,i) = (1.2038-T.*9.0435E-4)*2e-12;
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'RO2C'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1;fRO2C(i)=fRO2C(i)-1;fMACR(i)=fMACR(i)+0.8; fHO2(i)=fHO2(i)+0.8; fHCHO(i)=fHCHO(i)+0.8;
fHC5(i)=fHC5(i)+0.1;fIDH(i)=fIDH(i)+0.1;
i=i+1;
Rnames{i} = 'ISOP4OHOO + RO2C = 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.44*C4HP + 0.1*IDH';
k(:,i) = (T.*9.0435E-4-0.2038)*2e-12;
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'RO2C';
fISOP4OHOO(i)=fISOP4OHOO(i)-1;fRO2C(i)=fRO2C(i)-1;fHO2(i)=fHO2(i)+0.36; fHC5(i)=fHC5(i)+0.46; fC4HP(i)=fC4HP(i)+0.44; fCO(i)=fCO(i)+0.44; fOH(i)=fOH(i)+0.44;fIDH(i)=fIDH(i)+0.1;

% %IS6. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' ISOPO2 + ISOPO2 = 0.91*HO2 + 0.75*HCHO + 0.45*MVK + 0.29*MACR +0.09*DIBOO + 0.11*HC5 + 0.05*ARO2MN + PRD2 - 1.24*XC';
% k(:,i) = 2.3e-12;
% Gstr{i,1} = 'ISOPO2'; Gstr{i,2} = 'ISOPO2';
% fISOPO2(i)=fISOPO2(i)-1;fISOPO2(i)=fISOPO2(i)-1;
% fHO2(i)=fHO2(i)+0.91;fDIBOO(i)=fDIBOO(i)+0.09;fMVK(i)=fMVK(i)+0.45;fMACR(i)=fMACR(i)+0.29;
% fPRD2(i)=fPRD2(i)+1;fHCHO(i)=fHCHO(i)+0.75;fHC5(i)=fHC5(i)+0.11;fARO2MN(i)=fARO2MN(i)+0.05;
% fXC(i)=fXC(i)-1.24;
i=i+1;
Rnames{i} = 'ISOP1OHOO + ISOP1OHOO = 1.6*MVK + 1.6*HO2 + 1.6*HCHO + 0.4*IDH';
k(:,i) = (1.1644-T.*7.0485E-4)*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'ISOP1OHOO';
fISOP1OHOO(i)=fISOP1OHOO(i)-2;fMVK(i)=fMVK(i)+1.6; fHCHO(i)=fHCHO(i)+1.6; fHO2(i)=fHO2(i)+1.6; fIDH(i)=fIDH(i)+0.4;
i=i+1;
Rnames{i} = 'ISOP1OHOO + ISOP1OHOO = 0.72*HO2 + 0.92*HC5 + 0.88*CO + 0.88*OH + 0.88*C4HP + 0.2*IDH';
k(:,i) = (T.*7.0485E-4-0.1644)*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'ISOP1OHOO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-2;fHO2(i)=fHO2(i)+0.72;fHC5(i)=fHC5(i)+0.92;fC4HP(i)=fC4HP(i)+0.88; fCO(i)=fCO(i)+0.88; fOH(i)=fOH(i)+0.88;fIDH(i)=fIDH(i)+0.2;
i=i+1;
Rnames{i} = 'ISOP4OHOO + ISOP4OHOO = 1.6*MACR + 1.6*HO2 + 1.6*HCHO + 0.2*HC5 + 0.2*IDH';
k(:,i) = (1.2038-T.*9.0435E-4)*2e-12; 
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'ISOP4OHOO'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-2;fMACR(i)=fMACR(i)+1.6; fHO2(i)=fHO2(i)+1.6; fHCHO(i)=fHCHO(i)+1.6;
fHC5(i)=fHC5(i)+0.2;fIDH(i)=fIDH(i)+0.2;
i=i+1;
Rnames{i} = 'ISOP4OHOO + ISOP4OHOO = 0.72*HO2 + 0.92*HC5 + 0.88*CO + 0.88*OH + 0.88*C4HP + 0.2*IDH';
k(:,i) = (T.*9.0435E-4-0.2038)*2e-12;
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'ISOP4OHOO';
fISOP4OHOO(i)=fISOP4OHOO(i)-2;fHO2(i)=fHO2(i)+0.72; fHC5(i)=fHC5(i)+0.92; fC4HP(i)=fC4HP(i)+0.88; fCO(i)=fCO(i)+0.88; fOH(i)=fOH(i)+0.88;fIDH(i)=fIDH(i)+0.2;
i=i+1;
Rnames{i} = 'ISOP1OHOO + ISOP4OHOO = 0.8*MVK + 0.8*HO2 + 0.8*HCHO + 0.2*IDH + 0.8*MACR + 0.8*HO2 + 0.8*HCHO + 0.1*HC5 + 0.1*IDH';
k(:,i) = (2.3682-T.*1.6092E-3)/2*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'ISOP4OHOO';
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fISOP4OHOO(i)=fISOP4OHOO(i)-1;
fMVK(i)=fMVK(i)+0.8;fMACR(i)=fMACR(i)+0.8; fHCHO(i)=fHCHO(i)+1.6; fHO2(i)=fHO2(i)+1.6; fIDH(i)=fIDH(i)+0.3;fHC5(i)=fHC5(i)+0.1;
i=i+1;
Rnames{i} = 'ISOP1OHOO + ISOP4OHOO = 0.8*MVK + 0.8*HO2 + 0.8*HCHO + 0.2*IDH + 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.44*C4HP + 0.1*IDH';
k(:,i) = (0.9606+T.*1.995E-4)/2*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'ISOP4OHOO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fISOP4OHOO(i)=fISOP4OHOO(i)-1;
fMVK(i)=fMVK(i)+0.8; fHCHO(i)=fHCHO(i)+0.8; fHO2(i)=fHO2(i)+1.16; fIDH(i)=fIDH(i)+0.3;fHC5(i)=fHC5(i)+0.46; fC4HP(i)=fC4HP(i)+0.44; fCO(i)=fCO(i)+0.44; fOH(i)=fOH(i)+0.44;
i=i+1;
Rnames{i} = 'ISOP1OHOO + ISOP4OHOO = 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.44*C4HP + 0.1*IDH + 0.8*MACR + 0.8*HO2 + 0.8*HCHO + 0.1*HC5 + 0.1*IDH';
k(:,i) = (1.0394-T.*1.995E-4)/2*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'ISOP4OHOO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fISOP4OHOO(i)=fISOP4OHOO(i)-1;
fHO2(i)=fHO2(i)+1.16;fHC5(i)=fHC5(i)+0.56;fC4HP(i)=fC4HP(i)+0.44; fCO(i)=fCO(i)+0.44; fOH(i)=fOH(i)+0.44;fIDH(i)=fIDH(i)+0.2;
fMACR(i)=fMACR(i)+0.8; fHCHO(i)=fHCHO(i)+0.8;
i=i+1;
Rnames{i} = 'ISOP1OHOO + ISOP4OHOO = 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.88*C4HP + 0.1*IDH + 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.1*IDH';
k(:,i) = (T.*1.6092E-3-0.3682)/2*2e-12; 
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'ISOP4OHOO'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fISOP4OHOO(i)=fISOP4OHOO(i)-1;
fHO2(i)=fHO2(i)+0.72;fHC5(i)=fHC5(i)+0.92;fC4HP(i)=fC4HP(i)+0.88; fCO(i)=fCO(i)+0.88; fOH(i)=fOH(i)+0.88; fIDH(i)=fIDH(i)+0.2;

% %IS7. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' ISOPO2 + MECO3 = MEO2 + CO2 + 0.91*HO2 + 0.75*HCHO + 0.45*MVK +0.29*MACR + 0.09*DIBOO + 0.11*HC5 + 0.05*ARO2MN -0.16*XC';
% k(:,i) = 4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'ISOPO2'; Gstr{i,2} = 'MECO3';
% fISOPO2(i)=fISOPO2(i)-1;fMECO3(i)=fMECO3(i)-1;
% fHO2(i)=fHO2(i)+0.91;fDIBOO(i)=fDIBOO(i)+0.09;fMVK(i)=fMVK(i)+0.45;fMACR(i)=fMACR(i)+0.29;
% fHCHO(i)=fHCHO(i)+0.75;fHC5(i)=fHC5(i)+0.11;fARO2MN(i)=fARO2MN(i)+0.05;
% fXC(i)=fXC(i)-0.16;fMEO2(i)=fMEO2(i)+1;fCO2(i)=fCO2(i)+1;
i=i+1;
Rnames{i} = 'ISOP1OHOO + MECO3 = 0.8*MVK + 0.8*HO2 + 0.8*HCHO + 0.2*IDH + MEO2 + CO2';
k(:,i) = (1.1644-T.*7.0485E-4)*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'MECO3';
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fMECO3(i)=fMECO3(i)-1;fMVK(i)=fMVK(i)+0.8; fHCHO(i)=fHCHO(i)+0.8; fHO2(i)=fHO2(i)+0.8; fIDH(i)=fIDH(i)+0.2;fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'ISOP1OHOO + MECO3 = 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.44*C4HP + 0.1*IDH + MEO2 + CO2';
k(:,i) = (T.*7.0485E-4-0.1644)*2e-12;
Gstr{i,1} = 'ISOP1OHOO'; Gstr{i,2} = 'MECO3'; 
fISOP1OHOO(i)=fISOP1OHOO(i)-1;fMECO3(i)=fMECO3(i)-1;fHO2(i)=fHO2(i)+0.36;fHC5(i)=fHC5(i)+0.46;fC4HP(i)=fC4HP(i)+0.44; fCO(i)=fCO(i)+0.44; fOH(i)=fOH(i)+0.44;fIDH(i)=fIDH(i)+0.1;fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'ISOP4OHOO + MECO3 = 0.8*MACR + 0.8*HO2 + 0.8*HCHO + 0.1*HC5 + 0.1*IDH + MEO2 + CO2';
k(:,i) = (1.2038-T.*9.0435E-4)*2e-12;
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'MECO3'; 
fISOP4OHOO(i)=fISOP4OHOO(i)-1;fMECO3(i)=fMECO3(i)-1;fMACR(i)=fMACR(i)+0.8; fHO2(i)=fHO2(i)+0.8; fHCHO(i)=fHCHO(i)+0.8;
fHC5(i)=fHC5(i)+0.1;fIDH(i)=fIDH(i)+0.1;fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'ISOP4OHOO + MECO3 = 0.36*HO2 + 0.46*HC5 + 0.44*CO + 0.44*OH + 0.44*C4HP + 0.1*IDH + MEO2 + CO2';
k(:,i) = (T.*9.0435E-4-0.2038)*2e-12;
Gstr{i,1} = 'ISOP4OHOO'; Gstr{i,2} = 'MECO3';
fISOP4OHOO(i)=fISOP4OHOO(i)-1;fMECO3(i)=fMECO3(i)-1;fHO2(i)=fHO2(i)+0.36; fHC5(i)=fHC5(i)+0.46; fC4HP(i)=fC4HP(i)+0.44; fCO(i)=fCO(i)+0.44; fOH(i)=fOH(i)+0.44;fIDH(i)=fIDH(i)+0.1;fMEO2(i)=fMEO2(i)+1;

% --------------MACROO-----------------
% %IS65. updated with the rxns below.
% i=i+1;
% Rnames{i} =' MACROO + MEO2 = 0.50*HO2 + 0.424*HACET + 0.424*CO + 0.076*HCHO + 0.076*MGLY + 0.5*PRD2 + 0.25*HCHO + 0.25*MEOH + 0.5*HCHO + 0.5*HO2 - XC';
% k(:,i) = 2e-13;
% Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'MEO2'; 
% fMACROO(i)=fMACROO(i)-1; fMEO2(i)=fMEO2(i)-1;fHO2(i)=fHO2(i)+1;fPRD2(i)=fPRD2(i)+0.5;
% fCO(i)=fCO(i)+0.424;fMGLY(i)=fMGLY(i)+0.076;fHCHO(i)=fHCHO(i)+0.076;fHACET(i)=fHACET(i)+0.424;
% fMEOH(i)=fMEOH(i)+0.25;fHCHO(i)=fHCHO(i)+0.75;fXC(i)=fXC(i)-1;
i=i+1;
Rnames{i} = 'MACROO + MEO2 = 0.6*HACET + 0.6*CO + 0.6*HO2 + 0.1*MGLY + 0.1*HCHO + 0.3*C4DH + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
k(:,i) = 2E-12;
Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'MEO2'; 
fMACROO(i)=fMACROO(i)-1; fMEO2(i)=fMEO2(i)-1; fHACET(i)=fHACET(i)+0.6; fCO(i)=fCO(i)+0.6; fHO2(i)=fHO2(i)+1.1; fMGLY(i)=fMGLY(i)+0.1; fHCHO(i)=fHCHO(i)+0.85; fC4DH(i)=fC4DH(i)+0.3; fMEOH(i)=fMEOH(i)+0.25; 


% %IS66. updated with the rxns below.
% i=i+1;
% Rnames{i} =' MACROO + RO2C = 0.50*HO2 + 0.424*HACET + 0.424*CO + 0.076*HCHO + 0.076*MGLY + 0.5*PRD2 - XC';
% k(:,i) = 3.5e-14;
% Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'RO2C'; 
% fMACROO(i)=fMACROO(i)-1; fRO2C(i)=fRO2C(i)-1;fHO2(i)=fHO2(i)+0.5;fPRD2(i)=fPRD2(i)+0.5;
% fCO(i)=fCO(i)+0.424;fMGLY(i)=fMGLY(i)+0.076;fHCHO(i)=fHCHO(i)+0.076;fHACET(i)=fHACET(i)+0.424;
% fXC(i)=fXC(i)-1;
i=i+1;
Rnames{i} = 'MACROO + RO2C = 0.6*HACET + 0.6*CO + 0.6*HO2 + 0.1*MGLY + 0.1*HCHO + 0.3*C4DH';
k(:,i) = 2E-12;
Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'RO2C'; 
fMACROO(i)=fMACROO(i)-1; fRO2C(i)=fRO2C(i)-1; fHACET(i)=fHACET(i)+0.6; fCO(i)=fCO(i)+0.6; fHO2(i)=fHO2(i)+0.6; fMGLY(i)=fMGLY(i)+0.1; fHCHO(i)=fHCHO(i)+0.1; fC4DH(i)=fC4DH(i)+0.3; 

% %IS67. updated with the rxns below.
% i=i+1;
% Rnames{i} =' MACROO + MECO3 = MEO2 + CO2 + HO2 + 0.15*MGLY + 0.85*HACET + 0.85*CO + 0.15*HCHO';
% k(:,i) = 4.40e-13.*exp(1070./ T);
% Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'MECO3'; 
% fMACROO(i)=fMACROO(i)-1; fMECO3(i)=fMECO3(i)-1;fHO2(i)=fHO2(i)+1;fMEO2(i)=fMEO2(i)+1;
% fCO2(i)=fCO2(i)+1;fMGLY(i)=fMGLY(i)+0.15;fHCHO(i)=fHCHO(i)+0.15;fHACET(i)=fHACET(i)+0.85;
% fCO(i)=fCO(i)+0.85;
i=i+1;
Rnames{i} = 'MACROO + MECO3 = 0.6*HACET + 0.6*CO + 0.6*HO2 + 0.1*MGLY + 0.1*HCHO + 0.3*C4DH + MEO2 + CO2';
k(:,i) = 2E-12;
Gstr{i,1} = 'MACROO'; Gstr{i,2} = 'MECO3'; 
fMACROO(i)=fMACROO(i)-1; fMECO3(i)=fMECO3(i)-1; fHACET(i)=fHACET(i)+0.6; fCO(i)=fCO(i)+0.6; fHO2(i)=fHO2(i)+0.6; fMGLY(i)=fMGLY(i)+0.1; fHCHO(i)=fHCHO(i)+0.1; fC4DH(i)=fC4DH(i)+0.3; fMEO2(i)=fMEO2(i)+1; 

% --------------IMACO3-----------------
% %IA72. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + MEO2 = HCHO + HO2 + CO + CO2 + HCHO + MEO2 ';
% k(:,i) = 2.00e-12.*exp(500./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'MEO2'; 
% fIMACO3(i)=fIMACO3(i)-1;fMEO2(i)=fMEO2(i)-1;fHO2(i)=fHO2(i)+1;fCO(i)=fCO(i)+1;fCO2(i)=fCO2(i)+1;
% fHCHO(i)=fHCHO(i)+2;fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'IMACO3 + MEO2 = 0.545*MECO3 + 0.755*MEO2 + 0.455*CO + HCHO + 0.7*CO2 + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
k(:,i) = 2E-12; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'MEO2'; 
fIMACO3(i)=fIMACO3(i)-1; fMEO2(i)=fMEO2(i)-0.245; fMECO3(i)=fMECO3(i)+0.545; fCO(i)=fCO(i)+0.455; fHCHO(i)=fHCHO(i)+1.75;fHO2(i)=fHO2(i)+0.5;fMEOH(i)=fMEOH(i)+0.25;

% %IA73. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + RO2C = CO + CO2 + HCHO + MEO2  ';
% k(:,i) = 4.40e-13.*exp(1070./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'RO2C'; 
% fIMACO3(i)=fIMACO3(i)-1;fRO2C(i)=fRO2C(i)-1;fCO(i)=fCO(i)+1;fCO2(i)=fCO2(i)+1;
% fHCHO(i)=fHCHO(i)+1;fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'IMACO3 + RO2C = 0.545*MECO3 + 0.755*MEO2 + 0.455*CO + HCHO + 0.7*CO2';
k(:,i) = 2E-12; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'RO2C'; 
fIMACO3(i)=fIMACO3(i)-1; fRO2C(i)=fRO2C(i)-1; fMECO3(i)=fMECO3(i)+0.545; fMEO2(i)=fMEO2(i)+0.755; fCO(i)=fCO(i)+0.455; fHCHO(i)=fHCHO(i)+1;

% %IA74. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + RO2XC = CO + CO2 + HCHO + MEO2  ';
% k(:,i) = 4.40e-13.*exp(1070./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'RO2XC'; 
% fIMACO3(i)=fIMACO3(i)-1;fRO2XC(i)=fRO2XC(i)-1;fCO(i)=fCO(i)+1;fCO2(i)=fCO2(i)+1;
% fHCHO(i)=fHCHO(i)+1;fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'IMACO3 + RO2XC = 0.545*MECO3 + 0.755*MEO2 + 0.455*CO + HCHO + 0.7*CO2';
k(:,i) = 2E-12; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'RO2XC'; 
fIMACO3(i)=fIMACO3(i)-1; fRO2XC(i)=fRO2XC(i)-1; fMECO3(i)=fMECO3(i)+0.545; fMEO2(i)=fMEO2(i)+0.755; fCO(i)=fCO(i)+0.455; fHCHO(i)=fHCHO(i)+1;

% %IA75. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + MECO3 = CO2 + MEO2 + CO + CO2 + HCHO + MEO2  ';
% k(:,i) = 2.90e-12.*exp(500./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'MECO3'; 
% fIMACO3(i)=fIMACO3(i)-1;fMECO3(i)=fMECO3(i)-1;fCO(i)=fCO(i)+1;fCO2(i)=fCO2(i)+2;
% fHCHO(i)=fHCHO(i)+1;fMEO2(i)=fMEO2(i)+2;
i=i+1;
Rnames{i} = 'IMACO3 + MECO3 = 0.545*MECO3 + 0.755*MEO2 + 0.455*CO + HCHO + 0.7*CO2 + MEO2 + CO2';
k(:,i) = 2E-12; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'MECO3'; 
fIMACO3(i)=fIMACO3(i)-1; fMECO3(i)=fMECO3(i)-1; fMECO3(i)=fMECO3(i)+0.545; fMEO2(i)=fMEO2(i)+1.755; fCO(i)=fCO(i)+0.455; fHCHO(i)=fHCHO(i)+1;

% %IA76. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + RCO3 = CO + CO2 + HCHO + MEO2 + RO2C + xHO2 + yROOH + xCCHO + CO2 ';
% k(:,i) = 2.90e-12.*exp(500./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'RCO3'; 
% fIMACO3(i)=fIMACO3(i)-1;fRCO3(i)=fRCO3(i)-1;fCO(i)=fCO(i)+1;fCO2(i)=fCO2(i)+2;
% fHCHO(i)=fHCHO(i)+1;fMEO2(i)=fMEO2(i)+1;fRO2C(i)=fRO2C(i)+1;fxHO2(i)=fxHO2(i)+1;fyROOH(i)=fyROOH(i)+1;
% fxCCHO(i)=fxCCHO(i)+1;
i=i+1;
Rnames{i} = 'IMACO3 + RCO3 = 0.545*MECO3 + 0.755*MEO2 + 0.455*CO + HCHO + 0.7*CO2 + RO2C + xHO2 + yROOH + xCCHO + CO2';
k(:,i) = 2E-12; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'RCO3'; 
fIMACO3(i)=fIMACO3(i)-1; fRCO3(i)=fRCO3(i)-1; fMECO3(i)=fMECO3(i)+0.545; fMEO2(i)=fMEO2(i)+0.755; fCO(i)=fCO(i)+0.455; fHCHO(i)=fHCHO(i)+1;
fRO2C(i)=fRO2C(i)+1;fxHO2(i)=fxHO2(i)+1;fyROOH(i)=fyROOH(i)+1;fxCCHO(i)=fxCCHO(i)+1;

% %IA77. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + BZCO3 = CO + CO2 + HCHO + MEO2 + BZO + RO2C + CO2 ';
% k(:,i) = 2.90e-12.*exp(500./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'BZCO3'; 
% fIMACO3(i)=fIMACO3(i)-1;fBZCO3(i)=fBZCO3(i)-1;fCO(i)=fCO(i)+1;fCO2(i)=fCO2(i)+2;
% fHCHO(i)=fHCHO(i)+1;fMEO2(i)=fMEO2(i)+1;fRO2C(i)=fRO2C(i)+1;fBZO(i)=fBZO(i)+1;
i=i+1;
Rnames{i} = 'IMACO3 + BZCO3 = 0.545*MECO3 + 0.755*MEO2 + 0.455*CO + HCHO + 0.7*CO2 + BZO + RO2C + CO2';
k(:,i) = 2E-12; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'BZCO3'; 
fIMACO3(i)=fIMACO3(i)-1; fBZCO3(i)=fBZCO3(i)-1; fMECO3(i)=fMECO3(i)+0.545; fMEO2(i)=fMEO2(i)+0.755; fCO(i)=fCO(i)+0.455; fHCHO(i)=fHCHO(i)+1;
fRO2C(i)=fRO2C(i)+1;fBZO(i)=fBZO(i)+1;

% %IA78. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + MACO3 = 2*CO + 2*CO2 + 2*HCHO + 2*MEO2 ';
% k(:,i) = 2.90e-12.*exp(500./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'MACO3'; 
% fIMACO3(i)=fIMACO3(i)-1;fMACO3(i)=fMACO3(i)-1;fCO(i)=fCO(i)+2;fCO2(i)=fCO2(i)+2;
% fHCHO(i)=fHCHO(i)+2;fMEO2(i)=fMEO2(i)+2;
i=i+1;
Rnames{i} = 'IMACO3 + MACO3 = 0.545*MECO3 + 0.755*MEO2 + 0.455*CO + HCHO + 0.7*CO2 + CO + CO2 + HCHO + MEO2';
k(:,i) = 2E-12; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'MACO3'; 
fIMACO3(i)=fIMACO3(i)-1; fMACO3(i)=fMACO3(i)-1; fMECO3(i)=fMECO3(i)+0.545; fMEO2(i)=fMEO2(i)+1.755; fCO(i)=fCO(i)+1.455; fHCHO(i)=fHCHO(i)+2;

% %IA79. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMACO3 + IMACO3 = 2*CO + 2*CO2 + 2*HCHO + 2*MEO2 ';
% k(:,i) = 2.90e-12.*exp(500./ T);
% Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'IMACO3'; 
% fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)-1;fCO(i)=fCO(i)+2;fCO2(i)=fCO2(i)+2;
% fHCHO(i)=fHCHO(i)+2;fMEO2(i)=fMEO2(i)+2;
i=i+1;
Rnames{i} = 'IMACO3 + IMACO3 = 1.09*MECO3 + 1.51*MEO2 + 0.91*CO + 2*HCHO + 1.4*CO2';
k(:,i) = 2E-12; 
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'IMACO3'; 
fIMACO3(i)=fIMACO3(i)-2; fMECO3(i)=fMECO3(i)+1.09; fMEO2(i)=fMEO2(i)+1.51; fCO(i)=fCO(i)+0.91; fHCHO(i)=fHCHO(i)+2;

% --------------MVKOO-----------------
% %IS59. updated with the rxns below.
% i=i+1;
% Rnames{i} = ' MVKOO + MEO2 = 0.35*HOCCHO + 0.35*MECO3 + 0.15*MGLY + 0.15*HCHO +0.15*HO2 + 0.5*MEK + 0.25*HCHO + 0.25*MEOH + 0.5*HCHO + 0.50*HO2 ';
% k(:,i) = 2e-13;
% Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'MEO2'; 
% fMVKOO(i)=fMVKOO(i)-1; fMEO2(i)=fMEO2(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.35; fMECO3(i)=fMECO3(i)+0.35;fMGLY(i)=fMGLY(i)+0.15;
% fHCHO(i)=fHCHO(i)+0.9;fHO2(i)=fHO2(i)+0.15;fMEK(i)=fMEK(i)+0.5;fMEOH(i)=fMEOH(i)+0.25;fHO2(i)=fHO2(i)+0.5;
i=i+1;
Rnames{i} = 'MVKOO + MEO2 = 0.455*MECO3 + 0.455*HOCCHO + 0.145*MGLY + 0.145*HCHO + 0.145*HO2 + 0.2*C4HC + 0.2*C4DH + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
k(:,i) = 2E-12;
Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'MEO2'; 
fMVKOO(i)=fMVKOO(i)-1; fMEO2(i)=fMEO2(i)-1; fMECO3(i)=fMECO3(i)+0.455;fHOCCHO(i)=fHOCCHO(i)+0.455; fMGLY(i)=fMGLY(i)+0.145; fHCHO(i)=fHCHO(i)+0.895; fHO2(i)=fHO2(i)+0.645;fC4HC(i)=fC4HC(i)+0.2;fC4DH(i)=fC4DH(i)+0.2;fMEOH(i)=fMEOH(i)+0.25;

% %IS60. updated with the rxns below.
% i=i+1;
% Rnames{i} = '  MVKOO + RO2C = 0.35*HOCCHO + 0.35*MECO3 + 0.15*MGLY + 0.15*HCHO +0.15*HO2  + 0.5*MEK';
% k(:,i) =  3.5e-14;
% Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'RO2C'; 
% fMVKOO(i)=fMVKOO(i)-1; fRO2C(i)=fRO2C(i)-1; 
% fHOCCHO(i)=fHOCCHO(i)+0.35; fMECO3(i)=fMECO3(i)+0.35;fMGLY(i)=fMGLY(i)+0.15;fHO2(i)=fHO2(i)+0.15;fMEK(i)=fMEK(i)+0.5;
% fHCHO(i)=fHCHO(i)+0.15;
i=i+1;
Rnames{i} = 'MVKOO + RO2C = 0.455*MECO3 + 0.455*HOCCHO + 0.145*MGLY + 0.145*HCHO + 0.145*HO2 + 0.2*C4HC + 0.2*C4DH';
k(:,i) = 2E-12;
Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'RO2C'; 
fMVKOO(i)=fMVKOO(i)-1; fRO2C(i)=fRO2C(i)-1; fMECO3(i)=fMECO3(i)+0.455;fHOCCHO(i)=fHOCCHO(i)+0.455; fMGLY(i)=fMGLY(i)+0.145; fHCHO(i)=fHCHO(i)+0.145; fHO2(i)=fHO2(i)+0.145;fC4HC(i)=fC4HC(i)+0.2;fC4DH(i)=fC4DH(i)+0.2;

% %IS61. updated with the rxns below.
% i=i+1;
% Rnames{i} = '  MVKOO + MECO3 = MEO2 + CO2 + 0.7*HOCCHO + 0.7*MECO3 + 0.3*MGLY + 0.3*HCHO + 0.3*HO2 ';
% k(:,i) =  4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'MECO3'; 
% fMVKOO(i)=fMVKOO(i)-1; fMECO3(i)=fMECO3(i)-1; 
% fHOCCHO(i)=fHOCCHO(i)+0.7; fMECO3(i)=fMECO3(i)+0.7;fMGLY(i)=fMGLY(i)+0.3;fHO2(i)=fHO2(i)+0.3;fCO2(i)=fCO2(i)+1;
% fHCHO(i)=fHCHO(i)+0.3;fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'MVKOO + MECO3 = 0.455*MECO3 + 0.455*HOCCHO + 0.145*MGLY + 0.145*HCHO + 0.145*HO2 + 0.2*C4HC + 0.2*C4DH + MEO2 + CO2';
k(:,i) = 2E-12;
Gstr{i,1} = 'MVKOO'; Gstr{i,2} = 'MECO3'; 
fMVKOO(i)=fMVKOO(i)-1; fMECO3(i)=fMECO3(i)-1; fMECO3(i)=fMECO3(i)+0.455;fHOCCHO(i)=fHOCCHO(i)+0.455; fMGLY(i)=fMGLY(i)+0.145; fHCHO(i)=fHCHO(i)+0.145; fHO2(i)=fHO2(i)+0.145;fC4HC(i)=fC4HC(i)+0.2;fC4DH(i)=fC4DH(i)+0.2;fMEO2(i)=fMEO2(i)+1;
% --------------NISOPO2-----------------
% %IS13. updated with the rxn below.
% i=i+1;
% Rnames{i} = ' NISOPO2 + MEO2 = 0.35*NIT1 + 0.0175*MVK + 0.0175*MACR + 0.15*NO2 + 0.40*HO2 + 0.035*HCHO + 0.115*HC5 + 0.25*NIT1 + 0.25*ISOPND +0.5*HCHO + 0.5*HO2 + 0.25*HCHO + 0.25*MEOH ';
% k(:,i) =   1.3e-12;
% Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'MEO2'; 
% fNISOPO2(i)=fNISOPO2(i)-1; fMEO2(i)=fMEO2(i)-1; fNIT1(i)=fNIT1(i)+0.6; fMVK(i)=fMVK(i)+0.0175;
% fMACR(i)=fMACR(i)+0.0175;fNO2(i)=fNO2(i)+0.15;fHO2(i)=fHO2(i)+0.9;fHCHO(i)=fHCHO(i)+0.785;fHC5(i)=fHC5(i)+0.115;
% fISOPND(i)=fISOPND(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;

% combined mechanism, assuming 100% of the beta-1-2-INO forms NIEPOXOO.
i=i+1;
Rnames{i} = ' NISOPO2 + MEO2 = 0.453*NO2 + 0.000*MVK + 0.093*MACR + 0.093*HCHO + 0.346*NIT1 + 0.147*HO2 + 0.360*HC5 + 0.200*ISOPHND + 0.001*NIEPOXOO + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH ';
k(:,i) =   1.3e-12;
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'MEO2'; 
fNISOPO2(i)=fNISOPO2(i)-1; fMEO2(i)=fMEO2(i)-1; fNO2(i)=fNO2(i)+0.453;fMVK(i)=fMVK(i)+0.000;fMACR(i)=fMACR(i)+0.093;fHCHO(i)=fHCHO(i)+0.843;
fNIT1(i)=fNIT1(i)+0.346; fHO2(i)=fHO2(i)+0.647; fHC5(i)=fHC5(i)+0.360; fISOPHND(i)=fISOPHND(i)+0.200; fNIEPOXOO(i)=fNIEPOXOO(i)+0.001;fMEOH(i)=fMEOH(i)+0.25;

% %IS140. updated with the rxn below.
% i=i+1;
% Rnames{i} = ' NISOPO2 + NISOPO2 = 0.70*NIT1 + 0.035*MVK + 0.035*MACR + 0.3*NO2 + 0.80*HO2 + 0.070*HCHO + 0.23*HC5 + 0.5*NIT1 + 0.5*ISOPND';
% k(:,i) = 1.2e-12;
% Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'NISOPO2'; 
% fNISOPO2(i)=fNISOPO2(i)-1; fNISOPO2(i)=fNISOPO2(i)-1; fNIT1(i)=fNIT1(i)+1.2; fMVK(i)=fMVK(i)+0.035;
% fMACR(i)=fMACR(i)+0.035;fNO2(i)=fNO2(i)+0.3;fHO2(i)=fHO2(i)+0.8;fHCHO(i)=fHCHO(i)+0.07;fHC5(i)=fHC5(i)+0.23;
% fISOPND(i)=fISOPND(i)+0.5;

% combined mechanism, assuming 100% of the beta-1-2-INO forms NIEPOXOO.
i=i+1;
Rnames{i} = 'NISOPO2 + NISOPO2 = 0.905*NO2 + 0.000*MVK + 0.185*MACR + 0.185*HCHO + 0.693*NIT1 + 0.293*HO2 + 0.720*HC5 + 0.400*ISOPHND + 0.002*NIEPOXOO';
k(:,i) = 5e-12.*0.9;
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'NISOPO2'; 
fNISOPO2(i)=fNISOPO2(i)-2; fNO2(i)=fNO2(i)+0.905;fMVK(i)=fMVK(i)+0.000;fMACR(i)=fMACR(i)+0.185;fHCHO(i)=fHCHO(i)+0.185;
fNIT1(i)=fNIT1(i)+0.693;fHO2(i)=fHO2(i)+0.293;fHC5(i)=fHC5(i)+0.720;fISOPHND(i)=fISOPHND(i)+0.400;fNIEPOXOO(i)=fNIEPOXOO(i)+0.002;

i=i+1;
Rnames{i} = 'NISOPO2 + NISOPO2 = C10dimer';
k(:,i) = 5e-12.*0.1;
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'NISOPO2'; 
fNISOPO2(i)=fNISOPO2(i)-2; fC10dimer(i)=fC10dimer(i)+1;

% %IS14. updated with the rxn below.
% i=i+1;
% Rnames{i} = ' NISOPO2 + RO2C = 0.35*NIT1 + 0.0175*MVK + 0.0175*MACR + 0.15*NO2 +0.40*HO2 + 0.035*HCHO + 0.115*HC5 + 0.25*NIT1 + 0.25*ISOPND';
% k(:,i) =  6.04e-12;
% Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'RO2C'; 
% fNISOPO2(i)=fNISOPO2(i)-1; fRO2C(i)=fRO2C(i)-1; fNIT1(i)=fNIT1(i)+0.6; fMVK(i)=fMVK(i)+0.0175;
% fMACR(i)=fMACR(i)+0.0175;fNO2(i)=fNO2(i)+0.15;fHO2(i)=fHO2(i)+0.4;fHCHO(i)=fHCHO(i)+0.035;fHC5(i)=fHC5(i)+0.115;
% fISOPND(i)=fISOPND(i)+0.25;

% combined mechanism, assuming 100% of the beta-1-2-INO forms NIEPOXOO.
i=i+1;
Rnames{i} = ' NISOPO2 + RO2C = 0.453*NO2 + 0.000*MVK + 0.093*MACR + 0.093*HCHO + 0.346*NIT1 + 0.147*HO2 + 0.360*HC5 + 0.200*ISOPHND + 0.001*NIEPOXOO';
k(:,i) =  7e-14; %6.04e-12; rate constant updated on 20230327 by HZ.
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'RO2C'; 
fNISOPO2(i)=fNISOPO2(i)-1; fRO2C(i)=fRO2C(i)-1; fNO2(i)=fNO2(i)+0.453;fMVK(i)=fMVK(i)+0.000;fMACR(i)=fMACR(i)+0.093;fHCHO(i)=fHCHO(i)+0.093;
fNIT1(i)=fNIT1(i)+0.346;fHO2(i)=fHO2(i)+0.147;fHC5(i)=fHC5(i)+0.360;fISOPHND(i)=fISOPHND(i)+0.200;fNIEPOXOO(i)=fNIEPOXOO(i)+0.001;

% %IS15. updated with the rxn below.
% i=i+1;
% Rnames{i} = ' NISOPO2 + MECO3 = MEO2 + CO2 + 0.70*NIT1 + 0.035*MVK + 0.035*MACR + 0.3*NO2 + 0.80*HO2 + 0.070*HCHO + 0.23*HC5';
% k(:,i) =  4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'MECO3'; 
% fNISOPO2(i)=fNISOPO2(i)-1; fMECO3(i)=fMECO3(i)-1; fNIT1(i)=fNIT1(i)+0.7; fMVK(i)=fMVK(i)+0.035;
% fMACR(i)=fMACR(i)+0.035;fNO2(i)=fNO2(i)+0.3;fHO2(i)=fHO2(i)+0.8;fHCHO(i)=fHCHO(i)+0.07;fHC5(i)=fHC5(i)+0.23;
% fMEO2(i)=fMEO2(i)+1;fCO2(i)=fCO2(i)+1;

% combined mechanism, assuming 100% of the beta-1-2-INO forms NIEPOXOO.
i=i+1;
Rnames{i} = ' NISOPO2 + MECO3 = MEO2 + CO2 + 0.453*NO2 + 0.000*MVK + 0.093*MACR + 0.093*HCHO + 0.346*NIT1 + 0.147*HO2 + 0.360*HC5 + 0.200*ISOPHND + 0.001*NIEPOXOO ';
k(:,i) =  4.4e-13.*exp(1070./ T);
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'MECO3'; 
fNISOPO2(i)=fNISOPO2(i)-1; fMECO3(i)=fMECO3(i)-1; fNO2(i)=fNO2(i)+0.453;fMVK(i)=fMVK(i)+0.000;fMACR(i)=fMACR(i)+0.093;fHCHO(i)=fHCHO(i)+0.093;
fNIT1(i)=fNIT1(i)+0.346;fHO2(i)=fHO2(i)+0.147;fHC5(i)=fHC5(i)+0.360;fISOPHND(i)=fISOPHND(i)+0.200;fNIEPOXOO(i)=fNIEPOXOO(i)+0.001;
fMEO2(i)=fMEO2(i)+1;fCO2(i)=fCO2(i)+1;


% --------------HC5OO-----------------
% %IS20. Removed. HC500 lumped with IEPOXOO.
% i=i+1;
% Rnames{i} = 'HC5OO + MEO2 = 0.117*HOCCHO + 0.117*MGLY + 0.108*GLY + 0.108*HACET + 0.145*DHMOB + 0.085*RCOOH + 0.045*PRD2 + 0.045*CO + 0.5*HO2 + 0.5*PRD2 + 0.25*HCHO + 0.25*MEOH + 0.5*HO2 + 0.5*HCHO - 0.42*XC ';
% k(:,i) =  2e-13;
% Gstr{i,1} = 'HC5OO'; Gstr{i,2} = 'MEO2'; 
% fHC5OO(i)=fHC5OO(i)-1; fMEO2(i)=fMEO2(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.117; fMGLY(i)=fMGLY(i)+0.117; 
% fGLY(i)=fGLY(i)+0.108; fHACET(i)=fHACET(i)+0.108; fDHMOB(i)=fDHMOB(i)+0.145; fRCOOH(i)=fRCOOH(i)+0.085; 
% fPRD2(i)=fPRD2(i)+0.045; fCO(i)=fCO(i)+0.045; fHO2(i)=fHO2(i)+1;fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)-0.42;
% fHCHO(i)=fHCHO(i)+0.75;fMEOH(i)=fMEOH(i)+0.25;

% %IS21. Removed. HC500 lumped with IEPOXOO.
% i=i+1;
% Rnames{i} = 'HC5OO + RO2C = 0.117*HOCCHO + 0.117*MGLY + 0.108*GLY + 0.108*HACET + 0.145*DHMOB + 0.085*RCOOH + 0.045*PRD2 + 0.045*CO + 0.5*HO2 +  0.5*PRD2 - 0.42*XC  ';
% k(:,i) =  3.5e-14;
% Gstr{i,1} = 'HC5OO'; Gstr{i,2} = 'RO2C'; 
% fHC5OO(i)=fHC5OO(i)-1; fRO2C(i)=fRO2C(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.117; fMGLY(i)=fMGLY(i)+0.117; 
% fGLY(i)=fGLY(i)+0.108; fHACET(i)=fHACET(i)+0.108; fDHMOB(i)=fDHMOB(i)+0.145; fRCOOH(i)=fRCOOH(i)+0.085; 
% fPRD2(i)=fPRD2(i)+0.045; fCO(i)=fCO(i)+0.045; fHO2(i)=fHO2(i)+0.5;fPRD2(i)=fPRD2(i)+0.5; fXC(i)=fXC(i)-0.42;

% %IS22. Removed. HC500 lumped with IEPOXOO.
% i=i+1;
% Rnames{i} = 'HC5OO + MECO3 = MEO2 + CO2 + 0.234*HOCCHO + 0.234*MGLY + 0.216*GLY + 0.216*HACET + 0.29*DHMOB + 0.17*RCOOH + 0.09*PRD2 + 0.09*CO + HO2 + 0.16*XC  ';
% k(:,i) =   4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'HC5OO'; Gstr{i,2} = 'MECO3'; 
% fHC5OO(i)=fHC5OO(i)-1; fMECO3(i)=fMECO3(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.234; fMGLY(i)=fMGLY(i)+0.234; fCO2(i)=fCO2(i)+1;
% fGLY(i)=fGLY(i)+0.216; fHACET(i)=fHACET(i)+0.216; fDHMOB(i)=fDHMOB(i)+0.29; fRCOOH(i)=fRCOOH(i)+0.17; 
% fPRD2(i)=fPRD2(i)+0.09; fCO(i)=fCO(i)+0.09; fHO2(i)=fHO2(i)+1;fMEO2(i)=fMEO2(i)+1; fXC(i)=fXC(i)+0.16;

% %IS142.Removed.
% i=i+1;
% Rnames{i} = 'ISOPNOOD + MEO2 = 0.17*PRD2 + 0.075*PROPNN + 0.22*HACET + 0.035*MVKN + 0.065*ETHLN + 0.155*FACD + 0.155*NO3 + 0.36*HCHO + 0.075*HOCCHO +  0.17*NO2 + 0.175*HO2 + 0.5*RNO3I + 0.25*HCHO + 0.25*MEOH + 0.5*HO2  + 0.5*HCHO - 0.84*XC ';
% k(:,i) =   2e-13;
% Gstr{i,1} = 'ISOPNOOD'; Gstr{i,2} = 'MEO2'; 
% fISOPNOOD(i)=fISOPNOOD(i)-1; fMEO2(i)=fMEO2(i)-1; fPRD2(i)=fPRD2(i)+0.17;fPROPNN(i)=fPROPNN(i)+0.075;
% fHACET(i)=fHACET(i)+0.22;fMVKN(i)=fMVKN(i)+0.035;fETHLN(i)=fETHLN(i)+0.065;fFACD(i)=fFACD(i)+0.155;fNO3(i)=fNO3(i)+0.155;
% fHCHO(i)=fHCHO(i)+0.36;fHOCCHO(i)=fHOCCHO(i)+0.075;fNO2(i)=fNO2(i)+0.17;fHO2(i)=fHO2(i)+0.675;fRNO3I(i)=fRNO3I(i)+0.5;
% fXC(i)=fXC(i)-0.84;fMEOH(i)=fMEOH(i)+0.25;fHCHO(i)=fHCHO(i)+0.75;
% 
% %IS143. Removed.
% i=i+1;
% Rnames{i} = 'ISOPNOOD + RO2C = 0.17*PRD2 + 0.075*PROPNN + 0.22*HACET + 0.035*MVKN + 0.065*ETHLN + 0.155*FACD + 0.155*NO3 + 0.36*HCHO + 0.075*HOCCHO + 0.17*NO2 + 0.175*HO2 + 0.5*RNO3I - 0.84*XC';
% k(:,i) =   3.5e-14;
% Gstr{i,1} = 'ISOPNOOD'; Gstr{i,2} = 'RO2C'; 
% fISOPNOOD(i)=fISOPNOOD(i)-1; fRO2C(i)=fRO2C(i)-1; fPRD2(i)=fPRD2(i)+0.17;fPROPNN(i)=fPROPNN(i)+0.075;
% fHACET(i)=fHACET(i)+0.22;fMVKN(i)=fMVKN(i)+0.035;fETHLN(i)=fETHLN(i)+0.065;fFACD(i)=fFACD(i)+0.155;fNO3(i)=fNO3(i)+0.155;
% fHCHO(i)=fHCHO(i)+0.36;fHOCCHO(i)=fHOCCHO(i)+0.075;fNO2(i)=fNO2(i)+0.17;fHO2(i)=fHO2(i)+0.175;fRNO3I(i)=fRNO3I(i)+0.5;
% fXC(i)=fXC(i)-0.84;
% 
% %IS144. Removed.
% i=i+1;
% Rnames{i} = 'ISOPNOOD + MECO3 = MEO2 + CO2 + 0.34*PRD2 + 0.15*PROPNN + 0.44*HACET + 0.07*MVKN + 0.13*ETHLN + 0.31*FACD + 0.31*NO3 + 0.72*HCHO +  0.15*HOCCHO + 0.34*NO2 + 0.35*HO2 - 0.68*XC';
% k(:,i) =   3.5e-14;
% Gstr{i,1} = 'ISOPNOOD'; Gstr{i,2} = 'MECO3'; 
% fISOPNOOD(i)=fISOPNOOD(i)-1; fMECO3(i)=fMECO3(i)-1;fMEO2(i)=fMEO2(i)+1; fPRD2(i)=fPRD2(i)+0.34;fPROPNN(i)=fPROPNN(i)+0.15;
% fHACET(i)=fHACET(i)+0.44;fMVKN(i)=fMVKN(i)+0.07;fETHLN(i)=fETHLN(i)+0.13;fFACD(i)=fFACD(i)+0.31;fNO3(i)=fNO3(i)+0.31;
% fHCHO(i)=fHCHO(i)+0.72;fHOCCHO(i)=fHOCCHO(i)+0.15;fNO2(i)=fNO2(i)+0.34;fHO2(i)=fHO2(i)+0.35;
% fXC(i)=fXC(i)-0.68;fCO2(i)=fCO2(i)+1;

% --------------ISOPNOO-----------------
% %IS146. updated with the rxns below on 20220914 by HZ.
% i=i+1;
% Rnames{i} = 'ISOPNOOB + MEO2 = 0.3*HOCCHO + 0.3*HACET + 0.2*HCHO + 0.2*HO2 + 0.13*MACRN + 0.07*MVKN + 0.3*NO2 + 0.5*RNO3I + 0.25*HCHO + 0.25*MEOH + 0.5*HO2 + 0.5*HCHO - 0.5*XC ';
% k(:,i) =  2e-13;
% Gstr{i,1} = 'ISOPNOOB'; Gstr{i,2} = 'MEO2'; 
% fISOPNOOB(i)=fISOPNOOB(i)-1; fMEO2(i)=fMEO2(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.3;fHACET(i)=fHACET(i)+0.3;fHCHO(i)=fHCHO(i)+0.2;
% fHO2(i)=fHO2(i)+0.2;fMACRN(i)=fMACRN(i)+0.13;fMVKN(i)=fMVKN(i)+0.07;fNO2(i)=fNO2(i)+0.3;fRNO3I(i)=fRNO3I(i)+0.5;fHCHO(i)=fHCHO(i)+0.25;
% fMEOH(i)=fMEOH(i)+0.25;fHO2(i)=fHO2(i)+0.5;fHCHO(i)=fHCHO(i)+0.5;fXC(i)=fXC(i)-0.5;

i=i+1;
Rnames{i} = 'ISOPNOO + MEO2 = 0.315*NO2 + 0.385*HO2 + 0.354*HCHO + 0.328*HOCCHO + 0.333*HACET + 0.013*PROPNN + 0.018*ETHLN + 0.118*MACRN + 0.236*MVKN + 0.1*IDHCN + 0.2*ITHN + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
k(:,i) = 2E-13;
Gstr{i,1} = 'ISOPNOO'; Gstr{i,2} = 'MEO2'; 
fISOPNOO(i)=fISOPNOO(i)-1; fMEO2(i)=fMEO2(i)-1; fMEOH(i)=fMEOH(i)+0.25; 
fNO2(i)=fNO2(i)+0.315; fHO2(i)=fHO2(i)+0.885; fHCHO(i)=fHCHO(i)+1.104; fHOCCHO(i)=fHOCCHO(i)+0.328; fHACET(i)=fHACET(i)+0.333; fPROPNN(i)=fPROPNN(i)+0.013; fETHLN(i)=fETHLN(i)+0.018; ffMACRN(i)=fMACRN(i)+0.118; fMVKN(i)=fMVKN(i)+0.236; fIDHCN(i)=fIDHCN(i)+0.1; fITHN(i)=fITHN(i)+0.2;

% %IS147. updated with the rxns below.
% i=i+1;
% Rnames{i} =' ISOPNOOB + RO2C = 0.3*HOCCHO + 0.3*HACET + 0.2*HCHO + 0.2*HO2 + 0.13*MACRN + 0.07*MVKN + 0.3*NO2 + 0.5*RNO3I - 0.5*XC ';
% k(:,i) =  3.5e-14;
% Gstr{i,1} = 'ISOPNOOB'; Gstr{i,2} = 'RO2C'; 
% fISOPNOOB(i)=fISOPNOOB(i)-1; fRO2C(i)=fRO2C(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.3;fHACET(i)=fHACET(i)+0.3;fHCHO(i)=fHCHO(i)+0.2;
% fHO2(i)=fHO2(i)+0.2;fMACRN(i)=fMACRN(i)+0.13;fMVKN(i)=fMVKN(i)+0.07;fNO2(i)=fNO2(i)+0.3;fRNO3I(i)=fRNO3I(i)+0.5;
% fXC(i)=fXC(i)-0.5;
i=i+1;
Rnames{i} = 'ISOPNOO + RO2C = 0.315*NO2 + 0.385*HO2 + 0.354*HCHO + 0.328*HOCCHO + 0.333*HACET + 0.013*PROPNN + 0.018*ETHLN + 0.118*MACRN + 0.236*MVKN + 0.1*IDHCN + 0.2*ITHN';
k(:,i) = 3.5e-14;
Gstr{i,1} = 'ISOPNOO'; Gstr{i,2} = 'RO2C'; 
fISOPNOO(i)=fISOPNOO(i)-1; fRO2C(i)=fRO2C(i)-1; 
fNO2(i)=fNO2(i)+0.315; fHO2(i)=fHO2(i)+0.385; fHCHO(i)=fHCHO(i)+0.354; fHOCCHO(i)=fHOCCHO(i)+0.328; fHACET(i)=fHACET(i)+0.333; fPROPNN(i)=fPROPNN(i)+0.013; fETHLN(i)=fETHLN(i)+0.018; ffMACRN(i)=fMACRN(i)+0.118; fMVKN(i)=fMVKN(i)+0.236; fIDHCN(i)=fIDHCN(i)+0.1; fITHN(i)=fITHN(i)+0.2;

% %IS148. updated with the rxn below.
% i=i+1;
% Rnames{i} =' ISOPNOOB + MECO3 = MEO2 + CO2 + 0.6*HOCCHO + 0.6*HACET + 0.4*HCHO + 0.4*HO2 + 0.26*MACRN + 0.14*MVKN + 0.6*NO2  ';
% k(:,i) =  4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'ISOPNOOB'; Gstr{i,2} = 'MECO3'; 
% fISOPNOOB(i)=fISOPNOOB(i)-1; fMECO3(i)=fMECO3(i)-1; fHOCCHO(i)=fHOCCHO(i)+0.6;fHACET(i)=fHACET(i)+0.6;fHCHO(i)=fHCHO(i)+0.4;
% fHO2(i)=fHO2(i)+0.4;fMACRN(i)=fMACRN(i)+0.26;fMVKN(i)=fMVKN(i)+0.14;fNO2(i)=fNO2(i)+0.6;fMEO2(i)=fMEO2(i)+1;
% fCO2(i)=fCO2(i)+1;
i=i+1;
Rnames{i} = 'ISOPNOO + MECO3 = 0.315*NO2 + 0.385*HO2 + 0.354*HCHO + 0.328*HOCCHO + 0.333*HACET + 0.013*PROPNN + 0.018*ETHLN + 0.118*MACRN + 0.236*MVKN + 0.1*IDHCN + 0.2*ITHN + MEO2 + CO2';
k(:,i) = 4.4e-13.*exp(1070./ T);
Gstr{i,1} = 'ISOPNOO'; Gstr{i,2} = 'MECO3'; 
fISOPNOO(i)=fISOPNOO(i)-1; fMECO3(i)=fMECO3(i)-1; 
fNO2(i)=fNO2(i)+0.315; fHO2(i)=fHO2(i)+0.385; fHCHO(i)=fHCHO(i)+0.354; fHOCCHO(i)=fHOCCHO(i)+0.328; fHACET(i)=fHACET(i)+0.333; fPROPNN(i)=fPROPNN(i)+0.013; fETHLN(i)=fETHLN(i)+0.018; 
ffMACRN(i)=fMACRN(i)+0.118; fMVKN(i)=fMVKN(i)+0.236; fIDHCN(i)=fIDHCN(i)+0.1; fITHN(i)=fITHN(i)+0.2; fMEO2(i)=fMEO2(i)+1;

i=i+1;
Rnames{i} = 'ISOPNOO + ISOPNOO = 0.63*NO2 + 0.77*HO2 + 0.708*HCHO + 0.656*HOCCHO + 0.666*HACET + 0.026*PROPNN + 0.036*ETHLN + 0.236*MACRN + 0.472*MVKN + 0.2*IDHCN + 0.4*ITHN';
k(:,i) = KRO2RO2_HO.*0.95;
Gstr{i,1} = 'ISOPNOO'; Gstr{i,2} = 'ISOPNOO'; 
fISOPNOO(i)=fISOPNOO(i)-2; fNO2(i)=fNO2(i)+0.63; fHO2(i)=fHO2(i)+0.77; fHCHO(i)=fHCHO(i)+0.708; fHOCCHO(i)=fHOCCHO(i)+0.656; fHACET(i)=fHACET(i)+0.666; 
fPROPNN(i)=fPROPNN(i)+0.026; fETHLN(i)=fETHLN(i)+0.036; ffMACRN(i)=fMACRN(i)+0.236; fMVKN(i)=fMVKN(i)+0.472; fIDHCN(i)=fIDHCN(i)+0.2; fITHN(i)=fITHN(i)+0.4;

% i=i+1;
% Rnames{i} = 'ISOPNOO + ISOPNOO = C10dimer';
% k(:,i) = KRO2RO2_HO.*0.05;
% Gstr{i,1} = 'ISOPNOO'; Gstr{i,2} = 'ISOPNOO'; 
% fISOPNOO(i)=fISOPNOO(i)-2; fC10dimer(i)=fC10dimer(i)+1;


% --------------NIT1NO3OOA-----------------
%IS38. Unchanged.
i=i+1;
Rnames{i} = 'NIT1NO3OOA + RO2C = 0.7*PROPNN + 0.7*CO + 0.7*CO2 + 0.7*HO2 + 0.3*INCA';
k(:,i) =  4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'NIT1NO3OOA'; Gstr{i,2} = 'RO2C'; 
fNIT1NO3OOA(i)=fNIT1NO3OOA(i)-1; fRO2C(i)=fRO2C(i)-1; fPROPNN(i)=fPROPNN(i)+0.7; fCO(i)=fCO(i)+0.7; fHO2(i)=fHO2(i)+0.7; fINCA(i)=fINCA(i)+0.3;

%IS40. Unchanged.
i=i+1;
Rnames{i} = 'NIT1NO3OOA + MEO2 =  0.7*PROPNN + 0.7*CO + 0.7*CO2 + 0.7*HO2 + 0.3*INCA + 0.75*HCHO + 0.25*MEOH + 0.5*HO2 ';
k(:,i) =  2.00e-12.*exp(500./ T);
Gstr{i,1} = 'NIT1NO3OOA'; Gstr{i,2} = 'MEO2'; 
fNIT1NO3OOA(i)=fNIT1NO3OOA(i)-1; fMEO2(i)=fMEO2(i)-1; fPROPNN(i)=fPROPNN(i)+0.7; fCO(i)=fCO(i)+0.7; fHO2(i)=fHO2(i)+1.2; fINCA(i)=fINCA(i)+0.3;
fHCHO(i)=fHCHO(i)+0.75; fMEOH(i)=fMEOH(i)+0.25;

%IS41. Unchanged.
i=i+1;
Rnames{i} = 'NIT1NO3OOA + MECO3 = MEO2 + CO2 + 0.7*PROPNN + 0.7*CO + 0.7*CO2 + 0.7*HO2 + 0.3*INCA';
k(:,i) =  2.90e-12.*exp(500./ T);
Gstr{i,1} = 'NIT1NO3OOA'; Gstr{i,2} = 'MECO3'; 
fNIT1NO3OOA(i)=fNIT1NO3OOA(i)-1; fMECO3(i)=fMECO3(i)-1;fPROPNN(i)=fPROPNN(i)+0.7; fCO(i)=fCO(i)+0.7; fHO2(i)=fHO2(i)+0.7; fINCA(i)=fINCA(i)+0.3; fMEO2(i)=fMEO2(i)+1;

% %IS39. Removed.
% i=i+1;
% Rnames{i} =' NIT1NO3OOB + RO2C = 0.7*ISOPNN + 0.7*GLY + 0.3*RNO3I - 0.3*XC + 0.3*XN  ';
% k(:,i) = 3.5e-14;
% Gstr{i,1} = 'NIT1NO3OOB'; Gstr{i,2} = 'RO2C'; 
% fNIT1NO3OOB(i)=fNIT1NO3OOB(i)-1; fRO2C(i)=fRO2C(i)-1;fISOPNN(i)=fISOPNN(i)+0.7;fGLY(i)=fGLY(i)+0.7;
% fRNO3I(i)=fRNO3I(i)+0.3;fXC(i)=fXC(i)-0.3;fXN(i)=fXN(i)+0.3;
% 
% %IS43. Removed.
% i=i+1;
% Rnames{i} =' NIT1NO3OOB + MEO2 = 0.7*ISOPNN + 0.7*GLY + 0.3*RNO3I + 0.25*HCHO + 0.25*MEOH +  0.5*HO2 + 0.5*HCHO - 0.3*XC +  0.3*XN  ';
% k(:,i) = 2e-13;
% Gstr{i,1} = 'NIT1NO3OOB'; Gstr{i,2} = 'MEO2'; 
% fNIT1NO3OOB(i)=fNIT1NO3OOB(i)-1; fMEO2(i)=fMEO2(i)-1;fISOPNN(i)=fISOPNN(i)+0.7;fGLY(i)=fGLY(i)+0.7;
% fRNO3I(i)=fRNO3I(i)+0.3;fXC(i)=fXC(i)-0.3;fXN(i)=fXN(i)+0.3;fHCHO(i)=fHCHO(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;
% fHO2(i)=fHO2(i)+0.5;fHCHO(i)=fHCHO(i)+0.5;
% 
% %IS44. Removed.
% i=i+1;
% Rnames{i} =' NIT1NO3OOB + MECO3 = MEO2 + CO2 + ISOPNN + GLY ';
% k(:,i) = 4.40e-13.*exp(1070./ T);
% Gstr{i,1} = 'NIT1NO3OOB'; Gstr{i,2} = 'MECO3'; 
% fNIT1NO3OOB(i)=fNIT1NO3OOB(i)-1; fMECO3(i)=fMECO3(i)-1;fISOPNN(i)=fISOPNN(i)+1;fGLY(i)=fGLY(i)+1;
% fMEO2(i)=fMEO2(i)+1;fCO2(i)=fCO2(i)+1;

% --------------NIT1OHOO-----------------
% %IS51. updated with the rxns below.
% i=i+1;
% Rnames{i} =' NIT1OHOO + RO2C = 0.689*PROPNN + 0.689*GLY + 0.011*CO + 0.011*RNO3I + 0.7*HO2 + 0.3*RNO3I - 0.323*XC';
% k(:,i) = 3.5e-14;
% Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'RO2C'; 
% fNIT1OHOO(i)=fNIT1OHOO(i)-1; fRO2C(i)=fRO2C(i)-1;fPROPNN(i)=fPROPNN(i)+0.689;fGLY(i)=fGLY(i)+0.689;
% fCO(i)=fCO(i)+0.011;fRNO3I(i)=fRNO3I(i)+0.011;fHO2(i)=fHO2(i)+0.7;fRNO3I(i)=fRNO3I(i)+0.3;
% fXC(i)=fXC(i)-0.323;

i=i+1;
Rnames{i} =' NIT1OHOO + RO2C = 0.6*NO2 + 0.6*HO2 + 0.45*MACRN + 0.45*CO + 0.15*PROPNN + 0.15*GLY + 0.2*IHNDC + 0.2*ICHNP';
k(:,i) = 3.5e-14;
Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'RO2C'; 
fNIT1OHOO(i)=fNIT1OHOO(i)-1; fRO2C(i)=fRO2C(i)-1;fNO2(i)=fNO2(i)+0.6;fHO2(i)=fHO2(i)+0.6;
fMACRN(i)=fMACRN(i)+0.45;fCO(i)=fCO(i)+0.45;fPROPNN(i)=fPROPNN(i)+0.15;fGLY(i)=fGLY(i)+0.15;fIHNDC(i)=fIHNDC(i)+0.2;fICHNP(i)=fICHNP(i)+0.2;

% %IS52. updated with the rxns below.
% i=i+1;
% Rnames{i} =' NIT1OHOO + MEO2 = 0.689*PROPNN + 0.689*GLY + 0.011*CO + 0.011*RNO3I + 0.7*HO2 + 0.3*RNO3I + 0.25*HCHO + 0.25*MEOH + 0.50*HCHO + 0.50*HO2 - 0.323*XC';
% k(:,i) = 2e-13;
% Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'MEO2'; 
% fNIT1OHOO(i)=fNIT1OHOO(i)-1; fMEO2(i)=fMEO2(i)-1;fPROPNN(i)=fPROPNN(i)+0.689;fGLY(i)=fGLY(i)+0.689;
% fCO(i)=fCO(i)+0.011;fRNO3I(i)=fRNO3I(i)+0.011;fHO2(i)=fHO2(i)+0.7;fRNO3I(i)=fRNO3I(i)+0.3;
% fXC(i)=fXC(i)-0.323;fHCHO(i)=fHCHO(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;fHCHO(i)=fHCHO(i)+0.5;fHO2(i)=fHO2(i)+0.5;

i=i+1;
Rnames{i} =' NIT1OHOO + MEO2 = 0.6*NO2 + 0.6*HO2 + 0.45*MACRN + 0.45*CO + 0.15*PROPNN + 0.15*GLY + 0.2*IHNDC + 0.2*ICHNP + 0.25*HCHO + 0.25*MEOH + 0.50*HCHO + 0.50*HO2';
k(:,i) = 2e-13;
Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'MEO2'; 
fNIT1OHOO(i)=fNIT1OHOO(i)-1; fMEO2(i)=fMEO2(i)-1;fNO2(i)=fNO2(i)+0.6;fHO2(i)=fHO2(i)+0.6;
fMACRN(i)=fMACRN(i)+0.45;fCO(i)=fCO(i)+0.45;fPROPNN(i)=fPROPNN(i)+0.15;fGLY(i)=fGLY(i)+0.15;fIHNDC(i)=fIHNDC(i)+0.2;fICHNP(i)=fICHNP(i)+0.2;
fHCHO(i)=fHCHO(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;fHCHO(i)=fHCHO(i)+0.5;fHO2(i)=fHO2(i)+0.5;

% %IS53. updated with the rxns below.
% i=i+1;
% Rnames{i} =' NIT1OHOO + MECO3 = MEO2 + CO2 + 0.984*PROPNN + 0.984*GLY + 0.016*CO + 0.016*RNO3I + HO2 - 0.033*XC ';
% k(:,i) = 4.40e-13.*exp(1070./ T);
% Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'MECO3'; 
% fNIT1OHOO(i)=fNIT1OHOO(i)-1; fMECO3(i)=fMECO3(i)-1;fPROPNN(i)=fPROPNN(i)+0.984;fGLY(i)=fGLY(i)+0.984;
% fCO(i)=fCO(i)+0.016;fRNO3I(i)=fRNO3I(i)+0.016;fHO2(i)=fHO2(i)+1;fMEO2(i)=fMEO2(i)+1;fCO2(i)=fCO2(i)+1;
% fXC(i)=fXC(i)-0.033;

i=i+1;
Rnames{i} =' NIT1OHOO + MECO3 = MEO2 + CO2 + 0.6*NO2 + 0.6*HO2 + 0.45*MACRN + 0.45*CO + 0.15*PROPNN + 0.15*GLY + 0.2*IHNDC + 0.2*ICHNP';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'NIT1OHOO'; Gstr{i,2} = 'MECO3'; 
fNIT1OHOO(i)=fNIT1OHOO(i)-1; fMECO3(i)=fMECO3(i)-1;fNO2(i)=fNO2(i)+0.6;fHO2(i)=fHO2(i)+0.6;
fMACRN(i)=fMACRN(i)+0.45;fCO(i)=fCO(i)+0.45;fPROPNN(i)=fPROPNN(i)+0.15;fGLY(i)=fGLY(i)+0.15;fIHNDC(i)=fIHNDC(i)+0.2;fICHNP(i)=fICHNP(i)+0.2;fMEO2(i)=fMEO2(i)+1;

% %IS103. Removed.
% i=i+1;
% Rnames{i} =' DIBOO + MEO2 = 0.5*HO2 + 0.26*HOCCHO + 0.26*MGLY + 0.24*GLY + 0.24*HACET + 0.5*PRD2 + 0.25*HCHO + 0.25*MEOH + 0.5*HCHO +  0.50*HO2 - 0.5*XC ';
% k(:,i) = 2e-13;
% Gstr{i,1} = 'DIBOO'; Gstr{i,2} = 'MEO2'; 
% fDIBOO(i)=fDIBOO(i)-1; fMEO2(i)=fMEO2(i)-1;fHO2(i)=fHO2(i)+1;
% fHOCCHO(i)=fHOCCHO(i)+0.26;fMGLY(i)=fMGLY(i)+0.26;fGLY(i)=fGLY(i)+0.24;fHACET(i)=fHACET(i)+0.24;
% fPRD2(i)=fPRD2(i)+0.5;fHCHO(i)=fHCHO(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;fHCHO(i)=fHCHO(i)+0.5;fXC(i)=fXC(i)-0.5;

% %IS104. Removed.
% i=i+1;
% Rnames{i} =' DIBOO + RO2C = 0.5*HO2 + 0.26*HOCCHO + 0.26*MGLY + 0.24*GLY + 0.24*HACET + 0.5*PRD2 - 0.5*XC';
% k(:,i) = 3.5e-14;
% Gstr{i,1} = 'DIBOO'; Gstr{i,2} = 'RO2C'; 
% fDIBOO(i)=fDIBOO(i)-1; fRO2C(i)=fRO2C(i)-1;fHO2(i)=fHO2(i)+0.5;
% fHOCCHO(i)=fHOCCHO(i)+0.26;fMGLY(i)=fMGLY(i)+0.26;fGLY(i)=fGLY(i)+0.24;fHACET(i)=fHACET(i)+0.24;
% fPRD2(i)=fPRD2(i)+0.5;fXC(i)=fXC(i)-0.5;

% %IS105. Removed.
% i=i+1;
% Rnames{i} =' DIBOO + MECO3 = HO2 + 0.52*HOCCHO + 0.52*MGLY + 0.48*GLY + 0.48*HACET + MEO2 + CO2';
% k(:,i) = 4.40e-13.*exp(1070./ T);
% Gstr{i,1} = 'DIBOO'; Gstr{i,2} = 'MECO3'; 
% fDIBOO(i)=fDIBOO(i)-1; fMECO3(i)=fMECO3(i)-1;fHO2(i)=fHO2(i)+1;
% fHOCCHO(i)=fHOCCHO(i)+0.52;fMGLY(i)=fMGLY(i)+0.52;fGLY(i)=fGLY(i)+0.48;fHACET(i)=fHACET(i)+0.48;
% fMEO2(i)=fMEO2(i)+1;fCO2(i)=fCO2(i)+1;

% --------------IEPOXOO-----------------
% %IS112. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IEPOXOO + MEO2 = 0.363*HACET + 0.138*HOCCHO + 0.138*GLY + 0.138*MGLY + 0.063*OH + 0.413*HO2 + 0.100*CO2 + 0.188*HCHO + 0.037*FACD + 0.126*CO + 0.5*PRD2 + 0.5*HCHO + 0.5*HO2 + 0.25*HCHO + 0.25*MEOH - 0.5*XC';
% k(:,i) = 2e-13;
% Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'MEO2'; 
% fIEPOXOO(i)=fIEPOXOO(i)-1;fMEO2(i)=fMEO2(i)-1;fHACET(i)=fHACET(i)+0.363;fHOCCHO(i)=fHOCCHO(i)+0.138;fGLY(i)=fGLY(i)+0.138;
% fMGLY(i)=fMGLY(i)+0.138;fOH(i)=fOH(i)+0.063;fHO2(i)=fHO2(i)+0.413;fCO2(i)=fCO2(i)+0.1;fHCHO(i)=fHCHO(i)+0.188;
% fFACD(i)=fFACD(i)+0.037;fCO(i)=fCO(i)+0.126;fPRD2(i)=fPRD2(i)+0.5;fHCHO(i)=fHCHO(i)+0.5;fHO2(i)=fHO2(i)+0.5;
% fHCHO(i)=fHCHO(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;fXC(i)=fXC(i)-0.5;
i=i+1;
Rnames{i} = 'IEPOXOO + MEO2 = 0.308*HACET + 0.308*CO + 0.28*HCHO +0.056*C4HC + 0.084*C4DH + 0.252*HOCCHO + 0.252*MGLY + 0.084*GLY + 0.7*HO2 + 0.3*ITHC + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
k(:,i) = 2E-13;
Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'MEO2'; 
fIEPOXOO(i)=fIEPOXOO(i)-1;fMEO2(i)=fMEO2(i)-1; fHCHO(i)=fHCHO(i)+1.03; fMEOH(i)=fMEOH(i)+0.25; fHACET(i)=fHACET(i)+0.308; fCO(i)=fCO(i)+0.308; fC4HC(i)=fC4HC(i)+0.056;
fC4DH(i)=fC4DH(i)+0.084; fHOCCHO(i)=fHOCCHO(i)+0.252; fMGLY(i)=fMGLY(i)+0.252; fGLY(i)=fGLY(i)+0.084; fHO2(i)=fHO2(i)+1.2; fITHC(i)=fITHC(i)+0.3;


% %IS113. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IEPOXOO + RO2C = 0.363*HACET + 0.138*HOCCHO + 0.138*GLY + 0.138*MGLY + 0.063*OH + 0.413*HO2 + 0.100*CO2 + 0.188*HCHO + 0.037*FACD + 0.126*CO + 0.5*PRD2 - 0.5*XC';
% k(:,i) = 3.5e-14;
% Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'RO2C'; 
% fIEPOXOO(i)=fIEPOXOO(i)-1;fRO2C(i)=fRO2C(i)-1;fHACET(i)=fHACET(i)+0.363;fHOCCHO(i)=fHOCCHO(i)+0.138;fGLY(i)=fGLY(i)+0.138;
% fMGLY(i)=fMGLY(i)+0.138;fOH(i)=fOH(i)+0.063;fHO2(i)=fHO2(i)+0.413;fCO2(i)=fCO2(i)+0.1;fHCHO(i)=fHCHO(i)+0.188;
% fFACD(i)=fFACD(i)+0.037;fCO(i)=fCO(i)+0.126;fPRD2(i)=fPRD2(i)+0.5;fXC(i)=fXC(i)-0.5;
i=i+1;
Rnames{i} = 'IEPOXOO + RO2C = 0.308*HACET + 0.308*CO + 0.28*HCHO +0.056*C4HC + 0.084*C4DH + 0.252*HOCCHO + 0.252*MGLY + 0.084*GLY + 0.7*HO2 + 0.3*ITHC';
k(:,i) = 3.5e-14;
Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'RO2C'; 
fIEPOXOO(i)=fIEPOXOO(i)-1;fRO2C(i)=fRO2C(i)-1; fHCHO(i)=fHCHO(i)+0.28; fHACET(i)=fHACET(i)+0.308; fCO(i)=fCO(i)+0.308; fC4HC(i)=fC4HC(i)+0.056;
fC4DH(i)=fC4DH(i)+0.084; fHOCCHO(i)=fHOCCHO(i)+0.252; fMGLY(i)=fMGLY(i)+0.252; fGLY(i)=fGLY(i)+0.084; fHO2(i)=fHO2(i)+0.7; fITHC(i)=fITHC(i)+0.3;

% %IS114. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IEPOXOO + MECO3 = 0.725*HACET + 0.275*HOCCHO + 0.275*GLY + 0.275*MGLY + 0.125*OH + 0.825*HO2 + 0.200*CO2 + 0.375*HCHO + 0.074*FACD + 0.251*CO + MEO2 + CO2';
% k(:,i) = 4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'MECO3'; 
% fIEPOXOO(i)=fIEPOXOO(i)-1;fMECO3(i)=fMECO3(i)-1;fHACET(i)=fHACET(i)+0.725;fHOCCHO(i)=fHOCCHO(i)+0.275;fGLY(i)=fGLY(i)+0.275;
% fMGLY(i)=fMGLY(i)+0.275;fOH(i)=fOH(i)+0.125;fHO2(i)=fHO2(i)+0.825;fCO2(i)=fCO2(i)+0.2;fHCHO(i)=fHCHO(i)+0.375;
% fFACD(i)=fFACD(i)+0.074;fCO(i)=fCO(i)+0.251;fMEO2(i)=fMEO2(i)+1;fCO2(i)=fCO2(i)+1;
i=i+1;
Rnames{i} = 'IEPOXOO + MECO3 = 0.308*HACET + 0.308*CO + 0.28*HCHO +0.056*C4HC + 0.084*C4DH + 0.252*HOCCHO + 0.252*MGLY + 0.084*GLY + 0.7*HO2 + 0.3*ITHC + MEO2 + CO2';
k(:,i) = 4.4e-13.*exp(1070./ T);
Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'MECO3'; 
fIEPOXOO(i)=fIEPOXOO(i)-1;fMECO3(i)=fMECO3(i)-1; fHCHO(i)=fHCHO(i)+0.28; fHACET(i)=fHACET(i)+0.308; fCO(i)=fCO(i)+0.308; fC4HC(i)=fC4HC(i)+0.056;
fC4DH(i)=fC4DH(i)+0.084; fHOCCHO(i)=fHOCCHO(i)+0.252; fMGLY(i)=fMGLY(i)+0.252; fGLY(i)=fGLY(i)+0.084; fHO2(i)=fHO2(i)+0.7; fITHC(i)=fITHC(i)+0.3; fMEO2(i)=fMEO2(i)+1;

i=i+1;
Rnames{i} = 'IEPOXOO + IEPOXOO = 0.616*HACET + 0.616*CO + 0.56*HCHO +0.112*C4HC + 0.168*C4DH + 0.504*HOCCHO + 0.504*MGLY + 0.168*GLY + 1.4*HO2 + 0.6*ITHC';
k(:,i) = KRO2RO2_HO.*0.95;
Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'IEPOXOO'; 
fIEPOXOO(i)=fIEPOXOO(i)-2; fHCHO(i)=fHCHO(i)+0.56; fHACET(i)=fHACET(i)+0.616; fCO(i)=fCO(i)+0.616; fC4HC(i)=fC4HC(i)+0.112;
fC4DH(i)=fC4DH(i)+0.168; fHOCCHO(i)=fHOCCHO(i)+0.504; fMGLY(i)=fMGLY(i)+0.504; fGLY(i)=fGLY(i)+0.168; fHO2(i)=fHO2(i)+1.4; fITHC(i)=fITHC(i)+0.6;
% i=i+1;
% Rnames{i} = 'IEPOXOO + IEPOXOO = C10dimer';
% k(:,i) = KRO2RO2_HO.*0.05;
% Gstr{i,1} = 'IEPOXOO'; Gstr{i,2} = 'IEPOXOO'; 
% fIEPOXOO(i)=fIEPOXOO(i)-2; fC10dimer(i)=fC10dimer(i)+1;

% below are new additional RO2 + RO2 rxns. Updated on 20220913 by HZ.
% --------------ISOPOOHOO-----------------
% explicit three isomers
% i=i+1;
% Rnames{i} = 'ISOPOOHOO1 + RO2C = 0.17*C4HP + 0.17*HCHO + 0.83*HPETHNL + 0.83*HACET + HO2';
% k(:,i) = 3.5e-14;
% Gstr{i,1} = 'ISOPOOHOO1'; Gstr{i,2} = 'RO2C'; 
% fISOPOOHOO1(i)=fISOPOOHOO1(i)-1; fRO2C(i)=fRO2C(i)-1; 
% fC4HP(i)=fC4HP(i)+0.17; fHCHO(i)=fHCHO(i)+0.17; fHPETHNL(i)=fHPETHNL(i)+0.83; fHACET(i)=fHACET(i)+0.83; fHO2(i)=fHO2(i)+1;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO1 + MEO2 = 0.17*C4HP + 0.17*HCHO + 0.83*HPETHNL + 0.83*HACET + HO2 + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
% k(:,i) = 2E-13;
% Gstr{i,1} = 'ISOPOOHOO1'; Gstr{i,2} = 'MEO2'; 
% fISOPOOHOO1(i)=fISOPOOHOO1(i)-1; fMEO2(i)=fMEO2(i)-1; fMEOH(i)=fMEOH(i)+0.25;
% fC4HP(i)=fC4HP(i)+0.17; fHCHO(i)=fHCHO(i)+0.93; fHPETHNL(i)=fHPETHNL(i)+0.83; fHACET(i)=fHACET(i)+0.83; fHO2(i)=fHO2(i)+1.5;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO1 + MECO3 =  0.17*C4HP + 0.17*HCHO + 0.83*HPETHNL + 0.83*HACET + HO2 + MEO2 + CO2';
% k(:,i) = 4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'ISOPOOHOO1'; Gstr{i,2} = 'MECO3'; 
% fISOPOOHOO1(i)=fISOPOOHOO1(i)-1; fMECO3(i)=fMECO3(i)-1; 
% fC4HP(i)=fC4HP(i)+0.17; fHCHO(i)=fHCHO(i)+0.17; fHPETHNL(i)=fHPETHNL(i)+0.83; fHACET(i)=fHACET(i)+0.83; fHO2(i)=fHO2(i)+1; fMEO2(i)=fMEO2(i)+1;
% 
% i=i+1;
% Rnames{i} = 'ISOPOOHOO2 + RO2C = 0.847*C4HP + 0.847*HCHO + 0.153*HOCCHO + 0.153*HPAC + HO2';
% k(:,i) = 3.5e-14;
% Gstr{i,1} = 'ISOPOOHOO2'; Gstr{i,2} = 'RO2C'; 
% fISOPOOHOO2(i)=fISOPOOHOO2(i)-1; fRO2C(i)=fRO2C(i)-1; 
% fC4HP(i)=fC4HP(i)+0.847; fHCHO(i)=fHCHO(i)+0.847; fHOCCHO(i)=fHOCCHO(i)+0.153; fHPAC(i)=fHPAC(i)+0.153; fHO2(i)=fHO2(i)+1;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO2 + MEO2 = 0.847*C4HP + 0.847*HCHO + 0.153*HOCCHO + 0.153*HPAC + HO2 + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
% k(:,i) = 2E-13;
% Gstr{i,1} = 'ISOPOOHOO2'; Gstr{i,2} = 'MEO2'; 
% fISOPOOHOO2(i)=fISOPOOHOO2(i)-1; fMEO2(i)=fMEO2(i)-1; fMEOH(i)=fMEOH(i)+0.25;
% fC4HP(i)=fC4HP(i)+0.847; fHCHO(i)=fHCHO(i)+1.597; fHOCCHO(i)=fHOCCHO(i)+0.153; fHPAC(i)=fHPAC(i)+0.153; fHO2(i)=fHO2(i)+1.5;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO2 + MECO3 = 0.847*C4HP + 0.847*HCHO + 0.153*HOCCHO + 0.153*HPAC + HO2 + MEO2 + CO2';
% k(:,i) = 4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'ISOPOOHOO2'; Gstr{i,2} = 'MECO3'; 
% fISOPOOHOO2(i)=fISOPOOHOO2(i)-1; fMECO3(i)=fMECO3(i)-1; 
% fC4HP(i)=fC4HP(i)+0.847; fHCHO(i)=fHCHO(i)+1.597; fHOCCHO(i)=fHOCCHO(i)+0.153; fHPAC(i)=fHPAC(i)+0.153; fHO2(i)=fHO2(i)+1.5; fMEO2(i)=fMEO2(i)+1;
% 
% i=i+1;
% Rnames{i} = 'ISOPOOHOO3 + RO2C = HOCCHO + HACET + OH';
% k(:,i) = 3.5e-14;
% Gstr{i,1} = 'ISOPOOHOO3'; Gstr{i,2} = 'RO2C'; 
% fISOPOOHOO3(i)=fISOPOOHOO3(i)-1; fRO2C(i)=fRO2C(i)-1; fHACET(i)=fHACET(i)+1; fHOCCHO(i)=fHOCCHO(i)+1; fOH(i)=fOH(i)+1;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO3 + MEO2 = HOCCHO + HACET + OH + 0.5*HO2 + 0.75*HCHO + 0.25*MEOH';
% k(:,i) = 2E-13;
% Gstr{i,1} = 'ISOPOOHOO3'; Gstr{i,2} = 'MEO2'; 
% fISOPOOHOO3(i)=fISOPOOHOO3(i)-1; fMEO2(i)=fMEO2(i)-1; fMEOH(i)=fMEOH(i)+0.25;
% fHACET(i)=fHACET(i)+1; fHOCCHO(i)=fHOCCHO(i)+1; fOH(i)=fOH(i)+1; fHCHO(i)=fHCHO(i)+0.75; fHO2(i)=fHO2(i)+0.5;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO3 + MECO3 = HOCCHO + HACET + OH + MEO2 + CO2';
% k(:,i) = 4.4e-13.*exp(1070./ T);
% Gstr{i,1} = 'ISOPOOHOO3'; Gstr{i,2} = 'MECO3'; 
% fISOPOOHOO3(i)=fISOPOOHOO3(i)-1; fMECO3(i)=fMECO3(i)-1; 
% fHACET(i)=fHACET(i)+1; fHOCCHO(i)=fHOCCHO(i)+1; fOH(i)=fOH(i)+1; fMEO2(i)=fMEO2(i)+1;

% lumped ISOPOOHOO
% i=i+1;
% Rnames{i} = 'ISOPOOHOO + RO2C = 0.22*C4HP + 0.22*HCHO + 0.25*HPETHNL + 0.75*HACET + 0.53*HOCCHO + 0.03*HPAC + 0.5*HO2 + 0.5*OH';
% k(:,i) = 2E-12;
% Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'RO2C'; 
% fISOPOOHOO(i)=fISOPOOHOO(i)-1; fRO2C(i)=fRO2C(i)-1; 
% fC4HP(i)=fC4HP(i)+0.22;fHCHO(i)=fHCHO(i)+0.22;fHPETHNL(i)=fHPETHNL(i)+0.25;fHACET(i)=fHACET(i)+0.75;fHOCCHO(i)=fHOCCHO(i)+0.53;fHPAC(i)=fHPAC(i)+0.03;fHO2(i)=fHO2(i)+0.5;fOH(i)=fOH(i)+0.5;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO + MEO2 = 0.22C4HP + 0.97*HCHO + 0.25*HPETHNL + 0.75*HACET + 0.53*HOCCHO + 0.03*HPAC + HO2 + 0.5*OH + 0.25*MEOH';
% k(:,i) = 2E-12;
% Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'MEO2'; 
% fISOPOOHOO(i)=fISOPOOHOO(i)-1; fMEO2(i)=fMEO2(i)-1; fMEOH(i)=fMEOH(i)+0.25;
% fC4HP(i)=fC4HP(i)+0.22;fHCHO(i)=fHCHO(i)+0.97;fHPETHNL(i)=fHPETHNL(i)+0.25;fHACET(i)=fHACET(i)+0.75;fHOCCHO(i)=fHOCCHO(i)+0.53;fHPAC(i)=fHPAC(i)+0.03;fHO2(i)=fHO2(i)+1;fOH(i)=fOH(i)+0.5;
% i=i+1;
% Rnames{i} = 'ISOPOOHOO + MECO3 = 0.22*C4HP + 0.22*HCHO + 0.25*HPETHNL + 0.75*HACET + 0.53*HOCCHO + 0.03*HPAC + 0.5*HO2 + 0.5*OH + MEO2 + CO2';
% k(:,i) = 2E-12;
% Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'MECO3'; 
% fISOPOOHOO(i)=fISOPOOHOO(i)-1; fMECO3(i)=fMECO3(i)-1; 
% fC4HP(i)=fC4HP(i)+0.22;fHCHO(i)=fHCHO(i)+0.22;fHPETHNL(i)=fHPETHNL(i)+0.25;fHACET(i)=fHACET(i)+0.75;fHOCCHO(i)=fHOCCHO(i)+0.53;fHPAC(i)=fHPAC(i)+0.03;fHO2(i)=fHO2(i)+0.5;fOH(i)=fOH(i)+0.5;fMEO2(i)=fMEO2(i)+1;

% Updated by HZ on 2023-07-05 to include HOM products, based on Mettke et
% al., 2023 ACS ESC.
i=i+1;
Rnames{i} = 'ISOPOOHOO + RO2C = 0.132*C4HP + 0.132*HCHO + 0.15*HPETHNL + 0.45*HACET + 0.318*HOCCHO + 0.018*HPAC + 0.3*HO2 + 0.3*OH + 0.15*ICPDH + 0.25*ITHP';
k(:,i) = 2E-12;
Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'RO2C'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fRO2C(i)=fRO2C(i)-1; 
fC4HP(i)=fC4HP(i)+0.132;fHCHO(i)=fHCHO(i)+0.132;fHPETHNL(i)=fHPETHNL(i)+0.15;fHACET(i)=fHACET(i)+0.45;fHOCCHO(i)=fHOCCHO(i)+0.318;fHPAC(i)=fHPAC(i)+0.018;fHO2(i)=fHO2(i)+0.3;fOH(i)=fOH(i)+0.3;fICPDH(i)=fOH(i)+0.15;fITHP(i)=fITHP(i)+0.25;
i=i+1;
Rnames{i} = 'ISOPOOHOO + MEO2 = 0.132*C4HP + 0.882*HCHO + 0.15*HPETHNL + 0.45*HACET + 0.318*HOCCHO + 0.018*HPAC + 0.8*HO2 + 0.3*OH + 0.15*ICPDH + 0.25*ITHP + 0.25*MEOH';
k(:,i) = 2E-12;
Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'MEO2'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fMEO2(i)=fMEO2(i)-1; fMEOH(i)=fMEOH(i)+0.25;
fC4HP(i)=fC4HP(i)+0.132;fHCHO(i)=fHCHO(i)+0.882;fHPETHNL(i)=fHPETHNL(i)+0.15;fHACET(i)=fHACET(i)+0.45;fHOCCHO(i)=fHOCCHO(i)+0.318;fHPAC(i)=fHPAC(i)+0.018;fHO2(i)=fHO2(i)+0.8;fOH(i)=fOH(i)+0.3;fICPDH(i)=fOH(i)+0.15;fITHP(i)=fITHP(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;
i=i+1;
Rnames{i} = 'ISOPOOHOO + MECO3 = 00.132*C4HP + 0.132*HCHO + 0.15*HPETHNL + 0.45*HACET + 0.318*HOCCHO + 0.018*HPAC + 0.3*HO2 + 0.3*OH + 0.15*ICPDH + 0.25*ITHP + MEO2 + CO2';
k(:,i) = 2E-12;
Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'MECO3'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-1; fMECO3(i)=fMECO3(i)-1; 
fC4HP(i)=fC4HP(i)+0.132;fHCHO(i)=fHCHO(i)+0.132;fHPETHNL(i)=fHPETHNL(i)+0.15;fHACET(i)=fHACET(i)+0.45;fHOCCHO(i)=fHOCCHO(i)+0.318;fHPAC(i)=fHPAC(i)+0.018;fHO2(i)=fHO2(i)+0.3;fOH(i)=fOH(i)+0.3;fICPDH(i)=fOH(i)+0.15;fITHP(i)=fITHP(i)+0.25;fMEO2(i)=fMEO2(i)+1;
% new reaction with high rate constant based on Mettke et al., 2023. HZ
% tuned the rate constant lower 
i=i+1;
Rnames{i} = 'ISOPOOHOO + ISOPOOHOO = 0.264*C4HP + 0.264*HCHO + 0.3*HPETHNL + 0.9*HACET + 0.636*HOCCHO + 0.036*HPAC + 0.6*HO2 + 0.6*OH + 0.3*ICPDH + 0.5*ITHP';
k(:,i) = KRO2RO2_HO.*0.95;
Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'ISOPOOHOO'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-2;
fC4HP(i)=fC4HP(i)+0.264;fHCHO(i)=fHCHO(i)+0.264;fHPETHNL(i)=fHPETHNL(i)+0.3;fHACET(i)=fHACET(i)+0.9;fHOCCHO(i)=fHOCCHO(i)+0.636;fHPAC(i)=fHPAC(i)+0.036;fHO2(i)=fHO2(i)+0.6;fOH(i)=fOH(i)+0.6;fICPDH(i)=fOH(i)+0.3;fITHP(i)=fITHP(i)+0.5;
i=i+1;
Rnames{i} = ' ISOPOOHOO + ISOPOOHOO = C10dimer';
k(:,i) = KRO2RO2_HO.*0.05;
Gstr{i,1} = 'ISOPOOHOO'; Gstr{i,2} = 'ISOPOOHOO'; 
fISOPOOHOO(i)=fISOPOOHOO(i)-2; fC10dimer(i)=fC10dimer(i)+1;

% --------------IHPNOO----------------
i=i+1;
Rnames{i} = 'IHPNOO + RO2C = 0.7*NO2 + 0.7*PROPNN + 0.7*HO2 + 0.7*HPETHNL + 0.3*IDHPN';
k(:,i) = 3.5e-14;
Gstr{i,1} = 'IHPNOO'; Gstr{i,2} = 'RO2C'; 
fIHPNOO(i)=fIHPNOO(i)-1; fRO2C(i)=fRO2C(i)-1; 
fNO2(i)=fNO2(i)+0.7;fPROPNN(i)=fPROPNN(i)+0.7;fHO2(i)=fHO2(i)+0.7;fHPETHNL(i)=fHPETHNL(i)+0.7;fIDHPN(i)=fIDHPN(i)+0.3;
i=i+1;
Rnames{i} = 'IHPNOO + MEO2 = 0.7*NO2 + 0.7*PROPNN + 0.7*HO2 + 0.7*HPETHNL + 0.3*IDHPN + 0.25*HCHO + 0.25*MEOH + 0.50*HCHO + 0.50*HO2';
k(:,i) = 2E-13;
Gstr{i,1} = 'IHPNOO'; Gstr{i,2} = 'MEO2'; 
fIHPNOO(i)=fIHPNOO(i)-1; fMEO2(i)=fMEO2(i)-1;
fNO2(i)=fNO2(i)+0.7;fPROPNN(i)=fPROPNN(i)+0.7;fHO2(i)=fHO2(i)+0.7;fHPETHNL(i)=fHPETHNL(i)+0.7;fIDHPN(i)=fIDHPN(i)+0.3;
fHCHO(i)=fHCHO(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;fHCHO(i)=fHCHO(i)+0.5;fHO2(i)=fHO2(i)+0.5;
i=i+1;
Rnames{i} = 'IHPNOO + MECO3 = 0.7*NO2 + 0.7*PROPNN + 0.7*HO2 + 0.7*HPETHNL + 0.3*IDHPN + MEO2 + CO2';
k(:,i) = 4.4e-13.*exp(1070./ T);
Gstr{i,1} = 'IHPNOO'; Gstr{i,2} = 'MECO3'; 
fIHPNOO(i)=fIHPNOO(i)-1; fMECO3(i)=fMECO3(i)-1; 
fNO2(i)=fNO2(i)+0.7;fPROPNN(i)=fPROPNN(i)+0.7;fHO2(i)=fHO2(i)+0.7;fHPETHNL(i)=fHPETHNL(i)+0.7;fIDHPN(i)=fIDHPN(i)+0.3;fMEO2(i)=fMEO2(i)+1;

% --------------IHDNOO----------------
i=i+1;
Rnames{i} = 'IHDNOO + RO2C = 0.7*NO2 + 0.7*HCHO + 0.7*MVKN + 0.3*IDHDN';
k(:,i) = 3.5e-14;
Gstr{i,1} = 'IHDNOO'; Gstr{i,2} = 'RO2C'; 
fIHDNOO(i)=fIHDNOO(i)-1; fRO2C(i)=fRO2C(i)-1; 
fNO2(i)=fNO2(i)+0.7;fHCHO(i)=fHCHO(i)+0.7;fMVKN(i)=fMVKN(i)+0.7;fIDHDN(i)=fIDHDN(i)+0.3;
i=i+1;
Rnames{i} = 'IHDNOO + MEO2 = 0.7*NO2 + 0.7*HCHO + 0.7*MVKN + 0.3*IDHDN + 0.25*HCHO + 0.25*MEOH + 0.50*HCHO + 0.50*HO2';
k(:,i) = 2E-13;
Gstr{i,1} = 'IHDNOO'; Gstr{i,2} = 'MEO2'; 
fIHDNOO(i)=fIHDNOO(i)-1; fMEO2(i)=fMEO2(i)-1;
fNO2(i)=fNO2(i)+0.7;fHCHO(i)=fHCHO(i)+0.7;fMVKN(i)=fMVKN(i)+0.7;fIDHDN(i)=fIDHDN(i)+0.3;
fHCHO(i)=fHCHO(i)+0.25;fMEOH(i)=fMEOH(i)+0.25;fHCHO(i)=fHCHO(i)+0.5;fHO2(i)=fHO2(i)+0.5;
i=i+1;
Rnames{i} = 'IHDNOO + MECO3 = 0.7*NO2 + 0.7*HCHO + 0.7*MVKN + 0.3*IDHDN + MEO2 + CO2';
k(:,i) = 4.4e-13.*exp(1070./ T);
Gstr{i,1} = 'IHDNOO'; Gstr{i,2} = 'MECO3'; 
fIHDNOO(i)=fIHDNOO(i)-1; fMECO3(i)=fMECO3(i)-1; 
fNO2(i)=fNO2(i)+0.7;fHCHO(i)=fHCHO(i)+0.7;fMVKN(i)=fMVKN(i)+0.7;fIDHDN(i)=fIDHDN(i)+0.3;fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'IHDNOO + IHDNOO = 1.4*NO2 + 1.4*HCHO + 1.4*MVKN + 0.6*IDHDN';
k(:,i) = KRO2RO2_HO.*0.95;
Gstr{i,1} = 'IHDNOO'; Gstr{i,2} = 'IHDNOO'; 
fIHDNOO(i)=fIHDNOO(i)-2; fNO2(i)=fNO2(i)+1.4;fHCHO(i)=fHCHO(i)+1.4;fMVKN(i)=fMVKN(i)+1.4;fIDHDN(i)=fIDHDN(i)+0.6;
i=i+1;
Rnames{i} = 'IHDNOO + IHDNOO = C10dimer';
k(:,i) = KRO2RO2_HO.*0.05;
Gstr{i,1} = 'IHDNOO'; Gstr{i,2} = 'IHDNOO'; 
fIHDNOO(i)=fIHDNOO(i)-2; fC10dimer(i)=fC10dimer(i)+1;

% --------------NIEPOXOO----------------
i=i+1;
Rnames{i} = 'NIEPOXOO + RO2C = 0.2*IHNE + 0.5*ICNE + 0.3*ICHE + 0.3*NO2';
k(:,i) = 2e-12;
Gstr{i,1} = 'NIEPOXOO'; Gstr{i,2} = 'RO2C'; 
fNIEPOXOO(i)=fNIEPOXOO(i)-1; fRO2C(i)=fRO2C(i)-1; 
fNO2(i)=fNO2(i)+0.3; fIHNE(i)=fIHNE(i)+0.2; fICNE(i)=fICNE(i)+0.5; fICHE(i)=fICHE(i)+0.3;
i=i+1;
Rnames{i} = 'NIEPOXOO + MEO2 = 0.2*IHNE + 0.5*ICNE + 0.3*ICHE + 0.3*NO2 + 0.25*MEOH + 0.75*HCHO + 0.50*HO2';
k(:,i) = 2E-13;
Gstr{i,1} = 'NIEPOXOO'; Gstr{i,2} = 'MEO2'; 
fNIEPOXOO(i)=fNIEPOXOO(i)-1; fMEO2(i)=fMEO2(i)-1;
fNO2(i)=fNO2(i)+0.3; fIHNE(i)=fIHNE(i)+0.2; fICNE(i)=fICNE(i)+0.5; fICHE(i)=fICHE(i)+0.3;
fHCHO(i)=fHCHO(i)+0.75; fMEOH(i)=fMEOH(i)+0.25; fHO2(i)=fHO2(i)+0.5;
i=i+1;
Rnames{i} = 'NIEPOXOO + MECO3 = 0.2*IHNE + 0.5*ICNE + 0.3*ICHE + 0.3*NO2 + MEO2 + CO2';
k(:,i) = 4.4e-13.*exp(1070./ T);
Gstr{i,1} = 'NIEPOXOO'; Gstr{i,2} = 'MECO3'; 
fNIEPOXOO(i)=fNIEPOXOO(i)-1; fMECO3(i)=fMECO3(i)-1; 
fNO2(i)=fNO2(i)+0.3; fIHNE(i)=fIHNE(i)+0.2; fICNE(i)=fICNE(i)+0.5; fICHE(i)=fICHE(i)+0.3; fMEO2(i)=fMEO2(i)+1;
i=i+1;
Rnames{i} = 'NIEPOXOO + NIEPOXOO = 0.4*IHNE + 1*ICNE + 0.6*ICHE + 0.6*NO2';
k(:,i) = KRO2RO2_HO.*0.95;
Gstr{i,1} = 'NIEPOXOO'; Gstr{i,2} = 'NIEPOXOO'; 
fNIEPOXOO(i)=fNIEPOXOO(i)-2; fNO2(i)=fNO2(i)+0.6; fIHNE(i)=fIHNE(i)+0.4; fICNE(i)=fICNE(i)+1; fICHE(i)=fICHE(i)+0.6;
% i=i+1;
% Rnames{i} = 'NIEPOXOO + NIEPOXOO = C10dimer';
% k(:,i) = KRO2RO2_HO.*0.05;
% Gstr{i,1} = 'NIEPOXOO'; Gstr{i,2} = 'NIEPOXOO'; 
% fNIEPOXOO(i)=fNIEPOXOO(i)-2; fC10dimer(i)=fC10dimer(i)+1;

%% RO2 + NO3
% --------------NISOPO2----------------
% %IS10. updated with the rxn below.
% i=i+1;
% Rnames{i} = ' NISOPO2 + NO3 = 0.70*NIT1 + 0.035*MVK + 0.035*MACR + 1.3*NO2 + 0.80*HO2 + 0.070*HCHO + 0.23*HC5';
% k(:,i) =  2.3e-12;
% Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'NO3'; 
% fNISOPO2(i)=fNISOPO2(i)-1; fNO3(i)=fNO3(i)-1; fNIT1(i)=fNIT1(i)+0.7; fMVK(i)=fMVK(i)+0.035;
% fMACR(i)=fMACR(i)+0.035;fNO2(i)=fNO2(i)+1.3;fHO2(i)=fHO2(i)+0.8;fHCHO(i)=fHCHO(i)+0.07;fHC5(i)=fHC5(i)+0.23;

% combined mechanism, assuming 100% of the beta-1-2-INO forms NIEPOXOO.
i=i+1;
Rnames{i} = ' NISOPO2 + NO3 = 1.438*NO2 + 0.008*MVK + 0.046*MACR + 0.054*HCHO + 0.152*NIT1 + 0.152*HO2 + 0.385*HC5 + 0.409*NIEPOXOO';
k(:,i) =  2.3e-12;
Gstr{i,1} = 'NISOPO2'; Gstr{i,2} = 'NO3'; 
fNISOPO2(i)=fNISOPO2(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1.438;fMVK(i)=fMVK(i)+0.008;fMACR(i)=fMACR(i)+0.046;
fHCHO(i)=fHCHO(i)+0.054;fNIT1(i)=fNIT1(i)+0.152; fHO2(i)=fHO2(i)+0.152;fHC5(i)=fHC5(i)+0.385;fNIEPOXOO(i)=fNIEPOXOO(i)+0.409;

% --------------NIT1NO3OOA----------------
%IS32. Unchanged.
i=i+1;
Rnames{i} = 'NIT1NO3OOA + NO3 =  NO2 + PROPNN + CO + CO2 + HO2';
k(:,i) =  4e-12;
Gstr{i,1} = 'NIT1NO3OOA'; Gstr{i,2} = 'NO3'; 
fNIT1NO3OOA(i)=fNIT1NO3OOA(i)-1; fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1;fPROPNN(i)=fPROPNN(i)+1;fCO(i)=fCO(i)+1;
fCO2(i)=fCO2(i)+1;fHO2(i)=fHO2(i)+1;

% %IS33. Removed.
% i=i+1;
% Rnames{i} =' NIT1NO3OOB + NO3 = ISOPNN + GLY + NO2 ';
% k(:,i) =  2.3e-12;
% Gstr{i,1} = 'NIT1NO3OOB'; Gstr{i,2} = 'NO3'; 
% fNIT1NO3OOB(i)=fNIT1NO3OOB(i)-1; fNO3(i)=fNO3(i)-1;fISOPNN(i)=fISOPNN(i)+1;fGLY(i)=fGLY(i)+1;
% fNO2(i)=fNO2(i)+1;

% --------------IMACO3----------------
%IA71. Unchanged.
i=i+1;
Rnames{i} =' IMACO3 + NO3 = NO2 + CO + CO2 + HCHO + MEO2 ';
k(:,i) = 4e-12;
Gstr{i,1} = 'IMACO3'; Gstr{i,2} = 'NO3'; 
fIMACO3(i)=fIMACO3(i)-1;fNO3(i)=fNO3(i)-1;fNO2(i)=fNO2(i)+1;fCO(i)=fCO(i)+1;fCO2(i)=fCO2(i)+1;
fHCHO(i)=fHCHO(i)+1;fMEO2(i)=fMEO2(i)+1;

% below are new additional RO2 + NO3 rxns.
% --------------IHPNOO-----------------
i=i+1;
Rnames{i} =' IHPNOO + NO3 = 2*NO2 + PROPNN + HO2 + HPETHNL ';
k(:,i) = 4e-12;
Gstr{i,1} = 'IHPNOO'; Gstr{i,2} = 'NO3'; 
fIHPNOO(i)=fIHPNOO(i)-1;fNO3(i)=fNO3(i)-1;fNO2(i)=fNO2(i)+2;fPROPNN(i)=fPROPNN(i)+1;fHO2(i)=fHO2(i)+1;fHPETHNL(i)=fHPETHNL(i)+1;
% --------------IHDNOO-----------------
i=i+1;
Rnames{i} = 'IHDNOO + NO3 = 2*NO2 + HCHO + MVKN';
k(:,i) = 4e-12;
Gstr{i,1} = 'IHDNOO'; Gstr{i,2} = 'NO3'; 
fIHDNOO(i)=fIHDNOO(i)-1;fNO3(i)=fNO3(i)-1;fNO2(i)=fNO2(i)+2;fHCHO(i)=fHCHO(i)+1;fMVKN(i)=fMVKN(i)+1;
% --------------NIEPOXOO-----------------
i=i+1;
Rnames{i} =' NIEPOXOO + NO3 = 1.5*NO2 + 0.5*ICHE + 0.5*ICNE ';
k(:,i) = 4e-12;
Gstr{i,1} = 'NIEPOXOO'; Gstr{i,2} = 'NO3';
fNIEPOXOO(i)=fNIEPOXOO(i)-1;fNO3(i)=fNO3(i)-1; fNO2(i)=fNO2(i)+1.5; fICHE(i)=fICHE(i)+0.5; fICNE(i)=fICNE(i)+0.5;
%% HPALD rxns
% %IS137. updated with the rxns below on 20220912. Entirely based on the
% Caltech mechanism.
% i=i+1;
% Rnames{i} = ' HPALD + hv = OH + HO2 + 0.5*HACET + 0.5*MGLY + 0.25*HOCCHO + 0.25*GLY + HCHO ';
% k(:,i) = JHPALD;
% Gstr{i,1} = 'HPALD'; 
% fHPALD(i)=fHPALD(i)-1;
% fHO2(i)=fHO2(i)+1;fHACET(i)=fHACET(i)+0.5;fOH(i)=fOH(i)+1;fMGLY(i)=fMGLY(i)+0.5;fHOCCHO(i)=fHOCCHO(i)+0.25;
% fGLY(i)=fGLY(i)+0.25;fHCHO(i)=fHCHO(i)+1;

i=i+1;
Rnames{i} = 'HPALD1 = CO + OH + HO2 + 0.15*MVK + 0.85*MACR';
k(:,i) = JHPALD;
Gstr{i,1} = 'HPALD1'; 
fHPALD1(i)=fHPALD1(i)-1; 
fCO(i)=fCO(i)+1; fOH(i)=fOH(i)+1; fHO2(i)=fHO2(i)+1; fMVK(i)=fMVK(i)+0.15; fMACR(i)=fMACR(i)+0.85;
i=i+1;
Rnames{i} = 'HPALD2 = CO + 1.64075*OH + 0.1715*HO2 + 0.46955*C4ENOL + 0.1715*IDC + 0.1715*MGLY + 0.0336*MVKOO + 0.1547*MACROO + 0.1883*RO2C';
k(:,i) = JHPALD;
Gstr{i,1} = 'HPALD2';
fHPALD2(i)=fHPALD2(i)-1;
fCO(i)=fCO(i)+1; fOH(i)=fOH(i)+1.64075; fHO2(i)=fHO2(i)+0.1715; fC4ENOL(i)=fC4ENOL(i)+0.46955; fIDC(i)=fIDC(i)+0.1715; fMGLY(i)=fMGLY(i)+0.1715;
fMVKOO(i)=fMVKOO(i)+0.0336; fMACROO(i)=fMACROO(i)+0.1547; fRO2C(i)=fRO2C(i)+0.1883;


% %IS138. updated with the rxns below on 20220912.
% i=i+1;
% Rnames{i} = ' HPALD + OH = OH + PRD2 - XC ';
% k(:,i) = 4.6e-11;
% Gstr{i,1} = 'HPALD'; Gstr{i,2} = 'OH';
% fHPALD(i)=fHPALD(i)-1;
% fOH(i)=fOH(i)-1;fOH(i)=fOH(i)+1;fPRD2(i)=fPRD2(i)+1;fXC(i)=fXC(i)-1;
i=i+1;
Rnames{i} = 'HPALD1 + OH = OH + 0.2585*CO + 0.7415*ICHE + 0.0345*MVK + 0.119*MACR + 0.105*C4HP';
k(:,i) = 3.305E-11*exp(390./T); % proportioned by the two beta-HPALD isomer reactions.
Gstr{i,1} = 'HPALD1'; Gstr{i,2} = 'OH'; 
fHPALD1(i)=fHPALD1(i)-1;
fCO(i)=fCO(i)+0.2585; fICHE(i)=fICHE(i)+0.7415; fMVK(i)=fMVK(i)+0.0345; fMACR(i)=fMACR(i)+0.119; fC4HP(i)=fC4HP(i)+0.105;

i=i+1;
Rnames{i} = 'HPALD2 + OH = 0.375*CO + 1.475*OH + 0.16*HO2 + 0.16*HCHO + 0.16*MGLY + 0.16*ICHE + 0.0525*MVK + 0.2975*MACR + 0.15*IDC + 0.18*C4HP + 0.315*RO2C  + 0.315*CO2';
k(:,i) = 1.17E-11*exp(450./T) ;
Gstr{i,1} = 'HPALD2'; Gstr{i,2} = 'OH'; 
fHPALD2(i)=fHPALD2(i)-1; fOH(i)=fOH(i)+0.475;
fCO(i)=fCO(i)+0.375; fHO2(i)=fHO2(i)+0.16; fHCHO(i)=fHCHO(i)+0.16; fMGLY(i)=fMGLY(i)+0.16; fICHE(i)=fICHE(i)+0.16; fMVK(i)=fMVK(i)+0.0525; fMACR(i)=fMACR(i)+0.2975; fIDC(i)=fIDC(i)+0.15; 
fC4HP(i)=fC4HP(i)+0.18; fRO2C(i)=fRO2C(i)+0.315;

%% ISOPOOH rxns
% %IS88 and IS89. updated with the rxns below on 20220912 based on the
% Caltech mechanism.
% i=i+1;
% Rnames{i} =' ISOPOOH + OH = IEPOX + OH';
% k(:,i) = 1.9e-11.*exp(390./ T);
% Gstr{i,1} = 'ISOPOOH'; Gstr{i,2} = 'OH'; 
% fISOPOOH(i)=fISOPOOH(i)-1;fOH(i)=fOH(i)-1;fOH(i)=fOH(i)+1;fIEPOX(i)=fIEPOX(i)+1;
% %IS89
% i=i+1;
% Rnames{i} =' ISOPOOH + OH = 0.387*ISOPO2 + 0.613*HC5 + 0.613*OH';
% k(:,i) = 4.75e-12.*exp(200./ T);
% Gstr{i,1} = 'ISOPOOH'; Gstr{i,2} = 'OH'; 
% fISOPOOH(i)=fISOPOOH(i)-1;fOH(i)=fOH(i)-1;fOH(i)=fOH(i)+0.613;fISOPO2(i)=fISOPO2(i)+0.387;
% fHC5(i)=fHC5(i)+0.613;

% Version 1: The overall branching ratio of the three pathways changed to
% 0.71 (IEPOX):0.17(ISOPOOHOO):0.12(abstraction) based on Wennberg et al.
% 2018
% explicit three isomers
% i=i+1;
% Rnames{i} = 'ISOPOOH12 + OH = 0.72OH + 0.72IEPOXB + 0.079ISOPOOHOO3 + 0.041ISOPOOHOO1 + 0.12ISOP1OHOO + 0.02MVK + 0.02C4HP + 0.04HO2 + 0.04CO';
% k(:,i) = 2.06E-11*exp(390./T);
% Gstr{i,1} = 'ISOPOOH12'; Gstr{i,2} = 'OH'; 
% fISOPOOH12(i)=fISOPOOH12(i)-1; fOH(i)=fOH(i)-0.28; fIEPOXB(i)=fIEPOXB(i)+0.72; fISOPOOHOO3(i)=fISOPOOHOO3(i)+0.079; fISOPOOHOO1(i)=fISOPOOHOO1(i)+0.041; fISOP1OHOO(i)=fISOP1OHOO(i)+0.12;fMVK(i)=fMVK(i)+0.02; fC4HP(i)=fC4HP(i)+0.02; fHO2(i)=fHO2(i)+0.04; fCO(i)=fCO(i)+0.04; 

% lumped ISOPOOHOO
i=i+1;
Rnames{i} = 'ISOPOOH12 + OH = 0.71OH + 0.71IEPOXB + 0.17ISOPOOHOO + 0.12ISOP1OHOO';
k(:,i) = F0AM_isop_EPO(T,M,2.25E-11,390,4.77E-21);
Gstr{i,1} = 'ISOPOOH12'; Gstr{i,2} = 'OH'; 
fISOPOOH12(i)=fISOPOOH12(i)-1; fOH(i)=fOH(i)-0.29;
fIEPOXB(i)=fIEPOXB(i)+0.71;fISOPOOHOO(i)=fISOPOOHOO(i)+0.17;fISOP1OHOO(i)=fISOP1OHOO(i)+0.12;

% explicit three isomers
% i=i+1;
% Rnames{i} = 'ISOPOOH43 + OH = 0.81OH + 0.8IEPOXB + 0.092ISOPOOHOO3 + 0.048ISOPOOHOO2 + 0.031ISOP4OHOO + 0.01HC5 + 0.02CO + 0.02HO2 + 0.01MACR + 0.01C4HP';
% k(:,i) = 3.2E-11*exp(390./T);
% Gstr{i,1} = 'ISOPOOH43'; Gstr{i,2} = 'OH'; 
% fISOPOOH43(i)=fISOPOOH43(i)-1;fOH(i)=fOH(i)-0.19; fIEPOXB(i)=fIEPOXB(i)+0.8; fISOPOOHOO3(i)=fISOPOOHOO3(i)+0.092; fISOPOOHOO2(i)=fISOPOOHOO2(i)+0.048;fISOP4OHOO(i)=fISOP4OHOO(i)+0.031; fHC5(i)=fHC5(i)+0.01; fCO(i)=fCO(i)+0.02; fHO2(i)=fHO2(i)+0.02; fMACR(i)=fMACR(i)+0.01; fC4HP(i)=fC4HP(i)+0.01; 

% lumped ISOPOOHOO
i=i+1;
Rnames{i} = 'ISOPOOH43 + OH = 0.8OH + 0.8IEPOXB + 0.15ISOPOOHOO + 0.03ISOP4OHOO + 0.02CO + 0.02HO2 + 0.01MACR + 0.01C4HP';
k(:,i) = F0AM_isop_EPO(T,M,3.56E-11,390,4.77E-21);
Gstr{i,1} = 'ISOPOOH43'; Gstr{i,2} = 'OH'; 
fISOPOOH43(i)=fISOPOOH43(i)-1;fOH(i)=fOH(i)-0.2; 
fIEPOXB(i)=fIEPOXB(i)+0.8;fISOPOOHOO(i)=fISOPOOHOO(i)+0.15;fISOP4OHOO(i)=fISOP4OHOO(i)+0.03;fCO(i)=fCO(i)+0.02; fHO2(i)=fHO2(i)+0.02; fMACR(i)=fMACR(i)+0.01; fC4HP(i)=fC4HP(i)+0.01; 


% Version 2: ISOPOOH + OH modified by HZ on 20220921 to bring the difference closer to
% Thornton, for better SOA simulations.
% i=i+1;
% Rnames{i} = 'ISOPOOH12 + OH = 0.71*OH + 0.71*IEPOXB + 0.111*ISOPOOHOO3 + 0.059*ISOPOOHOO1 + 0.09*ISOP1OHOO + 0.015*MVK + 0.015*C4HP + 0.03*HO2 + 0.03*CO';
% k(:,i) = 1.15*2.06E-11*exp(390./T); % rate constant multiplied by a factor of 1.15 to reach upper estimate by Wennberg. k298 ~ 8.8e-11. Still lower than Thornton (1.25e-10)
% Gstr{i,1} = 'ISOPOOH12'; Gstr{i,2} = 'OH'; 
% fISOPOOH12(i)=fISOPOOH12(i)-1; fOH(i)=fOH(i)-0.29; fIEPOXB(i)=fIEPOXB(i)+0.71; fISOPOOHOO3(i)=fISOPOOHOO3(i)+0.111; fISOPOOHOO1(i)=fISOPOOHOO1(i)+0.059; fISOP1OHOO(i)=fISOP1OHOO(i)+0.09;fMVK(i)=fMVK(i)+0.015; fC4HP(i)=fC4HP(i)+0.015; fHO2(i)=fHO2(i)+0.03; fCO(i)=fCO(i)+0.03; 
% 
% i=i+1;
% Rnames{i} = 'ISOPOOH43 + OH = 0.796*OH + 0.79*IEPOXB + 0.111*ISOPOOHOO3 + 0.059*ISOPOOHOO2 + 0.020*ISOP4OHOO + 0.006*HC5 + 0.013*CO + 0.013*HO2 + 0.007*MACR + 0.007*C4HP';
% k(:,i) = 1.15*3.2E-11*exp(390./T);% rate constant multiplied by a factor of 1.15 to reach upper estimate by Wennberg. k298 ~ 1.36e-10. High than Thornton (1.25e-10)
% Gstr{i,1} = 'ISOPOOH43'; Gstr{i,2} = 'OH'; 
% fISOPOOH43(i)=fISOPOOH43(i)-1;fOH(i)=fOH(i)-0.204; fIEPOXB(i)=fIEPOXB(i)+0.79; fISOPOOHOO3(i)=fISOPOOHOO3(i)+0.111; fISOPOOHOO2(i)=fISOPOOHOO2(i)+0.059;fISOP4OHOO(i)=fISOP4OHOO(i)+0.020; fHC5(i)=fHC5(i)+0.006; fCO(i)=fCO(i)+0.013; fHO2(i)=fHO2(i)+0.013; fMACR(i)=fMACR(i)+0.007; fC4HP(i)=fC4HP(i)+0.007; 

% delta-ISOPOOHs (ISOPOOHD) oxidation rxn is not varied.
% explicit three ISOPOOHOO isomers
% i=i+1;
% Rnames{i} = 'ISOPOOHD + OH = 0.38675*ISOPOOHOO1 + 0.08925*ISOPOOHOO2 + 0.0195*ISOP1OHOO + 0.0105*ISOP4OHOO + 0.374*IEPOXD + 0.06*HC5 + 0.524*OH + 0.0303*HO2 + 0.009*HPALD1 + 0.015*HPALD2 + 0.0423*CO + 0.018*HCHO + 0.018*MGLY + 0.0117*HPETHNL + 0.0117*MECO3 + 0.0063*HPAC';
% k(:,i) = 3.53E-11*exp(390./T);
% Gstr{i,1} = 'ISOPOOHD'; Gstr{i,2} = 'OH';
% fISOPOOHD(i)=fISOPOOHD(i)-1; fOH(i)=fOH(i)-0.476;
% fISOPOOHOO1(i)=fISOPOOHOO1(i)+0.38675; fISOPOOHOO2(i)=fISOPOOHOO2(i)+0.08925; fISOP1OHOO(i)=fISOP1OHOO(i)+0.0195; fISOP4OHOO(i)=fISOP4OHOO(i)+0.0105; fIEPOXD(i)=fIEPOXD(i)+0.374; fHC5(i)=fHC5(i)+0.06; fHO2(i)=fHO2(i)+0.0303; fHPALD1(i)=fHPALD1(i)+0.009; fHPALD2(i)=fHPALD2(i)+0.015; 
% fCO(i)=fCO(i)+0.0423; fHCHO(i)=fHCHO(i)+0.018; fMGLY(i)=fMGLY(i)+0.018; fHPETHNL(i)=fHPETHNL(i)+0.0117; fMECO3(i)=fMECO3(i)+0.0117; fHPAC(i)=fHPAC(i)+0.0063;

% lumped ISOPOOHOO
i=i+1;
Rnames{i} = 'ISOPOOHD + OH = 0.41ISOPOOHOO + 0.015ISOP1OHOO + 0.015ISOP4OHOO + 0.425IEPOXD + 0.06HC5 + 0.575OH + 0.033HO2 + 0.012HPALD1 + 0.012HPALD2 + 0.05CO + 0.02HCHO + 0.02MGLY + 0.01HPETHNL + 0.01MECO3 + 0.01HPAC';
k(:,i) = 3.53E-11*exp(390./T);
Gstr{i,1} = 'ISOPOOHD'; Gstr{i,2} = 'OH'; 
fISOPOOHD(i)=fISOPOOHD(i)-1; fOH(i)=fOH(i)-0.425;
fISOPOOHOO(i)=fISOPOOHOO(i)+0.41; fISOP1OHOO(i)=fISOP1OHOO(i)+0.015;fISOP4OHOO(i)=fISOP4OHOO(i)+0.015;fIEPOXD(i)=fIEPOXD(i)+0.425;fHC5(i)=fHC5(i)+0.06; fHO2(i)=fHO2(i)+0.033; fHPALD1(i)=fHPALD1(i)+0.012; fHPALD2(i)=fHPALD2(i)+0.012;fCO(i)=fCO(i)+0.05; fHCHO(i)=fHCHO(i)+0.02; fMGLY(i)=fMGLY(i)+0.02; fHPETHNL(i)=fHPETHNL(i)+0.01; fMECO3(i)=fMECO3(i)+0.01; fHPAC(i)=fHPAC(i)+0.01;

% %IS92. updated with the rxns below.
% i=i+1;
% Rnames{i} =' ISOPOOH + hv = OH + 0.91*HO2 + 0.75*HCHO + 0.45*MVK + 0.29*MACR + 0.09*DIBOO + 0.11*HC5 + 0.05*ARO2MN - 0.16*XC';
% k(:,i) = 1.0.*JCOOH;
% Gstr{i,1} = 'ISOPOOH'; 
% fISOPOOH(i)=fISOPOOH(i)-1;fOH(i)=fOH(i)+1;fHO2(i)=fHO2(i)+0.91;fHCHO(i)=fHCHO(i)+0.75;
% fMVK(i)=fMVK(i)+0.45;fMACR(i)=fMACR(i)+0.29;fDIBOO(i)=fDIBOO(i)+0.09;fHC5(i)=fHC5(i)+0.11;fARO2MN(i)=fARO2MN(i)+0.05;
% fXC(i)=fXC(i)-0.16;
i=i+1;
Rnames{i} = 'ISOPOOH12 = MVK + HCHO + HO2 + OH';
k(:,i) = JCOOH; %J41;
Gstr{i,1} = 'ISOPOOH12'; 
fISOPOOH12(i)=fISOPOOH12(i)-1; fMVK(i)=fMVK(i)+1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; fOH(i)=fOH(i)+1;
i=i+1;
Rnames{i} = 'ISOPOOH43 = MACR + HCHO + HO2 + OH';
k(:,i) = JCOOH; %J41;
Gstr{i,1} = 'ISOPOOH43'; 
fISOPOOH43(i)=fISOPOOH43(i)-1; fMACR(i)=fMACR(i)+1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; fOH(i)=fOH(i)+1; 

%% IEPOX rxns
% %IS90. updated with the rxns below on 20220913
% i=i+1;
% Rnames{i} =' IEPOX + OH = IEPOXOO';
% k(:,i) = 5.78e-11.*exp(-400./ T);
% Gstr{i,1} = 'IEPOX'; Gstr{i,2} = 'OH'; 
% fIEPOX(i)=fIEPOX(i)-1;fOH(i)=fOH(i)-1;fIEPOXOO(i)=fIEPOXOO(i)+1;
i=i+1;
Rnames{i} = 'IEPOXD + OH = 0.75*ICHE + 0.75*HO2 + 0.25*IEPOXOO';
k(:,i) = 3.22E-11*exp(-400./T);
Gstr{i,1} = 'IEPOXD'; Gstr{i,2} = 'OH'; 
fIEPOXD(i)=fIEPOXD(i)-1; fOH(i)=fOH(i)-1; fICHE(i)=fICHE(i)+0.75; fHO2(i)=fHO2(i)+0.75; fIEPOXOO(i)=fIEPOXOO(i)+0.25;
i=i+1;
Rnames{i} = 'IEPOXB + OH = ICHE + HO2';
k(:,i) = 9.76E-12*exp(-400./T); 
Gstr{i,1} = 'IEPOXB'; Gstr{i,2} = 'OH'; 
fIEPOXB(i)=fIEPOXB(i)-1; fOH(i)=fOH(i)-1; fICHE(i)=fICHE(i)+1; fHO2(i)=fHO2(i)+1;
i=i+1;
Rnames{i} = 'IEPOXB + OH = IEPOXOO';
k(:,i) = 0.67*F0AM_isop_EPO(T,M,5.82E-11,-400,1.14E-20) + 0.33*F0AM_isop_EPO(T,M,3.75E-11,-400,8.91E-21);
Gstr{i,1} = 'IEPOXB'; Gstr{i,2} = 'OH'; 
fIEPOXB(i)=fIEPOXB(i)-1; fOH(i)=fOH(i)-1; fIEPOXOO(i)=fIEPOXOO(i)+1;

%% HC5 rxns
% %IS17. updated with the rxns below on 20220913.
% i=i+1;
% Rnames{i} = 'HC5 + OH = HC5OO ';
% k(:,i) =  1.42e-11.*exp(610./ T);
% Gstr{i,1} = 'HC5'; Gstr{i,2} = 'OH'; 
% fHC5(i)=fHC5(i)-1; fOH(i)=fOH(i)-1; fHC5OO(i)=fHC5OO(i)+1; 
i=i+1;
Rnames{i} = 'HC5 + OH = 0.66125*IEPOXOO + 0.5325*OH + 0.16125*HO2 + 0.1775*MGLY + 0.33875*CO + 0.1775*CO2 + 0.1613*C4HP';
k(:,i) = 4.9E-11*exp(390./T); 
Gstr{i,1} = 'HC5'; Gstr{i,2} = 'OH';
fHC5(i)=fHC5(i)-1;fOH(i)=fOH(i)-0.4675; fIEPOXOO(i)=fIEPOXOO(i)+0.66125; fHO2(i)=fHO2(i)+0.16125; fMGLY(i)=fMGLY(i)+0.1775; fCO(i)=fCO(i)+0.33875; fC4HP(i)=fC4HP(i)+0.1613;

%IS24. Unchanged from SAPRC07tic.
i=i+1;
Rnames{i} = 'HC5 + O3 = 0.50*MGLY + 0.35*GLY + 0.79*OH + 0.02*HCHO + 0.35*HOCCHO + 0.59*CO + 0.15*HACET + 0.13*RCOOH + 0.08*CO2 + 0.6*HO2 +  0.35*MECO3 - 0.13*XC  ';
k(:,i) =   3.94e-15.*exp(-1520./ T);
Gstr{i,1} = 'HC5'; Gstr{i,2} = 'O3'; 
fHC5(i)=fHC5(i)-1; fO3(i)=fO3(i)-1; fMGLY(i)=fMGLY(i)+0.5; fCO(i)=fCO(i)+0.59;fCO2(i)=fCO2(i)+0.08;
fGLY(i)=fGLY(i)+0.35; fHACET(i)=fHACET(i)+0.15; fOH(i)=fOH(i)+0.79; fRCOOH(i)=fRCOOH(i)+0.13; 
fHCHO(i)=fHCHO(i)+0.02; fHOCCHO(i)=fHOCCHO(i)+0.35; fHO2(i)=fHO2(i)+0.6;fMECO3(i)=fMECO3(i)+0.35; fXC(i)=fXC(i)-0.13;
%% ISOPHN (IHN) rxns
% %IS28 and IS30. updated with the rxns below.
% i=i+1;
% Rnames{i} = 'ISOPNB + OH = ISOPNOOB';
% k(:,i) =  2.4e-12.*exp(745./ T);
% Gstr{i,1} = 'ISOPNB'; Gstr{i,2} = 'OH'; 
% fISOPNB(i)=fISOPNB(i)-1; fOH(i)=fOH(i)-1; fISOPNOOB(i)=fISOPNOOB(i)+1;
% %IS30
% i=i+1;
% Rnames{i} =' ISOPNB + O3 = 0.12*MVKN + 0.32*MACRN + 0.34*OH + 0.08*HO2 + 0.26*CO + 0.07*CO2 + 0.16*FACD + 0.56*HCHO + 0.28*RNO3I + 0.04*HACET + 0.28*NO2 + 0.24*BACL - 0.57*XC ';
% k(:,i) =  3.7e-19;
% Gstr{i,1} = 'ISOPNB'; Gstr{i,2} = 'O3'; 
% fISOPNB(i)=fISOPNB(i)-1; fO3(i)=fO3(i)-1; fHCHO(i)=fHCHO(i)+0.56;fOH(i)=fOH(i)+0.34;fCO(i)=fCO(i)+0.26;
% fHO2(i)=fHO2(i)+0.08;fMACRN(i)=fMACRN(i)+0.32;fMVKN(i)=fMVKN(i)+0.12;fNO2(i)=fNO2(i)+0.28;fFACD(i)=fFACD(i)+0.16;
% fCO2(i)=fCO2(i)+0.07;fRNO3I(i)=fRNO3I(i)+0.28;fHACET(i)=fHACET(i)+0.04;fXC(i)=fXC(i)-0.57;fBACL(i)=fBACL(i)+0.24;
i=i+1;
Rnames{i} = 'ISOP1OH2N = NO2 + MVK + HO2 + HCHO';
k(:,i) = JIC3ONO2; %J55 ;
Gstr{i,1} = 'ISOP1OH2N';
fISOP1OH2N(i)=fISOP1OH2N(i)-1; fNO2(i)=fNO2(i)+1; fMVK(i)=fMVK(i)+1; fHO2(i)=fHO2(i)+1; fHCHO(i)=fHCHO(i)+1; 
i=i+1;
Rnames{i} = 'ISOP1OH2N + OH = 0.85*ISOPNOO + 0.15*IEPOXB + 0.15*NO2';%two pathways combined. 0.85:0.15 based on rates.
k(:,i) = 8.4E-12*exp(390./T);
Gstr{i,1} = 'ISOP1OH2N'; Gstr{i,2} = 'OH';
fISOP1OH2N(i)=fISOP1OH2N(i)-1; fOH(i)=fOH(i)-1; fISOPNOO(i)=fISOPNOO(i)+0.85;fIEPOXB(i)=fIEPOXB(i)+0.15; fNO2(i)=fNO2(i)+0.15;
i=i+1;
Rnames{i} = 'ISOP3N4OH = NO2 + MACR + HO2 + HCHO';
k(:,i) = JIC3ONO2; %J54 ;
Gstr{i,1} = 'ISOP3N4OH';
fISOP3N4OH(i)=fISOP3N4OH(i)-1; fNO2(i)=fNO2(i)+1; fMACR(i)=fMACR(i)+1; fHO2(i)=fHO2(i)+1; fHCHO(i)=fHCHO(i)+1;
i=i+1;
Rnames{i} = 'ISOP3N4OH + OH = 0.87*ISOPNOO + 0.13*IEPOXB + 0.13*NO2';
k(:,i) = 1.17E-11*exp(390./T);
Gstr{i,1} = 'ISOP3N4OH'; Gstr{i,2} = 'OH';
fISOP3N4OH(i)=fISOP3N4OH(i)-1; fOH(i)=fOH(i)-1; fISOPNOO(i)=fISOPNOO(i)+0.87;fIEPOXB(i)=fIEPOXB(i)+0.13; fNO2(i)=fNO2(i)+0.13;
i=i+1;
Rnames{i} = 'ISOPHND = NO2 + 0.45*HO2 + 0.55*C4HP + 0.55*CO + 0.55*OH + 0.45*HC5';
k(:,i) = JIC3ONO2; %J53 ; 
Gstr{i,1} = 'ISOPHND'; 
fISOPHND(i)=fISOPHND(i)-1; fNO2(i)=fNO2(i)+1; fHO2(i)=fHO2(i)+0.45; fC4HP(i)=fC4HP(i)+0.55; fCO(i)=fCO(i)+0.55; fOH(i)=fOH(i)+0.55; fHC5(i)=fHC5(i)+0.45; 
i=i+1;
Rnames{i} = 'ISOPHND + OH = 0.9*ISOPNOO + 0.057*IEPOXD + 0.057*NO2 + 0.044*OH + 0.044*CO + 0.044*C4PN + 0.029*HO2';
k(:,i) = 2.87E-11*exp(390./T);
Gstr{i,1} = 'ISOPHND'; Gstr{i,2} = 'OH'; 
fISOPHND(i)=fISOPHND(i)-1; fOH(i)=fOH(i)-0.956; 
fISOPNOO(i)=fISOPNOO(i)+0.9;fIEPOXD(i)=fIEPOXD(i)+0.057; fNO2(i)=fNO2(i)+0.057; fHO2(i)=fHO2(i)+0.029;fCO(i)=fCO(i)+0.044;fC4PN(i)=fC4PN(i)+0.044;

% %IS25. ISOPND removed. species replaced by ISOPHN (ISOP1OH2N, ISOP3N4OH, and
% ISOPHND). But its reactions with O3 and NO3 are merged with the ISOPHN.
% i=i+1;
% Rnames{i} = 'ISOPND + OH = ISOPNOOD ';
% k(:,i) =   1.2e-11.*exp(652./ T);
% Gstr{i,1} = 'ISOPND'; Gstr{i,2} = 'OH'; 
% fISOPND(i)=fISOPND(i)-1; fOH(i)=fOH(i)-1; fISOPNOOD(i)=fISOPNOOD(i)+1; 

%IS27. Ozonolysis of ISOPHN are based on ISOPND rxns in
%the original SAPRC07tic. Rate constants updated based on the Caltech
%mechanism.
i=i+1;
Rnames{i} = 'ISOP1OH2N + O3 = 0.36*ETHLN + 0.29*PROPNN + 0.70*MGLY + 0.12*RCOOH + 0.39*HO2 + 0.038*HCHO + 0.029*CO + 0.73*OH + 0.017*CO2 + 0.36*NO2 + 0.16*HACET + 0.34*HOCCHO - 0.26*XC ';
k(:,i) =  2.8e-19;
Gstr{i,1} = 'ISOP1OH2N'; Gstr{i,2} = 'O3'; 
fISOP1OH2N(i)=fISOP1OH2N(i)-1; fO3(i)=fO3(i)-1; fETHLN(i)=fETHLN(i)+0.36;fPROPNN(i)=fPROPNN(i)+0.29;fMGLY(i)=fMGLY(i)+0.7;
fRCOOH(i)=fRCOOH(i)+0.12;fHO2(i)=fHO2(i)+0.39;fHCHO(i)=fHCHO(i)+0.038;fCO(i)=fCO(i)+0.029;fOH(i)=fOH(i)+0.73;
fNO2(i)=fNO2(i)+0.36;fHACET(i)=fHACET(i)+0.16;fHOCCHO(i)=fHOCCHO(i)+0.34;fXC(i)=fXC(i)-0.26;
i=i+1;
Rnames{i} = 'ISOP3N4OH + O3 = 0.36*ETHLN + 0.29*PROPNN + 0.70*MGLY + 0.12*RCOOH + 0.39*HO2 + 0.038*HCHO + 0.029*CO + 0.73*OH + 0.017*CO2 + 0.36*NO2 + 0.16*HACET + 0.34*HOCCHO - 0.26*XC ';
k(:,i) =  5e-19;
Gstr{i,1} = 'ISOP3N4OH'; Gstr{i,2} = 'O3'; 
fISOP3N4OH(i)=fISOP3N4OH(i)-1; fO3(i)=fO3(i)-1; fETHLN(i)=fETHLN(i)+0.36;fPROPNN(i)=fPROPNN(i)+0.29;fMGLY(i)=fMGLY(i)+0.7;
fRCOOH(i)=fRCOOH(i)+0.12;fHO2(i)=fHO2(i)+0.39;fHCHO(i)=fHCHO(i)+0.038;fCO(i)=fCO(i)+0.029;fOH(i)=fOH(i)+0.73;
fNO2(i)=fNO2(i)+0.36;fHACET(i)=fHACET(i)+0.16;fHOCCHO(i)=fHOCCHO(i)+0.34;fXC(i)=fXC(i)-0.26;

% new rxn for ISOPHN + NO3. rates from the Caltech mechanism.
i=i+1;
Rnames{i} = 'ISOP1OH2N + NO3 = 0.5*IHDNOO + 0.5*IDNE';
k(:,i) =  3e-14;
Gstr{i,1} = 'ISOP1OH2N'; Gstr{i,2} = 'NO3'; 
fISOP1OH2N(i)=fISOP1OH2N(i)-1; fNO3(i)=fNO3(i)-1; fIHDNOO(i)=fIHDNOO(i)+0.5;fIDNE(i)=fIDNE(i)+0.5;
i=i+1;
Rnames{i} = 'ISOP3N4OH + NO3 = 0.5*IHDNOO + 0.5*IDNE';
k(:,i) =  3e-14;
Gstr{i,1} = 'ISOP3N4OH'; Gstr{i,2} = 'NO3'; 
fISOP3N4OH(i)=fISOP3N4OH(i)-1; fNO3(i)=fNO3(i)-1; fIHDNOO(i)=fIHDNOO(i)+0.5;fIDNE(i)=fIDNE(i)+0.5;
i=i+1;
Rnames{i} = 'ISOPHND + NO3 = 0.1*NIT1 + 0.1*HO2 + 0.9*IHDNOO';
k(:,i) =  1.1e-13;
Gstr{i,1} = 'ISOPHND'; Gstr{i,2} = 'NO3'; 
fISOPHND(i)=fISOPHND(i)-1; fNO3(i)=fNO3(i)-1; fNIT1(i)=fNIT1(i)+0.1; fHO2(i)=fHO2(i)+0.1; fIHDNOO(i)=fIHDNOO(i)+0.9;
%% NIT1 (ICN) rxns
% %IS31. updated with the rxn below.
% i=i+1;
% Rnames{i} =' NIT1 + NO3 = 0.6*NIT1NO3OOA + 0.6*HNO3 + 0.4*NIT1NO3OOB  ';
% k(:,i) =  3.15e-13.*exp(-448./ T);
% Gstr{i,1} = 'NIT1'; Gstr{i,2} = 'NO3'; 
% fNIT1(i)=fNIT1(i)-1; fNO3(i)=fNO3(i)-1; fNIT1NO3OOA(i)=fNIT1NO3OOA(i)+0.6;fHNO3(i)=fHNO3(i)+0.6;fNIT1NO3OOB(i)=fNIT1NO3OOB(i)+0.4;

% The +NO3 mechanism is speculative based on +OH. The actual NO3-addition
% RO2 should be ICDNOO. but is lumped into IHDNOO.
i=i+1;
Rnames{i} ='NIT1 + NO3 = 0.35*NIT1NO3OOA + 0.35*HNO3 + 0.65*IHDNOO';
k(:,i) =  3.15e-13.*exp(-448./ T);
Gstr{i,1} = 'NIT1'; Gstr{i,2} = 'NO3'; 
fNIT1(i)=fNIT1(i)-1; fNO3(i)=fNO3(i)-1; fNIT1NO3OOA(i)=fNIT1NO3OOA(i)+0.35; fHNO3(i)=fHNO3(i)+0.35; fIHDNOO(i)=fIHDNOO(i)+0.65;

%IS46. Unchanged from SAPRC07tic.
i=i+1;
Rnames{i} =' NIT1 + O3 = 0.3*PROPNN + 0.45*CO + 0.15*OH + 0.45*HO2 + 0.15*CO2 + 0.7*GLY + 0.7*OH + 0.7*NO2 + 0.7*MGLY';
k(:,i) = 4.15e-15.*exp(-1520./ T);
Gstr{i,1} = 'NIT1'; Gstr{i,2} = 'O3'; 
fNIT1(i)=fNIT1(i)-1; fO3(i)=fO3(i)-1;fPROPNN(i)=fPROPNN(i)+0.3;fGLY(i)=fGLY(i)+0.7;
fCO(i)=fCO(i)+0.45;fCO2(i)=fCO2(i)+0.15;fOH(i)=fOH(i)+0.15;fHO2(i)=fHO2(i)+0.45;
fOH(i)=fOH(i)+0.7;fNO2(i)=fNO2(i)+0.7;fMGLY(i)=fMGLY(i)+0.7;

% %IS47. updated with the rxn below.
% i=i+1;
% Rnames{i} =' NIT1 + OH = 0.345*NIT1NO3OOA + 0.655*NIT1OHOO';
% k(:,i) = 7.48e-12.*exp(410./ T);
% Gstr{i,1} = 'NIT1'; Gstr{i,2} = 'OH'; 
% fNIT1(i)=fNIT1(i)-1; fOH(i)=fOH(i)-1;fNIT1NO3OOA(i)=fNIT1NO3OOA(i)+0.345;fNIT1OHOO(i)=fNIT1OHOO(i)+0.655;

i=i+1;
Rnames{i} ='NIT1 + OH = 0.443*NIT1NO3OOA + 0.249*NIT1OHOO + 0.268*C4PN + 0.040*NO2 + 0.040*ICHE + 0.268*CO + 0.268*HO2';
% updated on 20230330 by HZ, based on the FZJ mechanism.
k(:,i) = 7.48e-12.*exp(410./ T);
Gstr{i,1} = 'NIT1'; Gstr{i,2} = 'OH'; 
fNIT1(i)=fNIT1(i)-1; fOH(i)=fOH(i)-1; fNIT1NO3OOA(i)=fNIT1NO3OOA(i)+0.443; fNIT1OHOO(i)=fNIT1OHOO(i)+0.249;
fC4PN(i)=fC4PN(i)+0.268; fNO2(i)=fNO2(i)+0.040; fICHE(i)=fICHE(i)+0.040; fCO(i)=fCO(i)+0.268; fHO2(i)=fHO2(i)+0.268;

%% NISOPOOH (IPN) rxns
%IS99. updated with the rxns below on 20230330 by HZ, based on the Caltech and FZJ mechanisms.
% i=i+1;
% Rnames{i} =' NISOPOOH + OH = RNO3I + OH';
% k(:,i) = 5e-11;
% Gstr{i,1} = 'NISOPOOH'; Gstr{i,2} = 'OH'; 
% fNISOPOOH(i)=fNISOPOOH(i)-1;fOH(i)=fOH(i)-1;fRNO3I(i)=fRNO3I(i)+1;fOH(i)=fOH(i)+1;
% %IS139. updated with the rxns below.
% i=i+1;
% Rnames{i} =' NISOPOOH + OH = 0.3*NISOPO2 + 0.7*OH + 0.7*NIT1';
% k(:,i) = 0.38e-11.*exp(200./ T);
% Gstr{i,1} = 'NISOPOOH'; Gstr{i,2} = 'OH'; 
% fNISOPOOH(i)=fNISOPOOH(i)-1;fOH(i)=fOH(i)-1;fNISOPO2(i)=fNISOPO2(i)+0.3;fOH(i)=fOH(i)+0.7;fNIT1(i)=fNIT1(i)+0.7;
i=i+1;
Rnames{i} = 'NISOPOOH  = 0.624*NO2 + 0.519*HCHO + 0.050*MACR + 0.469*MVK + 0.724*OH + 0.231*HO2 + 0.087*ISOP1OHOO + 0.016*ISOP4OHOO + 0.317*NIEPOXOO + 0.060*NIT1';
k(:,i) =  JIC3ONO2 + JCOOH;
Gstr{i,1} = 'NISOPOOH'; 
fNISOPOOH(i)=fNISOPOOH(i)-1; fNO2(i)=fNO2(i)+0.624; fHCHO(i)=fHCHO(i)+0.519; fMACR(i)=fMACR(i)+0.050; fMVK(i)=fMVK(i)+0.469; fOH(i)=fOH(i)+0.724; fHO2(i)=fHO2(i)+0.231;
fNIT1(i)=fNIT1(i)+0.060; fISOP1OHOO(i)=fISOP1OHOO(i)+0.087; fISOP4OHOO(i)=fISOP4OHOO(i)+0.016; fNIEPOXOO(i)=fNIEPOXOO(i)+0.087;

i=i+1;
Rnames{i} = 'NISOPOOH + OH = 0.127*NISOPO2 + 0.047*NIT1 + 0.359*OH + 0.483*IHPNOO + 0.031*IHPE + 0.031*NO2 + 0.312*IHNE';
k(:,i) =  2.37e-11.*exp(390./ T); % rate constant based on the Caltech mechanism.
Gstr{i,1} = 'NISOPOOH'; Gstr{i,2} = 'OH'; 
fNISOPOOH(i)=fNISOPOOH(i)-1; fOH(i)=fOH(i)-1; fNISOPO2(i)=fNISOPO2(i)+0.127; fNIT1(i)=fNIT1(i)+0.047; fOH(i)=fOH(i)+0.359;
fIHPNOO(i)=fIHPNOO(i)+0.483; fIHPE(i)=fIHPE(i)+0.031; fNO2(i)=fNO2(i)+0.031; fIHNE(i)=fIHNE(i)+0.312;

i=i+1;
Rnames{i} = 'NISOPOOH + O3 = 0.5*PROPNN + 0.64*HCHO + 1.063*OH + 0.25*C4PN + 0.11*CO + 0.063*HO2 + 0.14*HO2H + 0.25*GLY + 0.25*HPETHNL + 0.25*MGLY + 0.25*NO2';
k(:,i) =  1.36e-17; % rate constant based on the Caltech mechanism (lumping for all isomers). The branching ratios were not updated with FZJ.
Gstr{i,1} = 'NISOPOOH'; Gstr{i,2} = 'O3'; 
fNISOPOOH(i)=fNISOPOOH(i)-1; fO3(i)=fO3(i)-1; fPROPNN(i)=fPROPNN(i)+0.5;fHCHO(i)=fHCHO(i)+0.64;fOH(i)=fOH(i)+1.063;
fC4PN(i)=fC4PN(i)+0.25;fCO(i)=fCO(i)+0.11;fHO2(i)=fHO2(i)+0.063;fHO2H(i)=fHO2H(i)+0.14;fGLY(i)=fGLY(i)+0.25;fHPETHNL(i)=fHPETHNL(i)+0.25;
fMGLY(i)=fMGLY(i)+0.25;fNO2(i)=fNO2(i)+0.25;

% The +NO3 mechanism is speculative based on +OH. The actual NO3-addition
% RO2 should be IPDNOO. but is lumped into IHDNOO.
i=i+1;
Rnames{i} = 'NISOPOOH + NO3 = 0.08*NISOPO2 + 0.09*NIT1 + 0.162*IDNE + 0.252*OH + 0.668*IHDNOO';
k(:,i) =  6.8e-14; % rate constant based on the Caltech mechanism (lumping for all isomers).
Gstr{i,1} = 'NISOPOOH'; Gstr{i,2} = 'NO3'; 
fNISOPOOH(i)=fNISOPOOH(i)-1; fNO3(i)=fNO3(i)-1; fNISOPO2(i)=fNISOPO2(i)+0.08; fNIT1(i)=fNIT1(i)+0.09;fIDNE(i)=fIDNE(i)+0.162; fOH(i)=fOH(i)+0.252; fIHDNOO(i)=fIHDNOO(i)+0.668;
%% IDN rxns
i=i+1;
Rnames{i} = 'IDN + OH = 0.85*IHDNOO + 0.15*IHNE + 0.15*NO2';
k(:,i) =  2.37e-11.*exp(390./ T); % rate constant based on NISOPOOH + OH.
Gstr{i,1} = 'IDN'; Gstr{i,2} = 'OH'; 
fIDN(i)=fIDN(i)-1; fOH(i)=fOH(i)-1; fIHDNOO(i)=fIHDNOO(i)+0.85; fIHNE(i)=fIHNE(i)+0.15; fNO2(i)=fNO2(i)+0.15;

i=i+1;
Rnames{i} = 'IDN = 0.1*MVK + 0.01*MACR + 0.11*HCHO + 1.11*NO2 + 0.455*NIT1 + 0.455*NIEPOXOO + 0.455*HO2';
k(:,i) = 2*JIC3ONO2; %J53 + J55 ; % SUN*5.0E-5;
Gstr{i,1} = 'IDN'; 
fIDN(i)=fIDN(i)-1; fMVK(i)=fMVK(i)+0.1; fMACR(i)=fMACR(i)+0.01; fHCHO(i)=fHCHO(i)+0.11; fNO2(i)=fNO2(i)+1.11; fNIT1(i)=fNIT1(i)+0.455; fNIEPOXOO(i)=fNIEPOXOO(i)+0.455; fHO2(i)=fHO2(i)+0.455; 

%% Other C5-CHO species rxns
% --------------IDH-----------------
i=i+1;
Rnames{i} = 'IDH + OH = 0.3*MVK + 0.3*HCHO + 0.7*HC5 + HO2';
k(:,i) = 6.20E-11;
Gstr{i,1} = 'IDH'; Gstr{i,2} = 'OH';
fIDH(i)=fIDH(i)-1;fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+1;fMVK(i)=fMVK(i)+0.3;fHCHO(i)=fHCHO(i)+0.3;fHC5(i)=fHC5(i)+0.7;
% --------------IDC-----------------
i=i+1;
Rnames{i} = 'IDC + OH = 2*CO + HO2 + MGLY';
k(:,i) = 3.0E-12*exp(650./T) ;
Gstr{i,1} = 'IDC'; Gstr{i,2} = 'OH'; 
fIDC(i)=fIDC(i)-1; fOH(i)=fOH(i)-1; fCO(i)=fCO(i)+2; fHO2(i)=fHO2(i)+1; fMGLY(i)=fMGLY(i)+1; 
% --------------ICPDH-----------------
i=i+1;
Rnames{i} = 'ICPDH = 0.825*OH + 1.175*HO2 + 0.429*CO + 0.254*C4DH + 0.175*C4HP + 0.065*HCHO + 0.065*C4HC + 0.285*HACET + 0.285*GLY + 0.057*HOCCHO + 0.057*MGLY';
k(:,i) = JCOOH+JMEK_06; %J41 ;
Gstr{i,1} = 'ICPDH'; 
fICPDH(i)=fICPDH(i)-1; fOH(i)=fOH(i)+0.825; fHO2(i)=fHO2(i)+1.175; fCO(i)=fCO(i)+0.429; fC4DH(i)=fC4DH(i)+0.254; fC4HP(i)=fC4HP(i)+0.175; fHCHO(i)=fHCHO(i)+0.065; fC4HC(i)=fC4HC(i)+0.065; fHACET(i)=fHACET(i)+0.285; fGLY(i)=fGLY(i)+0.285; fHOCCHO(i)=fHOCCHO(i)+0.057; fMGLY(i)=fMGLY(i)+0.057;  
i=i+1;
Rnames{i} = 'ICPDH + OH = CO + 0.5*HO2 + 0.5*OH + 0.5*C4HP + 0.5*C4DH';
k(:,i) = 1.0E-11 ;
Gstr{i,1} = 'ICPDH'; Gstr{i,2} = 'OH'; 
fICPDH(i)=fICPDH(i)-1; fOH(i)=fOH(i)-0.5; fCO(i)=fCO(i)+1; fHO2(i)=fHO2(i)+0.5; fC4HP(i)=fC4HP(i)+0.5; fC4DH(i)=fC4DH(i)+0.5;
% --------------IDHPE-----------------
i=i+1;
Rnames{i} = 'IDHPE = OH + HO2 + 0.429*MGLY + 0.429*HOCCHO + 0.571*GLY + 0.571*HACET';
k(:,i) = JCOOH; %J41 ;
Gstr{i,1} = 'IDHPE'; 
fIDHPE(i)=fIDHPE(i)-1; fOH(i)=fOH(i)+1; fHO2(i)=fHO2(i)+1; fMGLY(i)=fMGLY(i)+0.429; fHOCCHO(i)=fHOCCHO(i)+0.429; fGLY(i)=fGLY(i)+0.571; fHACET(i)=fHACET(i)+0.571; 
i=i+1;
Rnames{i} = 'IDHPE + OH = OH + CO2 + C4HP';
k(:,i) = 3.0E-12 ;
Gstr{i,1} = 'IDHPE'; Gstr{i,2} = 'OH'; 
fIDHPE(i)=fIDHPE(i)-1; fC4HP(i)=fC4HP(i)+1;
% --------------ICHE-----------------
i=i+1;
Rnames{i} = 'ICHE + OH = OH + 1.5*CO + 0.5*HCHO + 0.5*MGLY + 0.5*HACET';
k(:,i) = 9.85E-12*exp(410./T) ;
Gstr{i,1} = 'ICHE'; Gstr{i,2} = 'OH'; 
fICHE(i)=fICHE(i)-1; fCO(i)=fCO(i)+1.5; fHCHO(i)=fHCHO(i)+0.5; fMGLY(i)=fMGLY(i)+0.5; fHACET(i)=fHACET(i)+0.5;
% --------------IDHDP-----------------
i=i+1;
Rnames{i} = 'IDHDP = 1.25*OH + 0.25*HOCCHO + 0.25*HACET + 0.75*ICPDH + 0.75*HO2';
k(:,i) = 2*JCOOH; %2*J41 ;
Gstr{i,1} = 'IDHDP';
fIDHDP(i)=fIDHDP(i)-1; fOH(i)=fOH(i)+1.25; fHOCCHO(i)=fHOCCHO(i)+0.25; fHACET(i)=fHACET(i)+0.25; fICPDH(i)=fICPDH(i)+0.75; fHO2(i)=fHO2(i)+0.75; 
i=i+1;
Rnames{i} = 'IDHDP + OH = OH + 0.333*ICPDH + 0.667*IDHPE';
k(:,i) = 3.0E-12;
Gstr{i,1} = 'IDHDP'; Gstr{i,2} = 'OH'; 
fIDHDP(i)=fIDHDP(i)-1; fICPDH(i)=fICPDH(i)+0.333; fIDHPE(i)=fIDHPE(i)+0.667; 
% --------------IDCHP-----------------
i=i+1;
Rnames{i} = 'IDCHP = 0.546*OH + 1.454*CO + 1.454*HO2 + 0.546*C4HC + 0.454*MGLY';
k(:,i) = 2*JMEK_06+JCOOH; %2*J22 + J41 ;
Gstr{i,1} = 'IDCHP'; 
fIDCHP(i)=fIDCHP(i)-1; fOH(i)=fOH(i)+0.546; fCO(i)=fCO(i)+1.454; fHO2(i)=fHO2(i)+1.454; fC4HC(i)=fC4HC(i)+0.546; fMGLY(i)=fMGLY(i)+0.454; 
i=i+1;
Rnames{i} = 'IDCHP + OH = 1.332*CO + 0.444*OH + 0.444*HO2 + 0.444*C4HC + 0.112*IEPOXOO + 0.444*MGLY';
k(:,i) = 2.25E-11 ;
Gstr{i,1} = 'IDCHP'; Gstr{i,2} = 'OH'; 
fIDCHP(i)=fIDCHP(i)-1; fOH(i)=fOH(i)-0.556; fCO(i)=fCO(i)+1.332; fHO2(i)=fHO2(i)+0.444; fC4HC(i)=fC4HC(i)+0.444; fIEPOXOO(i)=fIEPOXOO(i)+0.112; fMGLY(i)=fMGLY(i)+0.444;
%% Other C5-CHON species rxns
% --------------IDHCN-----------------
i=i+1;
Rnames{i} = 'IDHCN = 0.5*HO2 + NO2 + 0.375*CO + 0.375*C4DH + 0.5*MECO3 + 0.53*HACET + 0.094*HOCCHO + 0.094*MGLY + 0.031*GLY';
k(:,i) = JMEK_06 + JCOOH + JIC3ONO2; %J22 + J41;
Gstr{i,1} = 'IDHCN'; 
fIDHCN(i)=fIDHCN(i)-1; fHO2(i)=fHO2(i)+0.5;fNO2(i)=fNO2(i)+1;
fCO(i)=fCO(i)+0.375;fC4DH(i)=fC4DH(i)+0.375;fMECO3(i)=fMECO3(i)+0.5;fHACET(i)=fHACET(i)+0.53; fHOCCHO(i)=fHOCCHO(i)+0.094; fMGLY(i)=fMGLY(i)+0.094; fGLY(i)=fGLY(i)+0.031;
i=i+1;
Rnames{i} = 'IDHCN + OH = CO + NO2 + C4DH';
k(:,i) = 1.0E-11 ;
Gstr{i,1} = 'IDHCN'; Gstr{i,2} = 'OH'; 
fIDHCN(i)=fIDHCN(i)-1; fOH(i)=fOH(i)-1; fCO(i)=fCO(i)+1; fNO2(i)=fNO2(i)+1; fC4DH(i)=fC4DH(i)+1;
% --------------IDHPN-----------------
i=i+1;
Rnames{i} = 'IDHPN = 0.65*OH + 0.7*HO2 + 0.35*HCHO + 0.25*MACRN + 0.325*HOCCHO + 0.625*HACET + 0.725*NO2 + 0.075*MECO3 + 0.025*MVKN + 0.25*HPETHNL + 0.075*C4HP + 0.025*HPAC';
k(:,i) = 2.0.*JCOOH + 2.0.*JIC3ONO2; %2(J41+J51);
Gstr{i,1} = 'IDHPN'; 
fIDHPN(i)=fIDHPN(i)-1; 
fOH(i)=fOH(i)+0.65; fHO2(i)=fHO2(i)+0.7; fHCHO(i)=fHCHO(i)+0.35; fMACRN(i)=fMACRN(i)+0.25; fHOCCHO(i)=fHOCCHO(i)+0.325; fHACET(i)=fHACET(i)+0.625; fNO2(i)=fNO2(i)+0.725; fMECO3(i)=fMECO3(i)+0.075; fMVKN(i)=fMVKN(i)+0.025; 
fHPETHNL(i)=fHPETHNL(i)+0.25; fC4HP(i)=fC4HP(i)+0.075; fHPAC(i)=fHPAC(i)+0.025; 
i=i+1;
Rnames{i} = 'IDHPN + OH = 0.33*OH + 0.67*HO2 + 0.33*IDHCN + 0.67*ICHNP';
k(:,i) = 3.0E-12 ;
Gstr{i,1} = 'IDHPN'; Gstr{i,2} = 'OH'; 
fIDHPN(i)=fIDHPN(i)-1; fOH(i)=fOH(i)-0.67; fHO2(i)=fHO2(i)+0.67; fIDHCN(i)=fIDHCN(i)+0.33; fICHNP(i)=fICHNP(i)+0.67; 
% --------------ICHNP-----------------
i=i+1;
Rnames{i} = 'ICHNP = 0.8*MGLY + 0.8*OH + NO2 + 0.8*HOCCHO + 0.2*C4HP + 0.2*CO + 0.2*HO2';
k(:,i) = JCOOH + JIC3ONO2 + JMEK_06; %J41 + J54;
Gstr{i,1} = 'ICHNP'; 
fICHNP(i)=fICHNP(i)-1; 
fMGLY(i)=fMGLY(i)+0.8; fHOCCHO(i)=fHOCCHO(i)+0.8; fOH(i)=fOH(i)+0.8; fNO2(i)=fNO2(i)+1; fC4HP(i)=fC4HP(i)+0.2; fCO(i)=fCO(i)+0.2;fHO2(i)=fHO2(i)+0.2;
i=i+1;
Rnames{i} = 'ICHNP + OH = CO + NO2 + C4HP';
k(:,i) = 1.0E-11 ;
Gstr{i,1} = 'ICHNP'; Gstr{i,2} = 'OH'; 
fICHNP(i)=fICHNP(i)-1; fOH(i)=fOH(i)-1; fCO(i)=fCO(i)+1; fNO2(i)=fNO2(i)+1; fC4HP(i)=fC4HP(i)+1;
% --------------ICHDN-----------------
i=i+1;
Rnames{i} = 'ICHDN = 1.713*NO2 + 0.525*CO + 0.1*C4DH + 0.138*MVKN + 0.138*MACRN + 0.338*HO2 + 0.013*GLY + 0.013*RNO3I + 0.025*MGLY + 0.463*MECO3 + 0.563*HACET + 0.188*HCHO';
k(:,i) = 2.*JIC3ONO2 + JMEK_06 + JCOOH;
Gstr{i,1} = 'ICHDN'; 
fICHDN(i)=fICHDN(i)-1; 
fNO2(i)=fNO2(i)+1.713; fCO(i)=fCO(i)+525; fC4DH(i)=fC4DH(i)+0.1; fMVKN(i)=fMVKN(i)+0.138; fMACRN(i)=fMACRN(i)+0.138; fHO2(i)=fHO2(i)+0.338; fGLY(i)=fGLY(i)+0.013; fRNO3I(i)=fRNO3I(i)+0.013; fMGLY(i)=fMGLY(i)+0.025; fMECO3(i)=fMECO3(i)+0.463; fHACET(i)=fHACET(i)+0.563; fHCHO(i)=fHCHO(i)+0.188;
i=i+1;
Rnames{i} = 'ICHDN + OH = CO + NO2 + 0.5*MACRN + 0.5*MVKN';
k(:,i) = 1.0E-11*0.4 ;
Gstr{i,1} = 'ICHDN'; Gstr{i,2} = 'OH'; 
fICHDN(i)=fICHDN(i)-1; fOH(i)=fOH(i)-1; fCO(i)=fCO(i)+1; fNO2(i)=fNO2(i)+1; fMACRN(i)=fMACRN(i)+0.5; fMVKN(i)=fMVKN(i)+0.5; 
% --------------IDHDN-----------------
i=i+1;
Rnames{i} = 'IDHDN = 2*NO2 + HOCCHO + HACET';
k(:,i) = 2.*JIC3ONO2; %J53 + J55;
Gstr{i,1} = 'IDHDN'; 
fIDHDN(i)=fIDHDN(i)-1; fNO2(i)=fNO2(i)+2; fHOCCHO(i)=fHOCCHO(i)+1; fHACET(i)=fHACET(i)+1;
i=i+1;
Rnames{i} = 'IDHDN + OH = ICHDN';
k(:,i) = 2.0E-12 ;
Gstr{i,1} = 'IDHDN'; Gstr{i,2} = 'OH'; 
fIDHDN(i)=fIDHDN(i)-1; fOH(i)=fOH(i)-1; fICHDN(i)=fICHDN(i)+1;
% --------------ICNE-----------------
i=i+1;
Rnames{i} = 'ICNE + OH = OH + 2.000*CO + 0.350*PROPNN + 0.650*MGLY + 0.650*HO2 + 0.650*NO2';
k(:,i) = 9.85E-12*exp(410./T) ;
Gstr{i,1} = 'ICNE'; Gstr{i,2} = 'OH'; 
fICNE(i)=fICNE(i)-1; fCO(i)=fCO(i)+2; fPROPNN(i)=fPROPNN(i)+0.35; fMGLY(i)=fMGLY(i)+0.65; fHO2(i)=fHO2(i)+0.65; fNO2(i)=fNO2(i)+0.65; 
% --------------IHNDP-----------------
i=i+1;
Rnames{i} = 'IHNDP + OH = OH + ICHNP';
k(:,i) = 2.0E-12 ;
Gstr{i,1} = 'IHNDP'; Gstr{i,2} = 'OH'; 
fIHNDP(i)=fIHNDP(i)-1; fICHNP(i)=fICHNP(i)+1;
% explicit ISOPOOHOO isomers
% i=i+1;
% Rnames{i} = 'IHNDP = NO2 + ISOPOOHOO1';
% k(:,i) = JIC3ONO2; %J54
% Gstr{i,1} = 'IHNDP'; 
% fIHNDP(i)=fIHNDP(i)-1; fNO2(i)=fNO2(i)+1; fISOPOOHOO1(i)=fISOPOOHOO1(i)+1;

% lumped ISOPOOHOO
i=i+1;
Rnames{i} = 'IHNDP = NO2 + ISOPOOHOO';
k(:,i) = JIC3ONO2; %J54
Gstr{i,1} = 'IHNDP'; 
fIHNDP(i)=fIHNDP(i)-1; fNO2(i)=fNO2(i)+1; fISOPOOHOO(i)=fISOPOOHOO(i)+1; 
% --------------IHNE-----------------
i=i+1;
Rnames{i} = 'IHNE + OH = 0.16*ICHNP + 0.04*PROPNN + 0.04*CO + 0.04*HO2 + 0.04*HCHO + 0.04*OH + 0.2*RO2C + 0.2*ISOPNOO + 0.6*ICNE';
k(:,i) = 7.77E-12*exp(-400./T); 
Gstr{i,1} = 'IHNE'; Gstr{i,2} = 'OH'; 
fIHNE(i)=fIHNE(i)-1; fOH(i)=fOH(i)-0.96; fICHNP(i)=fICHNP(i)+0.16; fPROPNN(i)=fPROPNN(i)+0.04; fCO(i)=fCO(i)+0.04; fHCHO(i)=fHCHO(i)+0.04; fHO2(i)=fHO2(i)+0.04; fRO2C(i)=fRO2C(i)+0.2; fISOPNOO(i)=fISOPNOO(i)+0.2; fICNE(i)=fICNE(i)+0.6; 
% --------------IHPDN-----------------
i=i+1;
Rnames{i} = 'IHPDN + OH = 0.875*IHDNOO + 0.125*OH + 0.125*ICHDN';
k(:,i) = 1.0E-12 ;
Gstr{i,1} = 'IHPDN'; Gstr{i,2} = 'OH'; 
fIHPDN(i)=fIHPDN(i)-1; fOH(i)=fOH(i)-0.875; fIHDNOO(i)=fIHDNOO(i)+1; fICHDN(i)=fICHDN(i)+1; 

i=i+1;
Rnames{i} = 'IHPDN = 0.884*OH + 0.533*HO2 + 0.49*NO2 + 0.678*PROPNN + 0.28*HOCCHO + 0.135*ICHDN + 0.375*ETHLN + 0.094*ISOPNOO + 0.094*MVKN + 0.094*HCHO + 0.023*HPETHNL';
k(:,i) = JCOOH + 2.0*JIC3ONO2; %J41 + 2.0*J51; branching ratio based on photolysis
Gstr{i,1} = 'IHPDN'; 
fIHPDN(i)=fIHPDN(i)-1; fOH(i)=fOH(i)+0.884; fHO2(i)=fHO2(i)+0.533; fNO2(i)=fNO2(i)+0.49; fPROPNN(i)=fPROPNN(i)+0.678; fHOCCHO(i)=fHOCCHO(i)+0.28; fICHDN(i)=fICHDN(i)+0.135; fETHLN(i)=fETHLN(i)+0.375; 
fISOPNOO(i)=fISOPNOO(i)+0.094; fMVKN(i)=fMVKN(i)+0.094; fHCHO(i)=fHCHO(i)+0.094; fHPETHNL(i)=fHPETHNL(i)+0.023; 
% --------------ITHN-----------------
% based on INAOH, INB1OH, INCOH, and INDOH in MCM.
i=i+1;
Rnames{i} = 'ITHN + OH = IDHCN + HO2';
k(:,i) = 7.4E-12 ;
Gstr{i,1} = 'ITHN'; Gstr{i,2} = 'OH'; 
fITHN(i)=fITHN(i)-1; fOH(i)=fOH(i)-1; fIDHCN(i)=fIDHCN(i)+1; fHO2(i)=fHO2(i)+1;
% --------------IHNPE-----------------
i=i+1;
Rnames{i} = 'IHNPE + OH = 0.5*HO2 + CO + OH + 0.5*PROPNN + 0.5*CO2 + 0.5*C4PN';
k(:,i) = 3.0E-12*exp(20./T);
Gstr{i,1} = 'IHNPE'; Gstr{i,2} = 'OH'; 
fIHNPE(i)=fIHNPE(i)-1; fHO2(i)=fHO2(i)+0.5; fCO(i)=fCO(i)+1; fPROPNN(i)=fPROPNN(i)+0.5; fC4PN(i)=fC4PN(i)+0.5; 

i=i+1;
Rnames{i} = 'IHNPE = OH + PROPNN + HO2 + GLY';
k(:,i) = JCOOH + JIC3ONO2;
Gstr{i,1} = 'IHNPE'; 
fIHNPE(i)=fIHNPE(i)-1; fOH(i)=fOH(i)+1; fPROPNN(i)=fPROPNN(i)+1; fHO2(i)=fHO2(i)+1; fGLY(i)=fGLY(i)+1; 
%% ISOPNN rxns
% %IS93. Removed
% i=i+1;
% Rnames{i} =' ISOPNN + OH = PROPNN + NO2';
% k(:,i) = 4e-13;
% Gstr{i,1} = 'ISOPNN'; Gstr{i,2} = 'OH'; 
% fISOPNN(i)=fISOPNN(i)-1;fOH(i)=fOH(i)-1;fNO2(i)=fNO2(i)+1;
% fPROPNN(i)=fPROPNN(i)+1;
% 
% %IS98. Removed
% i=i+1;
% Rnames{i} =' ISOPNN = MECO3 + HCHO + 2*NO2';
% k(:,i) = 1.0.*JIC3ONO2;
% Gstr{i,1} = 'ISOPNN'; 
% fISOPNN(i)=fISOPNN(i)-1;fHCHO(i)=fHCHO(i)+1;fNO2(i)=fNO2(i)+2;
% fMECO3(i)=fMECO3(i)+1;

%% DHMOB rxns
%IS86. Removed.
% i=i+1;
% Rnames{i} =' DHMOB + OH = 1.5*CO + 0.5*HO2 + 0.5*HACET + 0.5*PRD2 - XC';
% k(:,i) = 1e-11;
% Gstr{i,1} = 'DHMOB';  Gstr{i,2} = 'OH'; 
% fDHMOB(i)=fDHMOB(i)-1;fOH(i)=fOH(i)-1;fHACET(i)=fHACET(i)+0.5;fPRD2(i)=fPRD2(i)+0.5;
% fCO(i)=fCO(i)+1.5;fHO2(i)=fHO2(i)+0.5;fXC(i)=fXC(i)-1;

%% RNO3I rxns
%IS94. Unchanged.
i=i+1;
Rnames{i} =' RNO3I + OH = NO2 + HO2 + PRD2';
k(:,i) = 8e-12;
Gstr{i,1} = 'RNO3I'; Gstr{i,2} = 'OH'; 
fRNO3I(i)=fRNO3I(i)-1;fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+1;fNO2(i)=fNO2(i)+1;
fPRD2(i)=fPRD2(i)+1;
%% MVK products oxidation
% --------------MVKN-----------------

% %IS84 and IS106. updated with the rxns below.
% i=i+1;
% Rnames{i} =' MVKN + OH = 0.65*FACD + 0.65*MGLY + 0.35*HCHO + 0.35*PYRUACD + NO3';
% k(:,i) = 3.5e-12.*exp(140./ T);
% Gstr{i,1} = 'MVKN'; Gstr{i,2} = 'OH'; 
% fMVKN(i)=fMVKN(i)-1;fOH(i)=fOH(i)-1;fHCHO(i)=fHCHO(i)+0.35;fFACD(i)=fFACD(i)+0.65;
% fMGLY(i)=fMGLY(i)+0.65;fPYRUACD(i)=fPYRUACD(i)+0.35;fNO3(i)=fNO3(i)+1;
% %IS106
% i=i+1;
% Rnames{i} =' MVKN +hv = MECO3 + NO2 + HOCCHO';
% k(:,i) = JNOA;
% Gstr{i,1} = 'MVKN'; 
% fMVKN(i)=fMVKN(i)-1;fHOCCHO(i)=fHOCCHO(i)+1;fNO2(i)=fNO2(i)+1;
% fMECO3(i)=fMECO3(i)+1;
i=i+1;
Rnames{i} = 'MVKN = 1.23*MECO3 + 0.77*HOCCHO + NO2 + 0.23*HO2';
k(:,i) = JIC3ONO2 + 0.23.*JMEK_06; %J56 ;
Gstr{i,1} = 'MVKN'; 
fMVKN(i)=fMVKN(i)-1; fMECO3(i)=fMECO3(i)+1.23; fHOCCHO(i)=fHOCCHO(i)+0.77; fNO2(i)=fNO2(i)+1; fHO2(i)=fHO2(i)+0.23; 
i=i+1;
Rnames{i} = 'MVKN + OH = 0.585*FACD + 0.9*NO3 + 0.585*MGLY + 0.315*HCHO + 0.315*PYRUACD + 0.1*C4HC + 0.1*NO2';
k(:,i) = 1.16E-12*exp(380./T) + 5.13E-13;
Gstr{i,1} = 'MVKN'; Gstr{i,2} = 'OH'; 
fMVKN(i)=fMVKN(i)-1; fOH(i)=fOH(i)-1; 
fFACD(i)=fFACD(i)+0.585; fNO3(i)=fNO3(i)+0.9; fMGLY(i)=fMGLY(i)+0.585; fHCHO(i)=fHCHO(i)+0.315; fPYRUACD(i)=fPYRUACD(i)+0.315; fC4HC(i)=fC4HC(i)+0.1;fNO2(i)=fNO2(i)+0.1;

%% MACR products oxidation
% --------------IMPAA-----------------

% %IA92. updated with the rxns below.
% i=i+1;
% Rnames{i} = 'IMPAA + OH = 0.83*IMACO3 + 0.17*IHMML ';
% k(:,i) = 1.66e-11;
% Gstr{i,1} = 'IMPAA'; Gstr{i,2} = 'OH'; 
% fIMPAA(i)=fIMPAA(i)-1;fOH(i)=fOH(i)-1;fIMACO3(i)=fIMACO3(i)+0.83;fIHMML(i)=fIHMML(i)+0.17;
i=i+1;
Rnames{i} = 'IMPAA = OH + 1.65*CO2 + 0.65*MEO2 + HCHO + 0.35*MECO3';
k(:,i) = JMEK_06 + JCOOH; %J22+J41 ;
Gstr{i,1} = 'IMPAA'; 
fIMPAA(i)=fIMPAA(i)-1; fOH(i)=fOH(i)+1; fMEO2(i)=fMEO2(i)+0.65; fHCHO(i)=fHCHO(i)+1; fMECO3(i)=fMECO3(i)+0.35;
i=i+1;
Rnames{i} = 'IMPAA + OH = 0.73*IHMML + 0.27*IMAE + OH  ';
k(:,i) = 1.9e-11.*exp(390./T);
Gstr{i,1} = 'IMPAA'; Gstr{i,2} = 'OH';
fIMPAA(i)=fIMPAA(i)-1;fIHMML(i)=fIHMML(i)+0.73;fIMAE(i)=fIMAE(i)+0.27;
% --------------IMAPAN-----------------

% %IA53 and IA108. updated with the rxns below.
% i=i+1;
% Rnames{i} =' IMAPAN + hv  = 0.6*IMACO3 + 0.6*NO2 + 0.4*CO2 + 0.4*HCHO + 0.4*MECO3 + 0.4*NO3 ';
% k(:,i) = 1.0.*JPAN;
% Gstr{i,1} = 'IMAPAN';  
% fIMAPAN(i)=fIMAPAN(i)-1;fNO2(i)=fNO2(i)+0.6;fIMACO3(i)=fIMACO3(i)+0.6;fCO2(i)=fCO2(i)+0.4;
% fHCHO(i)=fHCHO(i)+0.4;fMECO3(i)=fMECO3(i)+0.4;fNO3(i)=fNO3(i)+0.4;
% %IA108 new added
% i=i+1;
% Rnames{i} = 'IMAPAN + OH = 0.03*HACET + 0.03*CO + 0.81*NO3 + 0.21*IMAE + 0.57*IHMML + 0.19*PAN + 0.19*HCHO + 0.19*HO2 ';
% k(:,i) = 3e-11;
% Gstr{i,1} = 'IMAPAN'; Gstr{i,2} = 'OH'; 
% fIMAPAN(i)=fIMAPAN(i)-1;fOH(i)=fOH(i)-1;fHACET(i)=fHACET(i)+0.03;fCO(i)=fCO(i)+0.03;fNO3(i)=fNO3(i)+0.81;
% fIMAE(i)=fIMAE(i)+0.21;
% fIHMML(i)=fIHMML(i)+0.57;fPAN(i)=fPAN(i)+0.19;fHCHO(i)=fHCHO(i)+0.19;fHO2(i)=fHO2(i)+0.19;
i=i+1;
Rnames{i} = ' IMAPAN + OH = 0.72*IHMML + 0.03*IMAE + NO3 + 0.25*HACET + 0.25*CO';
k(:,i) = 3.0e-11;
Gstr{i,1} = 'IMAPAN'; Gstr{i,2} = 'OH';
fIMAPAN(i)=fIMAPAN(i)-1; fOH(i)=fOH(i)-1; fIHMML(i)=fIHMML(i)+0.72; fIMAE(i)=fIMAE(i)+0.03; fNO3(i)=fNO3(i)+1; fHACET(i)=fHACET(i)+0.25; fCO(i)=fCO(i)+0.25;

% --------------IMAE-----------------

% %IA90. updated with the rxns below.
% i=i+1;
% Rnames{i} = 'IMAE + OH =  ';
% k(:,i) = 1e-12;
% Gstr{i,1} = 'IMAE'; Gstr{i,2} = 'OH'; 
% fIMAE(i)=fIMAE(i)-1;fOH(i)=fOH(i)-1;
i=i+1;
Rnames{i} = ' IMAE + OH = FACD + RO2C';
k(:,i) = 1.0e-12;
Gstr{i,1} = 'IMAE'; Gstr{i,2} = 'OH';
fIMAE(i)=fIMAE(i)-1;fOH(i)=fOH(i)-1;fFACD(i)=fFACD(i)+1;fRO2C(i)=fRO2C(i)+1;

% --------------IHMML-----------------

% %IA91. updated with the rxns below.
% i=i+1;
% Rnames{i} = 'IHMML + OH =   ';
% k(:,i) = 4.4e-12;
% Gstr{i,1} = 'IHMML'; Gstr{i,2} = 'OH'; 
% fIHMML(i)=fIHMML(i)-1;fOH(i)=fOH(i)-1;
i=i+1;
Rnames{i} = 'IHMML + OH = 0.7*MGLY + 0.7*OH + 0.3*MECO3 + 0.3*FACD';
k(:,i) = 4.33E-12 ;
Gstr{i,1} = 'IHMML'; Gstr{i,2} = 'OH'; 
fIHMML(i)=fIHMML(i)-1; fOH(i)=fOH(i)-0.3; fMGLY(i)=fMGLY(i)+0.7; fMECO3(i)=fMECO3(i)+0.3; fFACD(i)=fFACD(i)+0.3;

% The following two rxns are added by HZ on 20220921 to simplify
% 2-methylglyceric acid et al. formation from HMML. 
% i=i+1;
% Rnames{i} = 'IHMML + H2O = MGA';
% k(:,i) = 1E-16 .*H2O;
% Gstr{i,1} = 'IHMML';
% fIHMML(i)=fIHMML(i)-1; fMGA(i)=fMGA(i)+1; 
% 
% i=i+1;
% Rnames{i} = 'IHMML + HNO3 = NMGA';
% k(:,i) = 1E-11;
% Gstr{i,1} = 'IHMML'; Gstr{i,2} = 'HNO3'; 
% fIHMML(i)=fIHMML(i)-1; fHNO3(i)=fHNO3(i)-1;fNMGA(i)=fNMGA(i)+1; 

% --------------MACRN-----------------

%IS85 and IS110. updated with the rxns below.
% i=i+1;
% Rnames{i} =' MACRN + OH = 0.08*CCOOH + 0.08*HCHO + 0.08*NO3 + 0.07*FACD + 0.07*NO3 + 0.07*MGLY + 0.85*HACET + 0.85*NO2 + 0.93*CO2';
% k(:,i) = 1.28e-11.*exp(405./ T);
% Gstr{i,1} = 'MACRN'; Gstr{i,2} = 'OH'; 
% fMACRN(i)=fMACRN(i)-1;fOH(i)=fOH(i)-1;fHCHO(i)=fHCHO(i)+0.08;fCCOOH(i)=fCCOOH(i)+0.08;
% fMGLY(i)=fMGLY(i)+0.07;fNO3(i)=fNO3(i)+0.08;fNO3(i)=fNO3(i)+0.07;fFACD(i)=fFACD(i)+0.07;
% fHACET(i)=fHACET(i)+0.85;fNO2(i)=fNO2(i)+0.85;fCO2(i)=fCO2(i)+0.93;
% %IS110
% i=i+1;
% Rnames{i} =' MACRN +hv  = HACET + NO2 + CO + HO2';
% k(:,i) = 1.0.*JC2CHO;
% Gstr{i,1} = 'MACRN'; 
% fMACRN(i)=fMACRN(i)-1;fHACET(i)=fHACET(i)+1;fNO2(i)=fNO2(i)+1;
% fCO(i)=fCO(i)+1;fHO2(i)=fHO2(i)+1;
i=i+1;
Rnames{i} = 'MACRN = HACET + CO + HO2 + NO2';
k(:,i) = JIC3ONO2;
Gstr{i,1} = 'MACRN';
fMACRN(i)=fMACRN(i)-1; fHACET(i)=fHACET(i)+1; fCO(i)=fCO(i)+1; fHO2(i)=fHO2(i)+1; fNO2(i)=fNO2(i)+1; 
i=i+1;
Rnames{i} = 'MACRN + OH = 0.08*CCOOH + 0.08*HCHO + 0.07*FACD + 0.07*MGLY + 0.85*HACET + 0.85*NO2 + 0.15*NO3';
k(:,i) = 1.39E-11*exp(380/T);
Gstr{i,1} = 'MACRN'; Gstr{i,2} = 'OH'; 
fMACRN(i)=fMACRN(i)-1; fOH(i)=fOH(i)-1; fCCOOH(i)=fCCOOH(i)+0.08;fFACD(i)=fFACD(i)+0.07;fHCHO(i)=fHCHO(i)+0.08;
fNO2(i)=fNO2(i)+0.85;fMGLY(i)=fMGLY(i)+0.07;fHACET(i)=fHACET(i)+0.85;fNO3(i)=fNO3(i)+0.15;

%% Lumped C4 products
% --------------C4HP-----------------
i=i+1;
Rnames{i} = 'C4HP = OH + 0.6*HO2 + 0.45*CO + 0.45*HACET + 0.15*HCHO + 0.15*MGLY + 0.4*MECO3 + 0.4*HOCCHO';
k(:,i) = JMEK_06 + JCOOH; %J22+J41 ;
Gstr{i,1} = 'C4HP';  
fC4HP(i)=fC4HP(i)-1; fOH(i)=fOH(i)+1; fHO2(i)=fHO2(i)+0.6; fCO(i)=fCO(i)+0.45; fHACET(i)=fHACET(i)+0.45; fHCHO(i)=fHCHO(i)+0.15; fMGLY(i)=fMGLY(i)+0.15; fMECO3(i)=fMECO3(i)+0.4; fHOCCHO(i)=fHOCCHO(i)+0.4;
i=i+1;
Rnames{i} = 'C4HP + OH = OH + 0.45*CO + 0.45*HACET + 0.05*CO2 + 0.05*HPAC + 0.5*C4HC';
k(:,i) = 5.77E-11 ;
Gstr{i,1} = 'C4HP'; Gstr{i,2} = 'OH'; 
fC4HP(i)=fC4HP(i)-1; fCO(i)=fCO(i)+0.45; fHACET(i)=fHACET(i)+0.45; fHPAC(i)=fHPAC(i)+0.05; fC4HC(i)=fC4HC(i)+0.5;
% --------------C4ENOL-----------------
i=i+1;
Rnames{i} = 'C4ENOL = 0.95*CO + 0.9*PYRUACD + 1.9*OH + 0.1*MGLY + 0.05*HO2 + 0.05*MECO3 + 0.05*GLY';
k(:,i) = JMEK_06; %J35; double check rate
Gstr{i,1} = 'C4ENOL'; 
fC4ENOL(i)=fC4ENOL(i)-1; 
fMGLY(i)=fMGLY(i)+0.1; fHO2(i)=fHO2(i)+0.05; fCO(i)=fCO(i)+0.95; fMECO3(i)=fMECO3(i)+0.05; fGLY(i)=fGLY(i)+0.05; fOH(i)=fOH(i)+1.9; fPYRUACD(i)=fPYRUACD(i)+0.9;
i=i+1;
Rnames{i} = 'C4ENOL + OH = 0.192*OH + 0.808*HO2 + 0.9*CO + 0.783*PYRUACD + 0.117*CO2 + 0.117*MECO3 + 0.025*C4HC + 0.075*MGLY + 0.075*FACD';
k(:,i) = 3.78E-12*exp(983./T); 
Gstr{i,1} = 'C4ENOL'; Gstr{i,2} = 'OH'; 
fC4ENOL(i)=fC4ENOL(i)-1; fOH(i)=fOH(i)-0.808; 
fHO2(i)=fHO2(i)+0.808; fC4HC(i)=fC4HC(i)+0.025; fMGLY(i)=fMGLY(i)+0.075; fFACD(i)=fFACD(i)+0.075;
fCO(i)=fCO(i)+0.9; fPYRUACD(i)=fPYRUACD(i)+0.783; fMECO3(i)=fMECO3(i)+0.117;
% --------------C4DH-----------------
i=i+1;
Rnames{i} = 'C4DH + OH = 0.6*C4HC + 0.31*OH + HO2 + 0.4*CO + 0.1*HACET + 0.3*MECO3';
k(:,i) = 1.25E-11*exp(70./T);
Gstr{i,1} = 'C4DH'; Gstr{i,2} = 'OH';
fC4DH(i)=fC4DH(i)-1; fOH(i)=fOH(i)-0.69;
fC4HC(i)=fC4HC(i)+0.6; fHO2(i)=fHO2(i)+1;fCO(i)=fCO(i)+0.4; fHACET(i)=fHACET(i)+0.1; fMECO3(i)=fMECO3(i)+0.3;
% --------------C4HC-----------------
i=i+1;
Rnames{i} = 'C4HC = 0.825*CO + 1.175*HO2 + 0.65*HCHO + 0.825*MECO3 + 0.175*GLY + 0.175*MGLY';
k(:,i) = 2.*JACET_06; %J35 ; 
Gstr{i,1} = 'C4HC'; 
fC4HC(i)=fC4HC(i)-1; fCO(i)=fCO(i)+0.825; fHO2(i)=fHO2(i)+1.175; fHCHO(i)=fHCHO(i)+0.65; fMECO3(i)=fMECO3(i)+0.825;fGLY(i)=fGLY(i)+0.175;fMGLY(i)=fMGLY(i)+0.175; 
i=i+1;
Rnames{i} = 'C4HC + OH = 0.5*CO + 0.35*HO2 + 0.85*OH + 0.35*MECO3 + 0.65*MGLY + 0.85*CO2';
k(:,i) = 2.3E-12*exp(470./T); 
Gstr{i,1} = 'C4HC'; Gstr{i,2} = 'OH'; 
fC4HC(i)=fC4HC(i)-1; fOH(i)=fOH(i)-0.15; fCO(i)=fCO(i)+0.5; fHO2(i)=fHO2(i)+0.35; fMECO3(i)=fMECO3(i)+0.35; fMGLY(i)=fMGLY(i)+0.65;
% --------------C4PN-----------------
i=i+1;
Rnames{i} = 'C4PN = OH + 0.5*HO2 + 0.5*MECO3 + 0.5*ETHLN + 0.5*PROPNN + 0.5CO';
k(:,i) = JIC3ONO2 + JMEK_06; %J53 + J22 ;
Gstr{i,1} = 'C4PN'; 
fC4PN(i)=fC4PN(i)-1; fMECO3(i)=fMECO3(i)+0.5; fOH(i)=fOH(i)+1; fHO2(i)=fHO2(i)+0.5; fETHLN(i)=fETHLN(i)+0.5; fPROPNN(i)=fPROPNN(i)+0.5; fCO(i)=fCO(i)+0.5; 
i=i+1;
Rnames{i} = 'C4PN + OH = OH + 0.2*CO + 0.2*PROPNN + 1.6*MECO3 + 0.8*NO2';
k(:,i) = 3.32E-11 ;
Gstr{i,1} = 'C4PN'; Gstr{i,2} = 'OH'; 
fC4PN(i)=fC4PN(i)-1; fCO(i)=fCO(i)+0.2; fPROPNN(i)=fPROPNN(i)+0.2;fNO2(i)=fNO2(i)+0.8;fMECO3(i)=fMECO3(i)+1.6;

%% HOCCHO rxns
%IS79. Unchanged.
i=i+1;
Rnames{i} =' HOCCHO + OH = 0.75*HO2 + 0.25*OH + 0.13*GLY + 0.52*CO + 0.35*CO2 + 0.16*FACD + 0.71*HCHO';
k(:,i) = 0.8e-11;
Gstr{i,1} = 'HOCCHO'; Gstr{i,2} = 'OH'; 
fHOCCHO(i)=fHOCCHO(i)-1; fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+0.75;fOH(i)=fOH(i)+0.25;
fCO2(i)=fCO2(i)+0.35;fGLY(i)=fGLY(i)+0.13;fHCHO(i)=fHCHO(i)+0.71;fFACD(i)=fFACD(i)+0.16;
fCO(i)=fCO(i)+0.52;

%BP73. Unchanged.
i=i+1;
Rnames{i} = ' HOCCHO +hv = CO + 2*HO2 + HCHO ';
k(:,i) =  JHOCCHO;
Gstr{i,1} = 'HOCCHO'; 
fHOCCHO(i)=fHOCCHO(i)-1; fCO(i)=fCO(i)+1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+2; 

%BP74. Unchanged.
i=i+1;
Rnames{i} = ' HOCCHO + NO3 = HNO3 + MECO3 ';
k(:,i) =   1.40e-12.*exp(-1860./ T);
Gstr{i,1} = 'HOCCHO'; Gstr{i,2} = 'NO3';
fHOCCHO(i)=fHOCCHO(i)-1; fNO3(i)=fNO3(i)-1; fHNO3(i)=fHNO3(i)+1; fMECO3(i)=fMECO3(i)+1; 
%% HACET rxns
%IS80. Unchanged.
i=i+1;
Rnames{i} =' HACET + OH = 0.75*MGLY + 0.825*HO2 + 0.125*FACD + 0.1*OH + 0.125*MEO2 + 0.20*CO2 + 0.05*CO + 0.125*CCOOH';
k(:,i) = 2.15e-12.*exp(305./ T);
Gstr{i,1} = 'HACET'; Gstr{i,2} = 'OH'; 
fHACET(i)=fHACET(i)-1; fOH(i)=fOH(i)-1;fHO2(i)=fHO2(i)+0.825;fOH(i)=fOH(i)+0.1;
fCO2(i)=fCO2(i)+0.2;fMGLY(i)=fMGLY(i)+0.75;fMEO2(i)=fMEO2(i)+0.125;fFACD(i)=fFACD(i)+0.125;
fCO(i)=fCO(i)+0.05;fCCOOH(i)=fCCOOH(i)+0.125;

%IS81. Unchanged.
i=i+1;
Rnames{i} =' HACET + hv = HO2 + MECO3 + HCHO';
k(:,i) = 1.75e-1.*JMEK_06;
Gstr{i,1} = 'HACET'; 
fHACET(i)=fHACET(i)-1; fHO2(i)=fHO2(i)+1;fMECO3(i)=fMECO3(i)+1;
fHCHO(i)=fHCHO(i)+1;

%% GLY rxns
%BP30. Unchanged.
i=i+1;
Rnames{i} = ' GLY + hv = 2*CO + 2*HO2 ';
k(:,i) =  1.0.*JGLY_07R;
Gstr{i,1} = 'GLY'; 
fGLY(i)=fGLY(i)-1; fCO(i)=fCO(i)+2; fHO2(i)=fHO2(i)+2; 

%BP31. Unchanged.
i=i+1;
Rnames{i} = ' GLY + hv = HCHO + CO ';
k(:,i) =  1.0.*JGLY_07M;
Gstr{i,1} = 'GLY'; 
fGLY(i)=fGLY(i)-1; fHCHO(i)=fHCHO(i)+1; fCO(i)=fCO(i)+1; 

%BP32. Unchanged.
i=i+1;
Rnames{i} = ' GLY + OH = 0.70*HO2 + 1.40*CO + 0.3*HCOCO3 ';
k(:,i) =  3.1e-12.*exp(342.2./ T);
Gstr{i,1} = 'GLY'; Gstr{i,2} = 'OH'; 
fGLY(i)=fGLY(i)-1; fOH(i)=fOH(i)-1; fHO2(i)=fHO2(i)+0.7; fCO(i)=fCO(i)+1.4; fHCOCO3(i)=fHCOCO3(i)+0.3; 

%BP33. Unchanged.
i=i+1;
Rnames{i} = ' GLY + NO3 = HNO3 + 0.70*HO2 + 1.40*CO + 0.3*HCOCO3';
k(:,i) =  2.80e-12.*exp(-2390./ T);
Gstr{i,1} = 'GLY'; Gstr{i,2} = 'NO3'; 
fGLY(i)=fGLY(i)-1; fNO3(i)=fNO3(i)-1; fHNO3(i)=fHNO3(i)+1; fHO2(i)=fHO2(i)+0.7; fCO(i)=fCO(i)+1.4;fHCOCO3(i)=fHCOCO3(i)+0.3; 

%% MGLY rxns
%BP34. Unchanged.
i=i+1;
Rnames{i} = ' MGLY + hv = HO2 + CO + MECO3 ';
k(:,i) =  1.0.*JMGLY_06;
Gstr{i,1} = 'MGLY'; 
fMGLY(i)=fMGLY(i)-1; fHO2(i)=fHO2(i)+1; fCO(i)=fCO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%BP35. Unchanged.
i=i+1;
Rnames{i} = ' MGLY + OH = CO + MECO3 ';
k(:,i) =  1.50e-11;
Gstr{i,1} = 'MGLY'; Gstr{i,2} = 'OH'; 
fMGLY(i)=fMGLY(i)-1; fOH(i)=fOH(i)-1; fCO(i)=fCO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%BP36. Unchanged.
i=i+1;
Rnames{i} = ' MGLY + NO3 = HNO3 + CO + MECO3 ';
k(:,i) =  1.40e-12.*exp(-1895./ T);
Gstr{i,1} = 'MGLY'; Gstr{i,2} = 'NO3'; 
fMGLY(i)=fMGLY(i)-1; fNO3(i)=fNO3(i)-1; fHNO3(i)=fHNO3(i)+1; fCO(i)=fCO(i)+1; fMECO3(i)=fMECO3(i)+1; 

%% PYRUACD rxns
% IS87. Unchanged.
i=i+1;
Rnames{i} =' PYRUACD + hv = CCHO + CO2';
k(:,i) = 1.0.*JMGLY_06;
Gstr{i,1} = 'PYRUACD'; 
fPYRUACD(i)=fPYRUACD(i)-1;fCCHO(i)=fCCHO(i)+1;fCO2(i)=fCO2(i)+1;

% additional pyruvic acid rxns
i=i+1;
Rnames{i} = 'PYRUACD + OH = MECO3 + CO2';
k(:,i) = 8.0E-13 ;
Gstr{i,1} = 'PYRUACD'; Gstr{i,2} = 'OH'; 
fPYRUACD(i)=fPYRUACD(i)-1; fOH(i)=fOH(i)-1; fMECO3(i)=fMECO3(i)+1;
i=i+1;
Rnames{i} = 'PYRUACD = MECO3 + CO2 + HO2';
k(:,i) = JMGLY_06; %J34 ;
Gstr{i,1} = 'PYRUACD'; 
fPYRUACD(i)=fPYRUACD(i)-1; fMECO3(i)=fMECO3(i)+1; fHO2(i)=fHO2(i)+1;

%% HPETHNL rxns
i=i+1;
Rnames{i} = 'HPETHNL + OH = 0.85*GLY + 0.15*CO + 0.15*HCHO + OH ';
k(:,i) = 3.42E-11 ;
Gstr{i,1} = 'HPETHNL'; Gstr{i,2} = 'OH'; 
fHPETHNL(i)=fHPETHNL(i)-1; fGLY(i)=fGLY(i)+0.85; fCO(i)=fCO(i)+0.15; fHCHO(i)=fHCHO(i)+0.15; 
i=i+1;
Rnames{i} = 'HPETHNL = OH + CO + HO2 + HCHO';
k(:,i) = JMEK_06 + JCOOH; %J22+J41 ;
Gstr{i,1} = 'HPETHNL'; 
fHPETHNL(i)=fHPETHNL(i)-1; fOH(i)=fOH(i)+1; fCO(i)=fCO(i)+1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; 
%% HPAC rxns
i=i+1;
Rnames{i} = 'HPAC = MECO3 + HCHO + OH';
k(:,i) = JMEK_06 + JCOOH; %J22+J41 ;
Gstr{i,1} = 'HPAC'; 
fHPAC(i)=fHPAC(i)-1; fMECO3(i)=fMECO3(i)+1; fHCHO(i)=fHCHO(i)+1; fOH(i)=fOH(i)+1; 
i=i+1;
Rnames{i} = 'HPAC + OH = MGLY + OH';
k(:,i) = 8.39E-12 ;
Gstr{i,1} = 'HPAC'; Gstr{i,2} = 'OH'; 
fHPAC(i)=fHPAC(i)-1; fMGLY(i)=fMGLY(i)+1;
%% ETHLN rxns
%IS82. Unchanged.
i=i+1;
Rnames{i} =' ETHLN + OH = HCHO + CO2 + NO2';
k(:,i) = 2.94e-12.*exp(365./ T);
Gstr{i,1} = 'ETHLN';  Gstr{i,2} = 'OH'; 
fETHLN(i)=fETHLN(i)-1;fOH(i)=fOH(i)-1;fCO2(i)=fCO2(i)+1;fNO2(i)=fNO2(i)+1;
fHCHO(i)=fHCHO(i)+1;

%IS111. Unchanged.
i=i+1;
Rnames{i} =' ETHLN + hv  = NO2 + HCHO + HO2 + CO';
k(:,i) = JNOA;
Gstr{i,1} = 'ETHLN';  
fETHLN(i)=fETHLN(i)-1;fHO2(i)=fHO2(i)+1;fCO(i)=fCO(i)+1;fNO2(i)=fNO2(i)+1;
fHCHO(i)=fHCHO(i)+1;

%% PROPNN rxns
% IS83. Unchanged.
i=i+1;
Rnames{i} =' PROPNN + OH = MGLY + NO2';
k(:,i) = 4e-13;
Gstr{i,1} = 'PROPNN'; Gstr{i,2} = 'OH'; 
fPROPNN(i)=fPROPNN(i)-1;fOH(i)=fOH(i)-1;fNO2(i)=fNO2(i)+1;
fMGLY(i)=fMGLY(i)+1;

%IS97. Unchanged.
i=i+1;
Rnames{i} =' PROPNN + hv = MECO3 + HCHO + NO2';
k(:,i) = JNOA;
Gstr{i,1} = 'PROPNN'; 
fPROPNN(i)=fPROPNN(i)-1;fHCHO(i)=fHCHO(i)+1;fNO2(i)=fNO2(i)+1;
fMECO3(i)=fMECO3(i)+1;

%% operator rxns. All unchanged
%IC01
i=i+1;
Rnames{i} = 'xCO + IMACO3 = IMACO3 + CO ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xCO'; Gstr{i,2} = 'IMACO3'; 
fxCO(i)=fxCO(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fCO(i)=fCO(i)+1;

%IC02
i=i+1;
Rnames{i} = 'xTBUO + IMACO3 = IMACO3 + TBUO ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xTBUO'; Gstr{i,2} = 'IMACO3'; 
fxTBUO(i)=fxTBUO(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fTBUO(i)=fTBUO(i)+1;

%IC03
i=i+1;
Rnames{i} = 'xMACO3 + IMACO3 = IMACO3 + MACO3 ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xMACO3'; Gstr{i,2} = 'IMACO3'; 
fxMACO3(i)=fxMACO3(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fMACO3(i)=fMACO3(i)+1;

%IC04
i=i+1;
Rnames{i} = 'xRCO3 + IMACO3 = IMACO3 + RCO3 ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xRCO3'; Gstr{i,2} = 'IMACO3'; 
fxRCO3(i)=fxRCO3(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fRCO3(i)=fRCO3(i)+1;

%IC05
i=i+1;
Rnames{i} = 'xMECO3 + IMACO3 = IMACO3 + MECO3 ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xMECO3'; Gstr{i,2} = 'IMACO3'; 
fxMECO3(i)=fxMECO3(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fMECO3(i)=fMECO3(i)+1;

%IC06
i=i+1;
Rnames{i} = 'xMEO2 + IMACO3 = IMACO3 + MEO2';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xMEO2'; Gstr{i,2} = 'IMACO3'; 
fxMEO2(i)=fxMEO2(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fMEO2(i)=fMEO2(i)+1;

%IC07
i=i+1;
Rnames{i} = 'xNO2 + IMACO3 = IMACO3 + NO2';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xNO2'; Gstr{i,2} = 'IMACO3'; 
fxNO2(i)=fxNO2(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fNO2(i)=fNO2(i)+1;

%IC08
i=i+1;
Rnames{i} = ' xOH + IMACO3 = IMACO3 + OH';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xOH'; Gstr{i,2} = 'IMACO3'; 
fxOH(i)=fxOH(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fOH(i)=fOH(i)+1;

%IC09
i=i+1;
Rnames{i} = ' xHO2 + IMACO3 = IMACO3 + HO2';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xHO2'; Gstr{i,2} = 'IMACO3'; 
fxHO2(i)=fxHO2(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fHO2(i)=fHO2(i)+1;

%IC10
i=i+1;
Rnames{i} = 'xACROLEIN + IMACO3 = IMACO3 + ACROLEIN';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xACROLEIN'; Gstr{i,2} = 'IMACO3'; 
fxACROLEIN(i)=fxACROLEIN(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fACROLEIN(i)=fACROLEIN(i)+1;

%IC11
i=i+1;
Rnames{i} = 'xHOCCHO + IMACO3 = IMACO3 + HOCCHO';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xHOCCHO'; Gstr{i,2} = 'IMACO3'; 
fxHOCCHO(i)=fxHOCCHO(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fHOCCHO(i)=fHOCCHO(i)+1;

%IC12
i=i+1;
Rnames{i} = 'zRNO3 + IMACO3 = IMACO3 + PRD2 + HO2';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'zRNO3'; Gstr{i,2} = 'IMACO3'; 
fzRNO3(i)=fzRNO3(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fPRD2(i)=fPRD2(i)+1;fHO2(i)=fHO2(i)+1;

%IC13
i=i+1;
Rnames{i} = 'yRAOOH + IMACO3 = IMACO3';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'yRAOOH'; Gstr{i,2} = 'IMACO3'; 
fyRAOOH(i)=fyRAOOH(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;

%IC14
i=i+1;
Rnames{i} = 'yR6OOH + IMACO3 = IMACO3';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'yR6OOH'; Gstr{i,2} = 'IMACO3'; 
fyR6OOH(i)=fyR6OOH(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;

%IC15
i=i+1;
Rnames{i} = 'yROOH + IMACO3 = IMACO3';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'yROOH'; Gstr{i,2} = 'IMACO3'; 
fyROOH(i)=fyROOH(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;

%IC16
i=i+1;
Rnames{i} = 'xRNO3 + IMACO3 = IMACO3 + RNO3';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xRNO3'; Gstr{i,2} = 'IMACO3'; 
fxRNO3(i)=fxRNO3(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fRNO3(i)=fRNO3(i)+1;

%IC17
i=i+1;
Rnames{i} = 'xIPRD + IMACO3 = IMACO3 + IPRD ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xIPRD'; Gstr{i,2} = 'IMACO3'; 
fxIPRD(i)=fxIPRD(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fIPRD(i)=fIPRD(i)+1;

%IC18
i=i+1;
Rnames{i} = 'xMVK + IMACO3 = IMACO3 + MVK  ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xMVK'; Gstr{i,2} = 'IMACO3'; 
fxMVK(i)=fxMVK(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fMVK(i)=fMVK(i)+1;

%IC19
i=i+1;
Rnames{i} = 'xMACR + IMACO3 = IMACO3 + MACR ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xMACR'; Gstr{i,2} = 'IMACO3'; 
fxMACR(i)=fxMACR(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fMACR(i)=fMACR(i)+1;

%IC20
i=i+1;
Rnames{i} = 'xAFG3 + IMACO3 = IMACO3 + AFG3 ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xAFG3'; Gstr{i,2} = 'IMACO3'; 
fxAFG3(i)=fxAFG3(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fAFG3(i)=fAFG3(i)+1;

%IC21
i=i+1;
Rnames{i} = 'xAFG2 + IMACO3 = IMACO3 + AFG2 ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xAFG2'; Gstr{i,2} = 'IMACO3'; 
fxAFG2(i)=fxAFG2(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fAFG2(i)=fAFG2(i)+1;

%IC22
i=i+1;
Rnames{i} = 'xAFG1 + IMACO3 = IMACO3 + AFG1 ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xAFG1'; Gstr{i,2} = 'IMACO3'; 
fxAFG1(i)=fxAFG1(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fAFG1(i)=fAFG1(i)+1;

%IC23
i=i+1;
Rnames{i} = 'xBALD + IMACO3 = IMACO3 + BALD ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xBALD'; Gstr{i,2} = 'IMACO3'; 
fxBALD(i)=fxBALD(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fBALD(i)=fBALD(i)+1;

%IC24
i=i+1;
Rnames{i} = 'xBACL + IMACO3 = IMACO3 + BACL ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xBACL'; Gstr{i,2} = 'IMACO3'; 
fxBACL(i)=fxBACL(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fBACL(i)=fBACL(i)+1;

%IC25
i=i+1;
Rnames{i} = 'xMGLY + IMACO3 = IMACO3 + MGLY';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xMGLY'; Gstr{i,2} = 'IMACO3'; 
fxMGLY(i)=fxMGLY(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fMGLY(i)=fMGLY(i)+1;

%IC26
i=i+1;
Rnames{i} = 'xGLY + IMACO3 = IMACO3 + GLY';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xGLY'; Gstr{i,2} = 'IMACO3'; 
fxGLY(i)=fxGLY(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fGLY(i)=fGLY(i)+1;

%IC27
i=i+1;
Rnames{i} = 'xPROD2 + IMACO3 = IMACO3 + PRD2';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xPROD2'; Gstr{i,2} = 'IMACO3'; 
fxPROD2(i)=fxPROD2(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fPRD2(i)=fPRD2(i)+1;

%IC28
i=i+1;
Rnames{i} = 'xMEK + IMACO3 = IMACO3 + MEK';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xMEK'; Gstr{i,2} = 'IMACO3'; 
fxMEK(i)=fxMEK(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fMEK(i)=fMEK(i)+1;

%IC29
i=i+1;
Rnames{i} = 'xACET + IMACO3 = IMACO3 + ACET ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xACET'; Gstr{i,2} = 'IMACO3'; 
fxACET(i)=fxACET(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fACET(i)=fACET(i)+1;

%IC30
i=i+1;
Rnames{i} = 'xRCHO + IMACO3 = IMACO3 + RCHO';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xRCHO'; Gstr{i,2} = 'IMACO3'; 
fxRCHO(i)=fxRCHO(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fRCHO(i)=fRCHO(i)+1;

%IC31
i=i+1;
Rnames{i} = 'xCCHO + IMACO3 = IMACO3 + CCHO ';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xCCHO'; Gstr{i,2} = 'IMACO3'; 
fxCCHO(i)=fxCCHO(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fCCHO(i)=fCCHO(i)+1;

%IC32
i=i+1;
Rnames{i} = 'xHCHO + IMACO3 = IMACO3 + HCHO';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xHCHO'; Gstr{i,2} = 'IMACO3'; 
fxHCHO(i)=fxHCHO(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fHCHO(i)=fHCHO(i)+1;

%IC33
i=i+1;
Rnames{i} = 'xCL + IMACO3 = IMACO3 + CL';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xCL'; Gstr{i,2} = 'IMACO3'; 
fxCL(i)=fxCL(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fCL(i)=fCL(i)+1;

%IC34
i=i+1;
Rnames{i} = 'xCLACET + IMACO3 = IMACO3 + CLACET';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xCLACET'; Gstr{i,2} = 'IMACO3'; 
fxCLACET(i)=fxCLACET(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fCLACET(i)=fCLACET(i)+1;

%IC35
i=i+1;
Rnames{i} = 'xCLCCHO + IMACO3 = IMACO3 + CLCCHO';
k(:,i) = 4.40e-13.*exp(1070./ T);
Gstr{i,1} = 'xCLCCHO'; Gstr{i,2} = 'IMACO3'; 
fxCLCCHO(i)=fxCLCCHO(i)-1;fIMACO3(i)=fIMACO3(i)-1;fIMACO3(i)=fIMACO3(i)+1;fCLCCHO(i)=fCLCCHO(i)+1;

%END OF REACTION LIST