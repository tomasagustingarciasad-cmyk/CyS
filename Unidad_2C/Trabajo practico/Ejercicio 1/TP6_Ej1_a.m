clear, clc, close all
% --- Inicialización de parámetros ---
fs = 10000;          % Frecuencia de muestreo en Hz
t = 0:1/fs:0.1;      % Vector de tiempo (0.1 segundos)
f0 = 100;            % Frecuencia fundamental en Hz
%------------------------------------------------------------------------
% a) Genere una señal senoidal con frecuencia fundamental de 100Hz
x = sin(2*pi*f0*t);
% Gráfica para ver la señal
figure;
plot(t, x, 'LineWidth', 1.5); hold on;
title('Paso a: Señal original');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Señal original');
grid on;
%------------------------------------------------------------------------
% b) Agregue ruido a la señal senoidal con SNR = 15 dB

%SNR_dB = 15;
%x_ruido = awgn(x, SNR_dB, 'measured');

% 1. Calculamos la potencia de la señal original
potencia_seno = var(x); % La varianza es igual a la potencia para señales de media nula
% 2. Calculamos la potencia del ruido necesaria para 15 dB
SNR_dB = 15;
SNR_lineal = 10^(SNR_dB / 10); % Pasamos de dB a escala lineal
potencia_ruido = potencia_seno / SNR_lineal;
% 3. Generamos el vector de ruido blanco gaussiano con la potencia calculada
ruido = sqrt(potencia_ruido) * randn(size(x));
% 4. Sumamos las dos señales
x_ruido = x + ruido;
% Gráfica para comparar ambas señales 
figure;
plot(t, x, 'LineWidth', 1.5); hold on;
plot(t, x_ruido); hold off;
title('Paso b: Señal original vs. Señal con ruido (SNR = 15 dB)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Señal original', 'Señal con ruido');
grid on;

%------------------------------------------------------------------------
% c) Diseñe un filtro leaking integrator (LI) con lambda = 0.7
lambda = 0.7;
b = 1 - lambda;
a = [1, -lambda];
%------------------------------------------------------------------------
% d) Gráfica de respuesta en frecuencia y fase
figure;
freqz(b, a, 1024, fs); 
title('Paso d: Respuesta en frecuencia y fase del filtro LI (\lambda = 0.7)');

% Cálculo de la frecuencia de corte fco
fco = -log(lambda) * fs / pi; % (log() en MATLAB representa el logaritmo natural)
fprintf('La frecuencia de corte fco para lambda=0.7 es: %.2f Hz\n', fco);
%------------------------------------------------------------------------
% e) Determine el cero y el polo del filtro con la función zplane()
figure;
zplane(b, a);
title('Paso e: Diagrama de Polos y Ceros (\lambda = 0.7)');

% Cálculo numérico para la consola
ceros = roots(b);
polos = roots(a);

fprintf('\n Polos y ceros del filtro\n');
disp('Ceros del filtro (raíces del numerador):');
disp(ceros);
disp('Polos del filtro (raíces del denominador):');
disp(polos);
%------------------------------------------------------------------------
% f) Aplique el filtro LI a la señal con ruido usando filter()
x_filtrada = filter(b, a, x_ruido);
%------------------------------------------------------------------------
% g) Grafique la respuesta en el tiempo de las señales original y filtrada
figure;
plot(t, x, 'b', 'LineWidth', 1.5); hold on;
plot(t, x_filtrada, 'r', 'LineWidth', 1.5); hold off;
title('Paso g: Comparación Temporal (Original vs. Filtrada)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Señal Original (100 Hz)', 'Señal Filtrada (\lambda = 0.7)');
grid on;
xlim([0 0.05]); % Hacemos zoom en los primeros 50 ms para comparar mejor
figure;
plot(t, x, 'b', 'LineWidth', 1.5); hold on;
plot(t, x_filtrada, 'r', 'LineWidth', 1.5); hold on;
plot(t, x_ruido); hold off;
title('Paso g: Comparación Temporal (Original vs. Filtrada vs. Con Ruido)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Señal Original (100 Hz)', 'Señal Filtrada (\lambda = 0.7)', 'Señal con ruido sin filtrar');
grid on;
xlim([0 0.05]);
%------------------------------------------------------------------------
% h) Respuesta en frecuencia de las señales original y filtrada usando my_dft()

% Calculamos la DFT para la señal original con ruido
[f_ruido, mag_ruido] = my_dft(x_ruido, fs);

% Calculamos la DFT para la señal filtrada
[f_filt, mag_filt] = my_dft(x_filtrada, fs);

% Armamos la figura con dos subgráficos para comparar
figure;

% Espectro de la señal con ruido (Entrada)
subplot(2,1,1);
plot(f_ruido, mag_ruido, 'b');
title('Paso h: Espectro de magnitud - Señal original con ruido');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([0 500]);
grid on;

% Espectro de la señal filtrada (Salida)
subplot(2,1,2);
plot(f_filt, mag_filt, 'r');
title('Paso h: Espectro de magnitud - Señal filtrada (\lambda = 0.7)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
xlim([0 500]);
grid on;
%------------------------------------------------------------------------

% Armamos la figura con dos subgráficos para comparar
figure;

% Espectro de la señal con ruido (Entrada)
subplot(2,1,1);
plot(f_ruido, mag_ruido, 'b');
title('Paso h: Espectro de magnitud - Señal original con ruido');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
ylim([0 0.02]);
grid on;

% Espectro de la señal filtrada (Salida)
subplot(2,1,2);
plot(f_filt, mag_filt, 'r');
title('Paso h: Espectro de magnitud - Señal filtrada (\lambda = 0.7)');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
ylim([0 0.02]);
grid on;
