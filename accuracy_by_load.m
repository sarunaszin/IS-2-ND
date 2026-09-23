%% Klasifikavimo tikslumas esant skirtingoms apkrovoms

clear;
clc;
close all;

load('sim_data.mat');

% Rezultatų masyvas:
% 1 stulpelis - apkrova
% 2 stulpelis - A fazes accuracy
% 3 stulpelis - B fazes accuracy
% 4 stulpelis - bendras accuracy

results = zeros(4,4);

for k = 1:4

    %% A faze

    zA = s(k).zero_cross_timesA;
    zA = zA(zA > 2);

    idxA = find(ismember(s(k).t, zA));

    timesA = s(k).t(idxA);
    scoresA = s(k).CSFCA(idxA,:);

    % Tikrosios klases:
    % 1 - NF
    % 2 - OC
    % 3 - G
    % 4 - OFF
    % 5 - SAT

    trueA = ones(length(timesA),1);

    trueA((timesA >= 4  & timesA <= 5)  | ...
          (timesA >= 15 & timesA <= 16) | ...
          (timesA >= 26 & timesA <= 27)) = 2;

    trueA((timesA >= 6  & timesA <= 7)  | ...
          (timesA >= 17 & timesA <= 18) | ...
          (timesA >= 28 & timesA <= 29)) = 3;

    trueA((timesA >= 8  & timesA <= 9)  | ...
          (timesA >= 19 & timesA <= 20) | ...
          (timesA >= 30 & timesA <= 31)) = 4;

    trueA((timesA >= 10 & timesA <= 11) | ...
          (timesA >= 21 & timesA <= 22) | ...
          (timesA >= 32 & timesA <= 33)) = 5;

    % MLP prognozuota klase
    [~, predA] = max(scoresA,[],2);

    accuracyA = mean(predA == trueA) * 100;


    %% B faze

    zB = s(k).zero_cross_timesB;
    zB = zB(zB > 2);

    idxB = find(ismember(s(k).t, zB));

    timesB = s(k).t(idxB);
    scoresB = s(k).CSFCB(idxB,:);

    trueB = ones(length(timesB),1);

    trueB((timesB >= 4  & timesB <= 5)  | ...
          (timesB >= 15 & timesB <= 16) | ...
          (timesB >= 26 & timesB <= 27)) = 2;

    trueB((timesB >= 6  & timesB <= 7)  | ...
          (timesB >= 17 & timesB <= 18) | ...
          (timesB >= 28 & timesB <= 29)) = 3;

    trueB((timesB >= 8  & timesB <= 9)  | ...
          (timesB >= 19 & timesB <= 20) | ...
          (timesB >= 30 & timesB <= 31)) = 4;

    trueB((timesB >= 10 & timesB <= 11) | ...
          (timesB >= 21 & timesB <= 22) | ...
          (timesB >= 32 & timesB <= 33)) = 5;

    [~, predB] = max(scoresB,[],2);

    accuracyB = mean(predB == trueB) * 100;


    %% Bendras A ir B faziu tikslumas

    trueAll = [trueA; trueB];
    predAll = [predA; predB];

    accuracyAll = mean(predAll == trueAll) * 100;


    %% Rezultatu issaugojimas

    results(k,:) = [ ...
        s(k).load_torque, ...
        accuracyA, ...
        accuracyB, ...
        accuracyAll ];

end


%% Rezultatu lentele

T = array2table(results, ...
    'VariableNames', ...
    {'Apkrova','Accuracy_A','Accuracy_B','Bendras_Accuracy'});

disp(T);


%% Grafikas

figure;

plot(T.Apkrova, T.Accuracy_A, '-o', ...
    'LineWidth', 1.5);

hold on;

plot(T.Apkrova, T.Accuracy_B, '-s', ...
    'LineWidth', 1.5);

plot(T.Apkrova, T.Bendras_Accuracy, '-^', ...
    'LineWidth', 1.5);

grid on;
box on;

xlabel('Apkrovos reikšmė');
ylabel('Klasifikavimo tikslumas, %');

title('MLP klasifikavimo tikslumas esant skirtingoms apkrovoms');

legend('A fazė', ...
       'B fazė', ...
       'Bendras', ...
       'Location','southeast');

ylim([90 100]);