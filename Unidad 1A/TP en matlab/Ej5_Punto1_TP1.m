clc, clear, close all
% ==========================================
% EJERCICIO 5 - Punto 1 (Respuesta en el tiempo con filtic)
% ==========================================

% 1. Definimos los coeficientes del sistema H(z)
b = [1];
a = [1, -0.5, -0.1, -0.2];

% 2. Definimos las condiciones iniciales (y_past)
% El orden SIEMPRE es: [y[-1], y[-2], y[-3], ...]
y_iniciales = [1, 2, 3];

% 3. Calculamos los estados iniciales del filtro con filtic
% (Como no hay condiciones iniciales de entrada x, solo le pasamos y)
zi = filtic(b, a, y_iniciales);

% 4. Creamos el vector de tiempo (n) y la entrada escalón (x)
n = 0:20;             % Simulamos 30 muestras
x = ones(1, length(n)); % Escalón u[n]

% 5. Filtramos la señal pasándole los estados iniciales (zi)
y = filter(b, a, x, zi);

% 6. Graficamos
figure(1);
stem(n, y, 'filled', 'LineWidth', 1.5);
title('Respuesta del sistema con condiciones iniciales');
xlabel('n');
ylabel('y[n]');
grid on;