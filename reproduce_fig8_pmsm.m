%% Straipsnio 8 pav. atkūrimas - PMSM, A fazė, SAT gedimas

clear;
clc;
close all;

load('sim_data.mat');

% s(4) atitinka nominalią apkrovą
d = s(4);

% Gedimo pradžia duomenų rinkinyje
fault_time = 10;

% Rodomas trumpas intervalas aplink SAT gedimo atsiradimą
t1 = 9.95;
t2 = 10.08;

idx = d.t >= t1 & d.t <= t2;

%% MLP klasifikatoriaus atsakymas

% CSFCA turi 5 MLP išėjimus:
% 1 - NF
% 2 - OC
% 3 - G
% 4 - OFF
% 5 - SAT

[~, classA] = max(d.CSFCA, [], 2);

%% Grafikas

figure;

tiledlayout(2,1);

% 1. Išmatuota ir apskaičiuota srovė
nexttile;

plot(d.t(idx), d.isA(idx), ...
    'LineWidth', 1.3);

hold on;

plot(d.t(idx), d.isA_VCS(idx), ...
    'LineWidth', 1.3);

xline(fault_time, '--', ...
    'Gedimo pradžia', ...
    'LineWidth', 1.2);

grid on;
box on;

xlabel('Laikas, s');
ylabel('Srovė');

title('A fazės srovė SAT gedimo metu');

legend('Išmatuota srovė', ...
       'Apskaičiuota srovė', ...
       'Location','best');


% 2. MLP klasifikavimo rezultatas
nexttile;

stairs(d.t(idx), classA(idx), ...
    'LineWidth', 1.5);

hold on;

xline(fault_time, '--', ...
    'Gedimo pradžia', ...
    'LineWidth', 1.2);

yticks(1:5);
yticklabels({'NF','OC','G','OFF','SAT'});

ylim([0.5 5.5]);

grid on;
box on;

xlabel('Laikas, s');
ylabel('MLP klasė');

title('Srovės jutiklio gedimo klasifikavimas');

%% SAT gedimo atpažinimo laiko skaičiavimas

idx_after_fault = find( ...
    d.t >= fault_time & classA == 5, ...
    1, ...
    'first');

detection_time = d.t(idx_after_fault);
delay = detection_time - fault_time;

fprintf('SAT gedimo pradžia: %.4f s\n', fault_time);
fprintf('SAT atpažintas: %.4f s\n', detection_time);
fprintf('Atpažinimo vėlavimas: %.4f s\n', delay);