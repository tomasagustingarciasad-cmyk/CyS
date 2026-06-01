num1 = 8.41;
den1=[1, 5.8, 8.41];
roots([1, 5.8, 8.41])
sys1 = tf(num1, den1);

num2 = 2.777777777777;
den2=[1, 2, 2.7777777777777];
roots([1, 2, 2.7777777777777])
sys2 = tf(num2, den2);
step(sys1)
title ('Respuesta al Escalón - Caso A (\zeta = 1, \omega_n = 2.9)')
grid on; 
hold on;
step(sys2)
title ('Respuesta al Escalón - Caso B (\zeta = 0.6, \omega_n = 1.666666666666666)')
grid on;