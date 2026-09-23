%% Eksperimentinio OC gedimo analize

clear;
clc;
close all;

load('m100_data.mat');

d = m100_data;

%% Analizuojamas intervalas

t1 = 3.8;
t2 = 5.2;

idx = d.t >= t1 & d.t <= t2;

%% Grafikas

figure;

tiledlayout(2,1);

%% A fazes srove

nexttile;

plot(d.t(idx), d.isA(idx), ...
    'LineWidth', 1.2);

hold on;

plot(d.t(idx), d.isA_VCS(idx), ...
    'LineWidth', 1.2);

grid on;
box on;

xlabel('Laikas, s');
ylabel('Srove, A');

title('Eksperimentinis A fazes sroves signalas');

legend('Ismatuota srove', ...
    'Apskaiciuota srove', ...
    'Location','best');

%% MLP klasifikavimo rezultatas

nexttile;

stairs(d.t(idx), d.CSFCA_plot(idx), ...
    'LineWidth', 1.5);

yticks(0:4);
yticklabels({'NF','OC','G','OFF','SAT'});

ylim([-0.5 4.5]);

grid on;
box on;

xlabel('Laikas, s');
ylabel('Gedimo klase');

title('A fazes sroves jutiklio gedimo klasifikavimas');

%% OC atpazinimo intervalo nustatymas

t_col = d.t(:);
class_col = d.CSFCA_plot(:);

first_OC = find(t_col >= 3.5 & class_col == 1, ...
                1, 'first');

last_OC = find(t_col >= 3.5 & t_col <= 5.5 & ...
               class_col == 1, ...
               1, 'last');

fprintf('OC atpazinimo pradzia: %.4f s\n', ...
    t_col(first_OC));

fprintf('OC atpazinimo pabaiga: %.4f s\n', ...
    t_col(last_OC));