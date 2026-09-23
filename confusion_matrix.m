clear all
close all
clc

load sim_data.mat

XA_all = [];
YA_all = [];

XB_all = [];
YB_all = [];

X_all = [];
Y_all = [];

for k=1:4
    zA = s(k).zero_cross_timesA(s(k).zero_cross_timesA > 2);    
    cA = ismember(s(k).t, zA);    
    idxA = find(cA);
    YCSFCA = s(k).CSFCA(idxA, :);    % wyniki klasyfikacji
    
    
    yTRUEA = zeros(size(s(k).CSFCA));
    yTRUEA(:, 1) = 1;
    pOC = zA(zA >= 4 & zA <= 5 | zA >= 15 & zA <= 16 | zA >= 26 & zA <= 27); % czasy OC
    pG = zA(zA >= 6 & zA <= 7 | zA >= 17 & zA <= 18 | zA >= 28 & zA <= 29); % czasy G
    pOFF = zA(zA >= 8 & zA <= 9 | zA >= 19 & zA <= 20 | zA >= 30 & zA <= 31); % czasy OFF
    pSAT = zA(zA >= 10 & zA <= 11 | zA >= 21 & zA <= 22 | zA >= 32 & zA <= 33); % czasy OC
    
    idxTRUE_OC = find(ismember(s(k).t, pOC));
    idxTRUE_G = find(ismember(s(k).t, pG));
    idxTRUE_OFF = find(ismember(s(k).t, pOFF));
    idxTRUE_SAT = find(ismember(s(k).t, pSAT));
    
    yTRUEA(idxTRUE_OC, 1) = 0; yTRUEA(idxTRUE_OC, 2) = 1;
    yTRUEA(idxTRUE_G, 1) = 0; yTRUEA(idxTRUE_G, 3) = 1;
    yTRUEA(idxTRUE_OFF, 1) = 0; yTRUEA(idxTRUE_OFF, 4) = 1;
    yTRUEA(idxTRUE_SAT, 1) = 0; yTRUEA(idxTRUE_SAT, 5) = 1;
    yTRUEA = yTRUEA(idxA, :);  % wyniki spodziewane
    
    YCSFCA = arr2cat(YCSFCA');
    yTRUEA = arr2cat(yTRUEA');

    zB = s(k).zero_cross_timesB(s(k).zero_cross_timesB > 2);
    cB = ismember(s(k).t, zB);
    idxB = find(cB);
    YCSFCB = s(k).CSFCB(idxB, :);    % wyniki klasyfikacji

    yTRUEB = zeros(size(s(k).CSFCB));
    yTRUEB(:, 1) = 1;
    pOC = zB(zB >= 4 & zB <= 5 | zB >= 15 & zB <= 16 | zB >= 26 & zB <= 27); % czBsy OC
    pG = zB(zB >= 6 & zB <= 7 | zB >= 17 & zB <= 18 | zB >= 28 & zB <= 29); % czBsy G
    pOFF = zB(zB >= 8 & zB <= 9 | zB >= 19 & zB <= 20 | zB >= 30 & zB <= 31); % czBsy OFF
    pSAT = zB(zB >= 10 & zB <= 11 | zB >= 21 & zB <= 22 | zB >= 32 & zB <= 33); % czasy OC

    idxTRUE_OC = find(ismember(s(k).t, pOC));
    idxTRUE_G = find(ismember(s(k).t, pG));
    idxTRUE_OFF = find(ismember(s(k).t, pOFF));
    idxTRUE_SAT = find(ismember(s(k).t, pSAT));

    yTRUEB(idxTRUE_OC, 1) = 0; yTRUEB(idxTRUE_OC, 2) = 1;
    yTRUEB(idxTRUE_G, 1) = 0; yTRUEB(idxTRUE_G, 3) = 1;
    yTRUEB(idxTRUE_OFF, 1) = 0; yTRUEB(idxTRUE_OFF, 4) = 1;
    yTRUEB(idxTRUE_SAT, 1) = 0; yTRUEB(idxTRUE_SAT, 5) = 1;
    yTRUEB = yTRUEB(idxB, :);  % wyniki spodziewane

    YCSFCB = arr2cat(YCSFCB');
    yTRUEB = arr2cat(yTRUEB');

    XA_all = [XA_all YCSFCA];
    YA_all = [YA_all yTRUEA];

    XB_all = [XB_all YCSFCB];
    YB_all = [YB_all yTRUEB];
end

X_all = [XA_all XB_all];
Y_all = [YA_all YB_all];
%%

[CA, orderA] = confusionmat(YA_all, XA_all, 'Order', {'NF', 'OC', 'G', 'OFF', 'SAT'});
[CB, orderB] = confusionmat(YB_all, XB_all, 'Order', {'NF', 'OC', 'G', 'OFF', 'SAT'});
[C_all, orderALL] = confusionmat(Y_all, X_all, 'Order', {'NF', 'OC', 'G', 'OFF', 'SAT'});


fig = figure;
fig.Units = 'centimeters';
fig.Position(3:4) = [8 4];
confusionchart(CA, orderA);
ax = gca;
ax.FontName = 'Arial';

fig = figure;
fig.Units = 'centimeters';
fig.Position(3:4) = [8 4];
confusionchart(CB, orderB);
ax = gca;
ax.FontName = 'Arial';

fig = figure;
fig.Units = 'centimeters';
fig.Position(3:4) = [8 4];
confusionchart(C_all, orderALL);
ax = gca;
ax.FontName = 'Arial';
