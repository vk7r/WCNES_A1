% 16-PSK Modulation

% Generate the random sequence
sequence = randi([0 1], 999, 1);

% Create the 16-PSK symbols (4 bits per symbol for 16PSK)
symbol_seq = reshape(sequence, [], 4);  % Reshape into groups of 4 bits

% Convert to decimal indices for 16PSK mapping
symbol_seq_dec = bi2de(symbol_seq, 'left-msb');  % Convert binary to decimal

% 16PSK symbol mapping (phase shifts: 0 to 15, equidistant on the unit circle)
symbol_mapping = exp(1j * (2*pi*(0:15)/16));  % 16PSK symbols (unit circle)

% Map binary sequence to 16-PSK symbols
psk16_symbols = symbol_mapping(symbol_seq_dec + 1);  % +1 due to 1-indexing

% Set SNR values for simulation
SNR_values = [10, 20];

% Loop through different SNR values and simulate the transmission through AWGN channel
for snr = SNR_values
    % Add AWGN to the signal
    received_symbols = awgn(psk16_symbols, snr, 'measured');

    % Plot the received symbols in the complex plane
    figure;
    plot(real(received_symbols), imag(received_symbols), 'bo', 'MarkerSize', 5);
    grid on;
    xlabel('Real Part');
    ylabel('Imaginary Part');
    title(['16PSK Scatter Plot in AWGN Channel (SNR = ', num2str(snr), ' dB)']);
    axis([-2 2 -2 2]);  % Set axis limits
    xticks([-1 0 1]);
    yticks([-1 0 1]);

    hold on;
    % Plot the unit circle for reference
    theta = linspace(0, 2*pi, 100);  % Angle from 0 to 2π
    x_circle = cos(theta);  % x-coordinates of the unit circle
    y_circle = sin(theta);  % y-coordinates of the unit circle
    plot(x_circle, y_circle, 'r--', 'LineWidth', 1.5);
    hold off;
end
