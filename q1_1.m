
symbols = [1, 1i, -1, -1i]

figure;
plot(real(symbols), imag(symbols), 'bo', 'MarkerSize', 10, 'LineWidth', 2);
text(real(symbols) + 0.1, imag(symbols), {'1','i','-1','-i'});
grid on; hold on;

theta = linspace(0, 2*pi, 100); % Angle from 0 to 2π
x_circle = cos(theta); % x-coordinates
y_circle = sin(theta); % y-coordinates
plot(x_circle, y_circle, 'r--', 'LineWidth', 1.5);

xlabel('Real');
ylabel('Imaginary');
title("QPSK Modulation in complex plane");

axis([-2, 2, -2, 2]);
