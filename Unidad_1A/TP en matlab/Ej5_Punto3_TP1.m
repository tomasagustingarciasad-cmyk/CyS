clc
clear
close all
% ==========================================
% EJERCICIO 5 - Punto 3 (Análisis de Estabilidad)
% ==========================================

% Un sistema LTI causal es estable si (y solo si) 
% todos sus polos se encuentran dentro del círculo unitario en el plano Z

% 1. Recuperamos los coeficientes de nuestra Función de Transferencia H(z)
b = [1];
a = [1, -0.5, -0.1, -0.2];

% ------------------------------------------
% MÉTODO 1: Cálculo matemático (raíces)
% ------------------------------------------
polos = roots(a);         % Encuentra las raíces del denominador
magnitudes = abs(polos);  % Calcula el valor absoluto (módulo) de cada raíz

disp('--- ANÁLISIS DE ESTABILIDAD ---');
disp('Los polos del sistema son:');
disp(polos);
disp('La magnitud (distancia al origen) de cada polo es:');
disp(magnitudes);

% ------------------------------------------
% MÉTODO 2: Comprobación gráfica (zplane)
% ------------------------------------------
figure(2);
zplane(b, a);
title('Plano Z: Análisis de Estabilidad (Ej 5)');

