clear;
clc;
close all;

load('sim_data.mat');

XA_all = [];
YA_all = [];

XB_all = [];
YB_all = [];

classes = {'NF','OC','G','OFF','SAT'};

for k = 1:4

    %% A fazė

    zA = s(k).zero_cross_timesA(s(k).zero_cross_timesA > 2);

    idxA = find(ismember(s(k).t, zA));

    YpredA = s(k).CSFCA(idxA,:);

    YtrueA = zeros(size(s(k).CSFCA));
    YtrueA(:,1) = 1;

    pOC  = zA((zA >= 4 & zA <= 5) | ...
              (zA >= 15 & zA <= 16) | ...
              (zA >= 26 & zA <= 27));

    pG   = zA((zA >= 6 & zA <= 7) | ...
              (zA >= 17 & zA <= 18) | ...
              (zA >= 28 & zA <= 29));

    pOFF = zA((zA >= 8 & zA <= 9) | ...
              (zA >= 19 & zA <= 20) | ...
              (zA >= 30 & zA <= 31));

    pSAT = zA((zA >= 10 & zA <= 11) | ...
              (zA >= 21 & zA <= 22) | ...
              (zA >= 32 & zA <= 33));

    YtrueA(ismember(s(k).t,pOC),:)  = repmat([0 1 0 0 0],sum(ismember(s(k).t,pOC)),1);
    YtrueA(ismember(s(k).t,pG),:)   = repmat([0 0 1 0 0],sum(ismember(s(k).t,pG)),1);
    YtrueA(ismember(s(k).t,pOFF),:) = repmat([0 0 0 1 0],sum(ismember(s(k).t,pOFF)),1);
    YtrueA(ismember(s(k).t,pSAT),:) = repmat([0 0 0 0 1],sum(ismember(s(k).t,pSAT)),1);

    YtrueA = YtrueA(idxA,:);

    [~, predA] = max(YpredA,[],2);
    [~, trueA] = max(YtrueA,[],2);

    XA_all = [XA_all; predA];
    YA_all = [YA_all; trueA];


    %% B fazė

    zB = s(k).zero_cross_timesB(s(k).zero_cross_timesB > 2);

    idxB = find(ismember(s(k).t, zB));

    YpredB = s(k).CSFCB(idxB,:);

    YtrueB = zeros(size(s(k).CSFCB));
    YtrueB(:,1) = 1;

    pOC  = zB((zB >= 4 & zB <= 5) | ...
              (zB >= 15 & zB <= 16) | ...
              (zB >= 26 & zB <= 27));

    pG   = zB((zB >= 6 & zB <= 7) | ...
              (zB >= 17 & zB <= 18) | ...
              (zB >= 28 & zB <= 29));

    pOFF = zB((zB >= 8 & zB <= 9) | ...
              (zB >= 19 & zB <= 20) | ...
              (zB >= 30 & zB <= 31));

    pSAT = zB((zB >= 10 & zB <= 11) | ...
              (zB >= 21 & zB <= 22) | ...
              (zB >= 32 & zB <= 33));

    YtrueB(ismember(s(k).t,pOC),:)  = repmat([0 1 0 0 0],sum(ismember(s(k).t,pOC)),1);
    YtrueB(ismember(s(k).t,pG),:)   = repmat([0 0 1 0 0],sum(ismember(s(k).t,pG)),1);
    YtrueB(ismember(s(k).t,pOFF),:) = repmat([0 0 0 1 0],sum(ismember(s(k).t,pOFF)),1);
    YtrueB(ismember(s(k).t,pSAT),:) = repmat([0 0 0 0 1],sum(ismember(s(k).t,pSAT)),1);

    YtrueB = YtrueB(idxB,:);

    [~, predB] = max(YpredB,[],2);
    [~, trueB] = max(YtrueB,[],2);

    XB_all = [XB_all; predB];
    YB_all = [YB_all; trueB];

end

%% Painiavos matricos

CA = confusionmat(YA_all,XA_all);
CB = confusionmat(YB_all,XB_all);

YtrueAll = [YA_all; YB_all];
YpredAll = [XA_all; XB_all];

C = confusionmat(YtrueAll,YpredAll);

%% Accuracy

accuracyA = sum(diag(CA))/sum(CA(:));
accuracyB = sum(diag(CB))/sum(CB(:));
accuracyAll = sum(diag(C))/sum(C(:));

fprintf('A fazės accuracy: %.2f %%\n',accuracyA*100);
fprintf('B fazės accuracy: %.2f %%\n',accuracyB*100);
fprintf('Bendras accuracy: %.2f %%\n\n',accuracyAll*100);

%% Precision, Recall ir F1

precision = diag(C) ./ sum(C,1)';
recall    = diag(C) ./ sum(C,2);

F1 = 2 .* precision .* recall ./ (precision + recall);

for i = 1:length(classes)
    fprintf('%s: Precision = %.3f, Recall = %.3f, F1 = %.3f\n', ...
        classes{i},precision(i),recall(i),F1(i));
end

fprintf('\nMacro F1 = %.3f\n',mean(F1,'omitnan'));

%% Bendra painiavos matrica

figure;
confusionchart(C,classes);
title('Bendra srovės jutiklių gedimų klasifikavimo matrica');