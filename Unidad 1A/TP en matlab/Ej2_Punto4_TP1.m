clc, clear, close all
% ==========================================
% EJERCICIO 2 - PUNTO 4 (Función conv)
% ==========================================

% 1. Definimos los coeficientes de los polinomios (las señales)
x1 = [1, 1, 3];    % Representa 1 + z^-1 + 3z^-2
x2 = [1, 0, 3];    % Representa 1 + 0z^-1 + 3z^-2

% 2. Usamos la función conv para multiplicarlos
x_conv = conv(x1, x2);

% 3. Mostramos el resultado en la consola
disp('El resultado de la convolución con conv es:');
disp(x_conv);