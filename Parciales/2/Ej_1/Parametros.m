% Parametros
clc; clear;

m = 1000;
%m = 1500;
g = 9.82;
a = 200;
b = 10000;

kp = 1;
ki = 0.1;

% Ej _6
kpp = 39.42;
Ti = 3.077;
Td = 0.7692;
kii = kpp/Ti;
kdd = kpp*Td;
