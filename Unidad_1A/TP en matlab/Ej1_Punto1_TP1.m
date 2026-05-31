clear; clc; close all;
% ==========================================
% EJERCICIO 1 - Punto 1
% ==========================================

% 1. Definir los coeficientes (en potencias de z^-1)
b1 = [1];            % Numerador
a1 = [1, -1/3];      % Denominador

% 2. Crear la PRIMERA ventana para Polos y Ceros
figure(1);
zplane(b1, a1);
title('Plano Z: Polos y Ceros (Ej 1)');

% 3. Crear la SEGUNDA ventana para la Respuesta en Frecuencia
figure(2);
freqz(b1, a1);
title('Respuesta en Frecuencia (Ej 1)');