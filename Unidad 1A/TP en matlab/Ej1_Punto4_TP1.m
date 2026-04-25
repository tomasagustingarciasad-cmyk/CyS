clear; clc; close all;
% ==========================================
% EJERCICIO 1 - Punto 4
% ==========================================

% 1. Definir los coeficientes
b4 = [0];             % Numerador
a4 = [1, -0.5];       % Denominador

% 2. Ventana para Polos y Ceros
figure(1);
zplane(b4, a4);
title('Plano Z: Polos y Ceros (Ej 4)');

% 3. Ventana para la Respuesta en Frecuencia
figure(2);
freqz(b4, a4);
title('Respuesta en Frecuencia (Ej 4)');