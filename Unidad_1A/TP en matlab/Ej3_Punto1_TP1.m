clc, clear, close all
% ==========================================
% EJERCICIO 3 PUNTO 1 
% ==========================================

% 1. Definir los coeficientes
b4 = [3, 3.4, 0.87];             % El numerador
a4 = [1, -1.7, 0.87, -0.135];       % Denominador

% 2. Ventana para Polos y Ceros
figure(1);
zplane(b4, a4);
title('Plano Z: Polos y Ceros (Ej 4)');

% 3. Ventana para la Respuesta en Frecuencia
figure(2);
freqz(b4, a4);
title('Respuesta en Frecuencia (Ej 4)');