%---------------------------------------------------
% Section Assignment 3.Ex.1 - Cruise controller with 
% state feedback 
%
%---------------------------------------------------
% Model parameters
%---------------------------------------------------
clc, clear

m=20000;                % Vehicle mass [kg]
k=2000;                % Engine torque gain factor [Nm/rad]
r=4;                    % Gear ratio (for a specific gear) [-]
tau=0.8;                % Engine time constant [s]
g=9.82;                 % Gravity [m/s^2]
alpha = 20*pi/180;
rho=1.2;                % Air density [kg/m^3]
CD=0.5;                 % Drag coefficient [-]
Af=4;                   % Front area [m^2]
rw=0.5;                 % Wheel radius [m]
f=0.015;                % Rolling resistance coefficient [-]\\


%---------------------------------------------------
% Equilibrium point 
%---------------------------------------------------
% x2e=                  % Vehicle velocity [m/s]
% x1e=                  % Wheel force [N]
% ue=                   % Pedal position [rad]
% de=                   % Slope [rad]

x2e=20;                 
x1e=0.5*rho*CD*Af*x2e^2+m*g*f;
ue=rw*x1e/k/r;
de=0;

%---------------------------------------------------
% Linear longitudinal vehicle dynamics model 
% A, B, C, D and H matrices
%---------------------------------------------------

H=[0 -g]';
C=[0 1];
D=[0];
A = [-1.25, 0; 
      0.00005, -0.0024];
B = [20000; 0];
% 2. Definición de los polos deseados (calculados en el inciso a)
polos_deseados = roots([1 (3*sqrt(2))/5 0.36])

%-----------------------------------------------------
% Control design part
% Enter your control design here
%-----------------------------------------------------
disp("La matriz K queda definida con los coeficientes:")
K = acker(A, B, polos_deseados);
disp(K);

disp("La matriz kr es:")

kr= -inv(C*inv(A-B*K)*B);
disp(kr);

%---------------------------------------------------
% For simulation purposes (do not modify)
%---------------------------------------------------
B1=[B H];                   % Put the B and H matrix together as one matrix B1 (for Simulink implementation purposes) 
C1=eye(2);                  % Output all state variables from the model
D1=zeros(2);              % Corresponding D matrix
