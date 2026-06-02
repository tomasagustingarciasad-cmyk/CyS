clc, clear
% 1. Definición de las matrices del sistema
A = [-0.4925, 28.07, -2105.26; 
      0.0028, -0.16, 12; 
      0.0175, -1, 0];
B = [1.6; 0; 0];
C = [0, 1, 0];
% 2. Definición de los polos deseados (calculados en el inciso a)
polo_real = -6 * sqrt(2);
polos_complejos = [-3*sqrt(2) + 3*sqrt(2)*1i, -3*sqrt(2) - 3*sqrt(2)*1i];
polos_deseados = [polo_real, polos_complejos(1), polos_complejos(2)];

% 3. Cálculo de la matriz K mediante Ackermann

disp("La matriz K queda definida con los coeficientes:")
% K es la matriz tal que |sI-(A-KB)| = 0
K = acker(A, B, polos_deseados);
disp(K);

disp("La matriz kr es:")

Kr= -inv(C*inv(A-B*K)*B);

% Se reemplaza la inversión por división matricial izquierda para mayor robustez numérica
%Kr2 = -1 / (C * ((A - B*K) \ B))
disp("polos a lazo cerrado:")
% Cálculo de los polos a lazo cerrado
polos_LC = eig(A - B*K)