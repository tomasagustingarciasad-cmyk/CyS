clc, clear, close all
% ==========================================
% EJERCICIO 4 - Fracciones Parciales con residuez
% ==========================================

% 1. Definimos los coeficientes de Y(z)
b = [1];                    % Numerador: 1
a = [1, -1.7, 0.7];         % Denominador: 1 - 1.7z^-1 + 0.7z^-2

% 2. Aplicamos la función residuez
[r, p, k] = residuez(b, a);

% 3. Mostramos los resultados en consola
disp('Residuos (r):');
disp(r);

disp('Polos (p):');
disp(p);

% ==========================================
% EJERCICIO 4 - Respuesta en el tiempo con filter
% ==========================================

% 1. Definimos los coeficientes del SISTEMA H(z)
b = [1];
a = [1, -0.7];

% 2. Creamos un vector de tiempo 'n' (de 0 a 20 muestras)
n = 0:20;

% 3. Creamos la señal de entrada x[n] = u[n] (un escalón)
x = ones(1, length(n));

% 4. Pasamos la señal por el sistema usando filter
y = filter(b, a, x);

% 5. Graficamos el resultado
figure(1);
stem(n, y, 'filled', 'LineWidth', 1.5);
title('Respuesta del sistema a un escalón unitario');
xlabel('Muestras (n)');
ylabel('Amplitud y[n]');
grid on;