clear; clc; close all;
% ==========================================
% EJERCICIO 1 - Punto 2
% ==========================================

% 1. Definir los coeficientes
b2 = [1];             % Numerador
a2 = [1, -0.5];       % Denominador

% 2. Ventana para Polos y Ceros
figure(1);
zplane(b2, a2);
title('Plano Z: Polos y Ceros (Ej 2)');

% 3. Ventana para la Respuesta en Frecuencia
figure(2);
freqz(b2, a2);
title('Respuesta en Frecuencia (Ej 2)');