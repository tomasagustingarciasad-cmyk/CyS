clc, clear
% 1. Definición de las matrices del sistema
A = [-1.25, 0; 
      0.00005, -0.0024];
B = [20000; 0];
C = [0, 1];
% 2. Definición de los polos deseados (calculados en el inciso a)
polos_deseados = roots([1 (3*sqrt(2))/5 0.36])
disp("La matriz K queda definida con los coeficientes:")
K = acker(A, B, polos_deseados);
disp(K);

disp("La matriz kr es:")

Kr= -inv(C*inv(A-B*K)*B);
disp(Kr);