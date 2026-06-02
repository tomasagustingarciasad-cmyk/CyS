
%% PARCIAL II: CONTROL Y SISTEMAS

%% Criterio de evaluaión
% _"Se evaluará la calidad del razonamiento 
% técnico y la justificación de las decisiones de diseño."_
%
% _"Priorizar en el análisis descripciones cuantitativas y objetivas." 
% 
% _"Cuide la presentación, escala, colores, títulos y leyendas de sus gráficos para hacerlos 
% lo más legible posible para la evaluación."_

clear;
clc;
close all;

%% Contexto
% Tenemos un sistema que deberá ser modelado, controlado y analizado. Se trata de un
% portón corredizo movido por un motor con su eje solidario a un mecanismo 
% de piñon y cremallera solidaria al portón que permite que este se
% desplace linealmente al girar el motor. La forma en la que el sistema
% disipa la energía se encuentra experimentalmente. 


%% Objetivo
% Modelar y analizar el sistema. 
clc
close all 

m = 200; %kg
%c = 0; % Ns/m estimar c
magnitud_pulso_perturbacion = 100; % N
tiempo_pulso_perturbacion = 50; % s
R = 0.05; % m radio del piñón
tau_maximo_motor = 200; % Nm




%% 1. Modelado del Portón Corredizo
% Modele el portón corredizo. Estimar  el parámetro faltante (c) sabiendo que el portón pasa
% sin fuerzas externas (ni perturbación ni motor) de 1m/s a 0.1m/s en 1s. 
% Luego de obtener las ecuaciones físicas elabore un modelo en SIMULINK.
% Valide el modelo.

% [Ingresa tu modelado aquí]
%Modelado del sistema
% x_dot = v
% m*v_dot = tau_m/R - c*x_dot(t) + d(t)
% [x_dot;v_dot] = A * [x;v] + Bu*[tau;0] + Bd * [0;d]
% yp = Cp * [x;v]

% a(t) = x_ddot(t), v(t) = x_dot(t), m, c

 c = 2.3 *m; 
A = [0, 1; 
     0, -c/m];

Bu = [0; 
      1/(m*R)];

Bd = [0; 
      1/m];

Cp = [0, 1];
D= 0;
% Se aceptan aproximaciones de c por prueba y error, si cumplen con        
% v(0 s) = 1.0 m/s    ^    v(1 s) = 0.1 m/s
% con un error menor al 5% en términos de velocidad.

%% Estimacion de c
%Para estimar el valor de c se da un valor inicial aproximado por la
%formula v_dot(t)* m = -c*v(dot). Como la variacion se da de 0.9 en 1
%segundo comenzamos con un valor de 0.9*m. Esto da un decaimiento de 1m/s a
%0.4m/s. Por lo que el valor debe ser mayor. Se sigue iterando, y mediante
%este método se obtiene un c de 2.3 *m Ns/m. Con este valor de c se
%obtiene para una velocidad unicial de 1m/s una velocidad final de
%0.10025m/s

%% 2. Integración con el Controlador de velocidad
% Integre su modelo al controlador PID dado y luego analice desempeño
% frente a r(t) como escalón de 1 m/s

% [SIMULINK]
%El desempeño no es bueno, debido a que tiene un tiempo de establecimiento
%de aproximadamente 20 segundos, haciendo que el sistema tarde en responder

%% 3. Análisis de Perturbaciones
% Modela el ingreso de una perturbación externa tipo pulso de fuerza de 100 N que va en sentido 
% contrario al de la apertura, justo en el instante de transcurridos
% 49 s de iniciada la maniobra. 
%
% Evalúa el rechazo a esta perturbación de forma objetiva proponga una métrica.

% [Ingresa tu análisis de perturbaciones aquí]

% Dada la perturbacion, el sistema vuelve a tardar unos 15 segundos en
% reestablecerse, por lo que el sistema parece tener una respuesta
% lenta.Aunque todavía no hay parametro de comparacion


%% 4. Rediseño del Controlador (Sintonía)
% Modifica la sintonía del control cumpliendo con los siguientes compromisos:
% 1. Hacer que el portón abra más rápido ante un escalón en la referencia de velocidad.
% 2. Que la respuesta ante la perturbación se mantenga idéntica a la del punto anterior.

% Copia y pega los bloques del sistema completo, de manera de ver el modelo
% antes y después de rediseñar el controlador, con idénticas r(t) y d(t).

% [SIMULINK]
%Para mejorar la respuesta del sistema, se puede utilizar ubicacion de
%polos
sistema = ss(A, Bu, Cp,D);
H = tf(sistema);
disp('La funcion de transferencia de la planta queda: ');
H
%Al analizar la funcion de transferencia de la planta sola podemos observar
%que posee un polo en -2.3.

% Propongo polinomio característico deseado con 0% de overshoot para evitar vibraciones del porton y un tiempo
% de establecimiento menor al actual, propongo 0.5s. Para tener respuesta rapida del porto
% La frecuencia natural quedara de 5.8rad/s.
%El polinomio queda entonces s^2 +11.6s + 33.64
% Reemplazando los valores se obtiene mediante igualacion y ubicacion de polos Kp=93 y Ki=336.1
%Con esto se obtiene respuesta mas rápida, pero con pico mas acentuado de
%con una diferencia de un 10%, pero con un tiempo de establecimiento
%inicial de 6 segundos contra un tiempo de establecimiento previo de 22seg

%Ademas, se coloca el controlador proporcional el la rama principal, lo que
%mejora la respuesta de 0.3seg aproximamadente.


%% 5. Análisis del Actuador
% A partir de la nueva acción de control (torque del motor con el controlador rediseñado), 
% determina si esto requiere el reemplazo del motor por uno de mayor capacidad.

% [Ingresa tu análisis del actuador aquí]
%Al evaluar el actuador, se puede observar que no hay ningun problema
%respecto al torque te puede entregar el motor. Se observa que el valor de
%toque máximo que es de 200 Nm no llega a superarse, estando muy por debajo
%de dicho valor. Dado que tau= F*R, se puede obtener tau multiplicando la
%consigna de fuerza por R. Esto llega a 28 Nm, no teniendo problemas con el
%motor. 