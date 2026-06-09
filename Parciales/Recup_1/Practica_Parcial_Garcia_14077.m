clc, clear, close all;
%% APELLIDO, NOMBRE: LEGAJO 
%% Garcia Sad, Tomas Agustin: 14077 


%% PARCIAL I: CONTROL Y SISTEMAS


%% Contexto
% Estás analizando la cantidad de turnos atendidos en un consultorio médico. 
% El sistema registra diariamente el número de pacientes atendidos, generando 
% una serie temporal discreta x[k], donde cada muestra representa un día.

%% Objetivo
% El equipo de gestión solicita elaborar un reporte resumido con un *valor representativo 
% cada 10 días*, con el objetivo de facilitar el monitoreo operativo y la planificación 
% de recursos a largo plazo, eliminando las fluctuaciones diarias irrelevantes 
% para la tendencia general anual.

%% Criterio de evaluaión
% _“No se evaluará únicamente el resultado numérico, sino la calidad del razonamiento 
% técnico y la justificación de las decisiones de diseño.”_
%
% _"Cuide la presentación, escala, colores, títulos y leyendas de sus gráficos para hacerlos 
% lo más legible posible para la evaluación."_

%% Tareas a desarrollar
% Diseñar e implementar en MATLAB un script que permita reducir la serie 
% temporal original. La salida debe ser una nueva serie reducida que entregue 
% un valor representativo cada 10 días.


%% 1. Análisis Previo de los Datos
% Seleccione y aplique comandos de MATLAB para estudiar la señal original 
% y extraer la información relevante.

% 1. Extracción y Análisis Previo de los Datos
% Carga de la serie temporal discreta
datos = load('datos_turnos.txt');
N = length(datos);

% Vector de tiempo discreto k (días)
k = 0:(N-1);
t = 0:(N-1); % Vector de tiempo en días
% Gráfico en el dominio del tiempo
figure;
plot(k, datos, 'Color', [0.7 0.7 0.7]); % Se utiliza plot en lugar de stem por la densidad de los datos
title('Serie temporal original: Turnos diarios');
xlabel('Días (k)');
ylabel('Cantidad de turnos x[k]');
grid on;

% Gráfico en el dominio de la frecuencia (Espectro)
% Frecuencia de muestreo fs = 1 (1 muestra por día)
Fs = 1; 

[f, dft_mag, dft_phase, dft, NFFT] = my_dft(datos, Fs);



figure;
plot(f, dft_mag, 'r');
title('Espectro de magnitud de la señal original');
xlabel('Frecuencia (ciclos/día)');
ylabel('|X(f)|');
xlim([0 Fs/2]);
grid on;
%------

 
% *1.1 Justifique brevemente la elección de dichas herramientas*

%Se extraen los datos del archivo: datos_turnos, y se coloca cada valor numerico en un vector. 
% Se plotea dicho vector para ver la variación de la informacion a lo largo
% del tiempo, y se utiliza la funcion my_dft para extraer los valores que
% permitan graficar la informacion en el dominio de la frecuencia.

%%
% 
% *1.2 Explique los resultados obtenidos del análisis*
%Se pueden observar frecuencias de gran amplitud en valores de 0.0029c/d y
%en valores de 0.14 c/d.


%%
% 
% *1.3 Mencione qué información le resulta relevante y útil para la solución.*
%Es importante mensionar que debido a que se realizará un diezmado de 10
%muestras, quedará una frecuencia de muestreo de 0.1c/d. Por el teorema de
%muestreo esto significa que existirá aliasing si no se filtran los valores
%de 0.05 c/d o mas. Como existe un pico en 0.14c/d, este debe ser eliminado

%% 2. Pre-Proceso
% *Proceda a realizar el tratamiento de la señal*

%Primero procesamos la señal con filtro antialiasing 
%Colocamos el primer cero en la frecuencia que queremos eliminar(0.14), por
%lo que este se encontrará en f1°0 = fs/N, N=fs/f1°0 =1/0.143066 = 7
%De esta manera, queda que se debe aplicar un filtro de media movil con N=7

N=7; % Tamaño de la ventana del filtro Media Móvil

M = 10; % Factor de decimación (1 valor cada 10 días)

b = (1/N) * ones(1, N); % Coeficientes del numerador (filtro FIR)
a = 1;

% Aplicación del filtro a la serie temporal original
datos_filtrados = filter(b, a, datos);
% Verificación en el dominio de la frecuencia
[f_filt, dft_mag_filt, ~, ~, ~] = my_dft(datos_filtrados, Fs);


% 1. Decimación de la señal filtrada usando tu estructura
fs_new =Fs/M;
x_reducida = datos_filtrados(1:round(Fs/fs_new):end);
k_reducido = k(1:round(Fs/fs_new):end);
[f_filt_red, dft_mag_filt_red, ~, ~, ~] = my_dft(x_reducida, Fs/M);

figure;
plot(k, datos, 'Color', [0.7 0.7 0.7], 'DisplayName', 'Original (Con ruido)');
hold on;
plot(k, datos_filtrados, 'b', 'LineWidth', 1.5, 'DisplayName', 'Filtrada (FIR N=7)');
plot(k_reducido, x_reducida, 'LineWidth', 2, 'DisplayName', 'Reducida (M=10)');
hold off;
legend('show');

figure;
plot(f_filt, dft_mag_filt, 'b', 'DisplayName','Señal filtrada' );
hold on;
plot(f_filt_red, dft_mag_filt_red, 'r', 'DisplayName','Señal reducida' );
title('Espectro de magnitud de la señal filtrada (Media Móvil N=7)');
xlabel('Frecuencia (ciclos/día)');
ylabel('|X_{filt}(f)|');
xlim([0 Fs/2]);
hold off;
grid on;



% Diagrama de Polos y Ceros
zplane(b, a);
title('Diagrama de Polos y Ceros');
grid on;

figure;
% Diagrama de Bode (Magnitud y Fase)

freqz(b, a, 1024, Fs);
title('Respuesta en Frecuencia (Bode)');
%----------------------------------


%%
% 
% *2.1 Comente brevemente sobre el método elegido para el pre-procesamiento.*

%Se ha seleccionado como preprocesamiento un filtro pasa bajo de media
%movil con el objetivo de cortar la frecuencia de 0.14 c/d (cada 7 días), y
%se ha seleccionado para dicho filtro un tamaño de ventana de 7 unidades,
%para colocar el cero del seno cardinal en la frecuencia a eliminar

%%
% 
% *2.2 ¿Por qué dicha técnica es necesaria y adecuada para este problema específico? (considerando el contenido frecuencial).*

%Esto es necesario porque de no hacerse, al momento de realizar la
%decimación se producirá aliasing en los datos, comprometiendo la
%información

%%
% 
% *2.3 Mencione los criterios utilizados para definir los parámetros del sistema de procesamiento.*



%% 3. Generar serie final y gráficos
% A partir del procesamiento anterior, generar la serie final y grafiquela en 
% el tiempo y la frecuencia. Asegurarse de que la alineación temporal sea correcta 
% respecto a la señal original.

%% 3. Generar serie final y gráficos
% A partir del procesamiento anterior, generar la serie final y grafiquela en 
% el tiempo y la frecuencia. Asegurarse de que la alineación temporal sea correcta 
% respecto a la señal original.


%% 4. Validación de la respuesta
% Comparar su solución con al menos una alternativa que considere incorrecta 
% o subóptima para validar por contraste la suya. 

%Comparemos con la respuesta en caso de utilizar un filtro con ventana N2=10 (Respuesta mas obvia) 

N2=10; % Tamaño de la ventana del filtro Media Móvil

M = 10; % Factor de decimación (1 valor cada 10 días)

b2 = (1/N2) * ones(1, N2); % Coeficientes del numerador (filtro FIR)
a2 = 1;

% Aplicación del filtro a la serie temporal original
datos_filtrados2 = filter(b2, a2, datos);
x_reducida2 = datos_filtrados2(1:round(Fs/fs_new):end);
k_reducido2 = k(1:round(Fs/fs_new):end);
[f_filt_red2, dft_mag_filt_red2, ~, ~, ~] = my_dft(x_reducida2, Fs/M);

figure;
plot(k_reducido, x_reducida, 'LineWidth', 2, 'DisplayName', 'optimal signal');
hold on;
plot(k_reducido, x_reducida2, 'LineWidth', 2, 'DisplayName', 'suboptimal signal');
hold off; 
title('Serie temporal optima y suboptima');
xlabel('Días (k)');
ylabel('Cantidad de turnos x[k]');
legend('optima', 'suboptima')
grid on;


figure;
plot(f_filt_red, dft_mag_filt_red, 'b');
hold on;
plot(f_filt_red2, dft_mag_filt_red2, 'r');
hold off;
title('Espectro de magnitud de la señal suboptima');
xlabel('Frecuencia (ciclos/día)');
ylabel('|X(f)|');
legend('optima', 'suboptima')
xlim([0 fs_new/2]);
grid on;
%% 

%%
% 
% *4.1 Qué efectos negativos produce la alternativa subóptima (en el dominio del tiempo y/o frecuencia).*
%Queda ruido en la señal, hay aliasing, se pierde calidad de información

%%
% 
% *4.2 Por qué su solución propuesta mitiga estos efectos.*
%Se coloca el cero del filtro justo en la frecuencia a mitigar. Mejora la
%respuesta

%% 5. Tasa de Cambio (Derivada) y Punto Fijo
% Se nos comunica que conocer solo la cantidad total de pacientes ya no es suficiente para organizar el consultorio. 
% Ahora necesitamos saber qué tan rápido sube o baja esa cantidad. Esta 
% "velocidad de cambio" de la demanda se calcula directamente usando la derivada matemática.
%%
% Como ingeniero proponés usar *representación en punto fijo* para optimizar el sistema: 
% buscamos aumentar la velocidad de cálculo y minimizar el uso de memoria.

%%
% 
% # Construya la velocidad de cambio de *su señal resultado del ejercicio anterior* en (turno/día). 
% # Analice cómo se distribuyen los valores de su señal (usando un histograma o gráfico). 
% # A partir de esa observación, determine un formato en punto fijo conveniente que ajuste para dicho rango 
% # Indique de su respuesta: N tamaño de la palabra binaria (8,16 o 32 bits) y los m bits para la parte entera, n bits para la parte fraccionaria usando la notación Qm.n (con 1 bit de signo), rango, resolución y ruido cuantización 


%%Completar con los resultados obtenidos:
%%
% * Palabra binaria:
% * Representación:
% * Rango:
% * Resolución:
% * Ruido de cuantización:

%%
% * *Palabra binaria:* 8 bits
% * *Representación*:Q0.7
% * *Rango*: [-1, 0.9921875]
% * *Resolución:*: 0.015625
% * *Ruido de cuantización*: +-0.0078125
%-----------------------------------------

%-----------------------------------------
%% Cálculo de la velocidad 
%-----------------------------------------
% La distancia temporal entre muestras de la serie reducida es dt = 10 días.
dt = 10; 
velocidad = diff(x_reducida) / dt; % Unidades: [turnos / día]
t_reducido = downsample(t, M); 
% Ajustamos el vector de tiempo (al derivar, el vector se achica en 1 muestra)
t_velocidad = t_reducido(2:end);

figure('Name', 'Sección 5: Velocidad de Cambio', 'Color', 'w');
plot(t_velocidad, velocidad, '-o', 'Color', '#D95319', 'LineWidth', 1.5, 'MarkerFaceColor', '#D95319');
title('Velocidad de cambio de la demanda de turnos');
xlabel('Tiempo [días]');
ylabel('Velocidad [turnos/día]');
grid on;

% 2. Histograma para analizar la distribución
figure;
histogram(velocidad, 30, 'FaceColor', '#7E2F8E');
title('Distribución de la Velocidad de Cambio (Turnos/Día)');
xlabel('Velocidad (Turnos/Día)');
ylabel('Frecuencia');
grid on;

%-----------------------------------------
% Verificación de Punto Fijo 
%-----------------------------------------
fprintf('\n--- ANÁLISIS DE PUNTO FIJO ---\n');
senial = velocidad; % Asignamos la derivada a tu variable de análisis

% Definición del formato (Buscamos minimizar memoria: N=8 bits -> 1 signo, m=0, n=7)
m = 0; % Parte Entera 
n = 7; % Parte Fraccionaria 

% Datos físicos de la señal
sig_max = max(senial);
sig_min = min(senial);

% Cálculo del paso mínimo real de la señal (tu lógica)
diferencias = abs(diff(senial));
diferencias_reales = diferencias(diferencias > 0);
salto_minimo = min(diferencias_reales);
disp("salto_minimo")
disp(salto_minimo);

% Datos del punto fijo elegido
limite_inf = -2^m;           % Limite inferior
limite_sup = 2^m - 2^-n;     % Limite Superior
res = 2^-n;                  % Resolución (LSB o Quantum)

% Impresión de reporte
fprintf('Formato elegido: Q%d.%d (Palabra N = %d bits)\n', m, n, m+n+1);
fprintf('Señal real -> Max: %.4f, Min: %.4f, Salto Mínimo: %.4f\n', sig_max, sig_min, salto_minimo);
fprintf('Q%d.%d      -> Rango: [%.4f, %.4f], Resolución: %.4f\n\n', m, n, limite_inf, limite_sup, res);

% Verificación automática
disp('Resultados de validación:');
if salto_minimo - res > 0
    disp(" > Resolución: SUFICIENTE (El bit menos significativo es menor al menor cambio físico)");
else
    disp(" > Resolución: NO suficiente");
end

if limite_sup >= sig_max
    disp(" > Límite superior: SUFICIENTE (No hay overflow positivo)");
else
    disp(" > Límite superior: NO suficiente (Peligro de Overflow)");
end

if limite_inf <= sig_min
    disp(" > Límite inferior: SUFICIENTE (No hay overflow negativo)");
else
    disp(" > Límite inferior: NO suficiente (Peligro de Overflow)");
end







function [f, dft_mag, dft_phase, dft, NFFT] = my_dft(data, Fs)
% my_dft: devuelve la transformada discreta de Fourier de una serie de tiempo.
%
% Si la unidad de data es U, la unidad de la TDF entregada es U/Hz.
%
% INPUT
%   data: NxD serie de tiempo.
%   Fs: 1x1 frecuencia de muestreo de data.
%
% OUTPUT
%   f         : Nx1 vector frecuencia, en Hz.
%   dft_mag   : NxD magnitud de la transformada discreta de Fourier.
%   dft_phase : NxD fase de la transformada discreta de Fourier.
%	dft       : NxD transformada de Fourier discreta, valores complejos.
%   NFFT      : 1x1 cantidad de elementos usados en la FFT.
%
% Version: 003
% Date:    2019/05/08
% Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

[n, m] = size(data);

if (m > n)							% Si data es un vector fila...
    
    data = data'; 					% Trasponer data
    n = m;
end

L = n;                              % Tamaño de la serie de tiempo

NFFT = 2^nextpow2(L);               % Potencia de 2 siguiente al tamaño del vector
f = Fs/2*linspace(0,1,NFFT/2+1);    % Vector frecuencia

dft = fft(data, NFFT) / L;          % Transformada rapida de Fourier

dft = dft(1:NFFT/2+1, :);           % Se toman solo las frecuencias positivas

dft_mag = abs(dft);                 % Magnitud
dft_phase = angle(dft);             % Fase

% dft_r = real(dft);  % Parte real de la transformada discreta de Fourier
% dft_i = imag(dft);  % Parte imaginaria de la transformada discreta de Fourier

end