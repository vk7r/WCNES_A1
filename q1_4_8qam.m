% Define the custom 8-QAM constellation points
constellation = [1 + 0i, 0.5 + 0.5i, 0 + 1i, -0.5 + 0.5i, -1 + 0i, -0.5 - 0.5i, 0 - 1i, 0.5 - 0.5i];

% Number of symbols
numSymbols = 999;

% Generate random data (symbol indices)
% data = randi([0 7], numSymbols, 1); % Random data mapped to 0 to 7 (8 symbols in total)
data = randi([0 1], numSymbols, 1);
symbol_seq = reshape(data, [], 3);  % Reshape into groups of 3 bits
symbol_seq_dec = bi2de(symbol_seq, 'left-msb');  % Convert binary to decimal

% Map the data to the custom constellation points
modSymbols = constellation(symbol_seq_dec + 1); % Add 1 to align data with constellation indices

% Define SNR values for testing
SNR_values = [10, 20];

% Loop over SNR values and generate separate figures
for i = 1:length(SNR_values)
    % Add noise (AWGN) for the current SNR value
    SNR = SNR_values(i);
    rxSymbols = awgn(modSymbols, SNR, 'measured');
    
    % Create a new figure for each SNR
    figure;

    % Plot the received symbols for the current SNR value
    scatter(real(rxSymbols), imag(rxSymbols), 'bo');
    title(['8-QAM Constellation (SNR = ' num2str(SNR) ' dB)']);
    xlabel('Real Part');
    ylabel('Imaginary Part');
    axis equal;
    grid on;

    % Plot the theoretical constellation (ideal points)
    hold on;
    scatter(real(constellation), imag(constellation), 'rx', 'LineWidth', 2);

    % Plot the unit circle (radius = 1) for reference
    theta = linspace(0, 2*pi, 100);  % Angle from 0 to 2π
    x_circle = cos(theta);  % x-coordinates of the unit circle
    y_circle = sin(theta);  % y-coordinates of the unit circle
    plot(x_circle, y_circle, 'r--', 'LineWidth', 1.5);

    % Plot the circle with radius that intersects at 0.5 + 0.5i
    r = sqrt(0.5);  % Radius to hit 0.5 + 0.5i
    x_circle_05_05i = r * cos(theta);  % x-coordinates for the circle
    y_circle_05_05i = r * sin(theta);  % y-coordinates for the circle
    plot(x_circle_05_05i, y_circle_05_05i, 'r--', 'LineWidth', 1.5);

    hold off;
end
