clc, clear, close all
% ==========================================
% EJERCICIO 2 - PUNTO 5 y 6 (Función filter)
% ==========================================

% 1. Definimos las señales originales
x1 = [1, 1, 3];    % Señal de entrada
x2 = [1, 0, 3];    % Coeficientes del "filtro" (nuestro sistema FIR)

% 2. El truco de agregar ceros (zero-padding)
% Queremos que la salida tenga tamaño 5 (igual que conv).
% Así que le agregamos dos ceros al final a x1.
x1_rellenado = [1, 1, 3, 0, 0]; 

% 3. Aplicamos la función filter
% Sintaxis: filter(b, a, entrada)
% 'b' son los coeficientes del numerador (nuestro x2)
% 'a' es el denominador. Como x2 no tiene denominador, a = 1.
x_filter = filter(x2, 1, x1_rellenado);

% 4. Comparamos los resultados (Punto 6)
x_conv = conv(x1, x2); % Lo que calculamos en el paso anterior

disp('Resultado usando conv:');
disp(x_conv);

disp('Resultado usando filter:');
disp(x_filter);

%Al comparar los resultados idénticos, comprobamos que ambas funciones representan 
% dos enfoques del mismo fenómeno. Mientras que conv realiza la operación matemática 
% pura de la convolución (equivalente a multiplicar los polinomios $X_1(z)$ y $X_2(z)$), 
% filter aborda el problema desde la perspectiva de Señales y Sistemas, tratando a uno de 
% los polinomios como la Función de Transferencia $H(z)$ de un sistema discreto. 
% Así, queda demostrado de forma práctica que procesar una señal a través de un filtro digital es 
% matemáticamente equivalente a convolucionar dicha señal con la respuesta al impulso del sistema.