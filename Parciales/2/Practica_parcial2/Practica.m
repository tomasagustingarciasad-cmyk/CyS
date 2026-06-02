%% Ejercicio 1. 
% Construya un modelo en simulink usando simscape (mecánica 
% traslacional) de la suspensión de un cuarto de vehículo (un colectivo).
% Los parámetros se dan abajo.
% Las perturbaciones del terreno aparecen a los 50 segundos y se modelan 
% como un ruido de 1 m/s^2 RMS (el bloque Band-Limited White Noise ya está configurado)
% SI EL MODELO ES CORRECTO, generan compresiones de la suspensión 
% de 3 a 4 cm pico (Evaluar en 200s).
% (2 puntos)

%% Parameters (golden car)
clc
clear
close all

m_s = 3000;  % Sprung mass (masa del chasis por rueda) (kg)
k_s = 63.3*m_s;  % Spring stiffness (rigidez del resorte) (N/m)
c_s = 6*m_s;  % Damping coefficient (coeficiente de amortiguamiento del amortiguador) (Ns/m)
k_t = 653*m_s;  % Tire stiffness (rigidez del neumático) (N/m)
c_t = 0;  % Tire damping (Ns/m)
m_u = 0.15*m_s;  % (masa de la rueda) Unsprung mass (kg)


%Se conectan el resorte que, une el chasis con la rueda, en paralelo con el almotriguador.Todo este
%conjunto se conecta en seie con el resorte de la rueda,luego se colocan
%las mazas sobre cada nodo. Una conectada encima del resorte y amortiguador
%y otra entre los elementos series. Luego se coloca el sensor de posicion
%entre las dos puntos en los que se conectan las masas. Y finalmente se
%colocan las fuerzas y velocidad entrantes
%% Ejercicio 2. 
% Considerando un sensor ideal de distancia para medir la compresión de
% la suspensión:
% Implemente un PID para que el colectivo descienda y permita el ingreso 
% de pasajeros. 
% Este controlador, cuando el chofer da un escalón a la referencia
% de -10 cm a los 10 s, debe hacer que la suspensión se comprima 10 cm, 
% sin error en estado estacionario, sin sobre-impulso y con un tiempo de 
% establecimiento de menos de 1.0 s.
% Por otra parte, cuando sube el pasajero, modelado como perturbación
% tipo escalón de 700 N a los 20 s, el controlador debe rechazar la 
% perturbación con un tiempo de establecimiento de menos de 1.0 s.
% Un pasajero baja a los 25 s, lo cual también se modela con un escalón.
% Para esto puede usar el comando 
% pidTuner(H, 'PID');
% y obtener las ganancias por tanteo observando la tabla mostrada al pulsar 
% el botón Show Parameters.
% (2 puntos)

M= [m_u, 0;
    0, m_s];

Ca=[c_t+c_s, -c_s;
    -c_s, c_s];

k_rig= [k_t+k_s, -k_s;
    -k_s, k_s];


A=[0, 0, 1, 0;
    0, 0, 0, 1;
    -inv(M)*k_rig, -inv(M)*Ca];

F= [-1;1];
B= [0;0;inv(M)*F];
C= [-1, 1, 0, 0];
D=0;
sistema = ss(A, B, C,D);
H = tf(sistema);
disp('La funcion de transferencia queda: ');
H
%pidTuner(H, 'PID')
%% Ejercicio 3
% Modifique el controlador de manera que la acción de control nunca 
% supere los 20000 N en valor absoluto. Se permite degradación del
% desempeño ante el escalón en la referencia, pero ante el escalón de la
% perturbación debe mantener la dinámica.
% (2 puntos)


%% Ejercicio 4
% Agregue al modelo de simulink los componentes necesarios para modelar los
% siguientes detalles:
% La compresión de la suspensión se mide con tres sensores de distancia que
% tienen los siguientes ruidos (no correlacionados):
% Sensor A: 10 mm RMS (el bloque Band-Limited White Noise ya está configurado)
% Sensor B: 5 mm RMS (el bloque Band-Limited White Noise ya está configurado)
% Sensor C: 5 mm RMS (el bloque Band-Limited White Noise ya está configurado)
% (1 punto)



%% Ejercicio 5
% Diseñe e implemente un observador de estado (posiblemente como filtro de 
% Kalman) de manera de tener una estimación de la altura del chasis con un
% ruido RMS menor a 5 mm.
% (2 puntos) Si lo diseña por ubicación de polos (usando place o aker)
% (3 puntos) Si lo diseña como filtro de Kalman-Bucy de tiempo continuo 
% (usando lqr), puede llegar a un ruido de 3.5 mm RMS en la primer intento
% correcto
O = [C; C*A; C*A*A; C*A*A*A];
det(O);

C_obs = [-1, 1, 0, 0;
         -1, 1, 0, 0;
         -1, 1, 0, 0];
% 1. Verificación de Observabilidad Multivariable
O_mat = obsv(A, C_obs); % Comando nativo de MATLAB para la matriz de observabilidad
rango_O = rank(O_mat);

disp('--- ANÁLISIS DE OBSERVABILIDAD ---');
disp(['El rango de la matriz es: ', num2str(rango_O)]);
if rango_O == size(A, 1)
    disp('El sistema es completamente observable con los 3 sensores.');
else
    disp('Alerta: El sistema pierde observabilidad.');
end

% 2. Extracción de polos del sistema a lazo cerrado
% Cargamos las ganancias que usted sintonizó
Kp = 395124.4635;
Ki = 1162764.2252;
Kd = 33567.2827;

% La ecuación característica (que define los polos) de un I-PD 
% es idéntica a la de un PID clásico.
C_pid = pid(Kp, Ki, Kd);
sys_cl = feedback(C_pid * H, 1);
polos_cl = pole(sys_cl);

disp('--- POLOS A LAZO CERRADO ---');
disp(polos_cl);

% 1. Selección y aceleración de los polos para el observador (Factor = 5)
factor_vel = 5;
P_obs = factor_vel * [-59.2543 + 23.8347i; 
                      -59.2543 - 23.8347i; 
                      -5.4183 + 11.8458i; 
                      -5.4183 - 11.8458i];

% 2. Cálculo de la matriz de ganancias del observador (L) mediante dualidad
% Se utiliza A transpuesta y C_obs transpuesta. El resultado se transpone nuevamente.
L = place(A', C_obs', P_obs)';

disp('--- MATRIZ DE GANANCIAS DEL OBSERVADOR (L) ---');
disp(L);



%% Ejercicio 6 Control LQR
%- Haga una copia del modelo de simulink/simscape de la sección 1
%- Elimine el bloque PID, pero mantenga el modelo de la planta en simscape. Coloque el nombre
%parcial2_LQR_NOMBRE_APELLIDO.slx 
%Agregue un controlador LQR (K), con seguimiento de referencia por feedforward (kr), 
% y acción integral (ki). LAs matrices de ganancias ,  y  deben estar explícitas en el diagrama en bloques. 
%No es necesario diseñar los valores óptimos para K, kr y ki (puede asignar valores 1 a todos los elementos como prueba), 
% pero el modelo debe poder ejecutarse. 
% Es decir, las dimensiones de las matrices deben ser consistentes para que simulink no de error.

A_aug = [A, zeros(4,1);
         C, 0];

B_aug = [B;0];
Qx = eye(5);
Qu=1;
%K_aug1 = acker(A_aug, B_aug, P_aug)
K_aug = lqr(A_aug, B_aug, Qx, Qu);
K = K_aug(1:4);
Ki = K_aug(5);
Kr= -inv(C*inv(A-B*K)*B);



