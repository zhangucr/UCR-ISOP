
SpeciesToAdd = {...
'CH3ONO';};
AddSpecies

%%
i=i+1;
Rnames{i} = ' CH3ONO + hv = HCHO + NO + HO2';
k(:,i) =  1.9e-4;
Gstr{i,1} = 'CH3ONO'; 
fCH3ONO(i)=fCH3ONO(i)-1; fHCHO(i)=fHCHO(i)+1; fNO(i)=fNO(i)+1; fHO2(i)=fHO2(i)+1;

i=i+1;
Rnames{i} = ' CH3ONO + OH = H2O + HCHO + NO';
k(:,i) =  0.5*3e-13;
Gstr{i,1} = 'CH3ONO'; Gstr{i,2} = 'OH';
fCH3ONO(i)=fCH3ONO(i)-1; fOH(i)=fOH(i)-1; fHCHO(i)=fHCHO(i)+1; fNO(i)=fNO(i)+1;

i=i+1;
Rnames{i} = ' CH3ONO + OH = HCHO + HO2 + HONO';
k(:,i) =  0.5*3e-13;
Gstr{i,1} = 'CH3ONO'; Gstr{i,2} = 'OH';
fCH3ONO(i)=fCH3ONO(i)-1; fOH(i)=fOH(i)-1; fHCHO(i)=fHCHO(i)+1; fHO2(i)=fHO2(i)+1; fHONO(i)=fHONO(i)+1;

% i=i+1;
% Rnames{i} = ' CH3O + O2 = HCHO + HO2 ';
% k(:,i) =  1.0.*JNO2_06;
% Gstr{i,1} = 'CH3O'; 
% fCH3O(i)=fCH3O(i)-1; fHO2(i)=fHO2(i)+1; fCH2O(i)=fCH2O(i)+1;

% CH3ONO + hν → CH3O + NO
% CH3O + O2 → CH2O + HO2
% HO2 + NO → OH + NO2.
