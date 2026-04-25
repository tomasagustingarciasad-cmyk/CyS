clear; clc; close all;
% ==========================================
% EJERCICIO 1 - Punto 3
% ==========================================

% 1. Definir los coeficientes unificados
b3 = [2, -2.5];             % Numerador
a3 = [1, -2.5, 1];          % Denominador

% 2. Ventana para Polos y Ceros
figure(1);
zplane(b3, a3);
title('Plano Z: Polos y Ceros (Ej 3)');

% 3. Ventana para la Respuesta en Frecuencia
figure(2);
freqz(b3, a3);
title('Respuesta en Frecuencia (Ej 3)');