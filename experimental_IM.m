%% Eksperimentiniai indukcinio variklio duomenys
% MLP sroves jutikliu gedimu klasifikavimas

clear;
clc;
close all;

%% Duomenu ikelimas

load('m100_data.mat');

% Patogesnis trumpas pavadinimas
d = m100_data;

%% Duomenu struktura

disp('Duomenu laukai:');
disp(fieldnames(d));

fprintf('Matavimo trukme: %.2f s\n', d.t(end));
fprintf('Duomenu tasku skaicius: %d\n', length(d.t));

%% Naudojame eksperimentine dali iki t_stop

idx = d.t <= d.t_stop;

t = d.t(idx);

%% 1 pav. A fazes srove

figure;

tiledlayout(3,1);

nexttile;

plot(t, d.isA(idx), ...
    'LineWidth', 1);

hold on;

plot(t, d.isA_VCS(idx), ...
    'LineWidth', 1);

grid on;
box on;

xlabel('Laikas, s');
ylabel('Srove, A');

title('A fazes srove');

legend('Ismatuota srove', ...
       'Apskaiciuota srove', ...
       'Location','best');


%% B fazes srove

nexttile;

plot(t, d.isB(idx), ...
    'LineWidth', 1);

hold on;

plot(t, d.isB_VCS(idx), ...
    'LineWidth', 1);

grid on;
box on;

xlabel('Laikas, s');
ylabel('Srove, A');

title('B fazes srove');

legend('Ismatuota srove', ...
       'Apskaiciuota srove', ...
       'Location','best');


%% MLP klasifikavimo rezultatai

nexttile;

stairs(t, d.CSFCA_plot(idx), ...
    'LineWidth', 1.3);

hold on;

stairs(t, d.CSFCB_plot(idx), ...
    'LineWidth', 1.3);

yticks(0:4);
yticklabels({'NF','OC','G','OFF','SAT'});

ylim([-0.5 4.5]);

grid on;
box on;

xlabel('Laikas, s');
ylabel('Gedimo klase');

title('Eksperimentinis sroves jutikliu gedimu klasifikavimas');

legend('A faze', ...
       'B faze', ...
       'Location','best');