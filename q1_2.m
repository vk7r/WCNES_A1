
% Generate the random sequence
sequence = randi([0 1], 1000,1);


% create the QPSK symbols (2 bits - 00)
symbol_seq = reshape(sequence, [], 2);

% convert to decimal
symbol_seq_dec = bi2de(symbol_seq, 'left-msb') +1; % +1 due to 1-indexing
symbol_mapping = [1, 1i, -1, -1i]
qpsk_symbols = symbol_mapping(symbol_seq_dec);

% disp(qpsk_symbols)

% send through AWGN channel with 10 and 20 dB

SNR_values = [10,20];

for snr = SNR_values
    received_symbols = awgn(qpsk_symbols, snr,'measured');

    figure;
    plot(real(received_symbols), imag(received_symbols), 'bo', 'MarkerSize', 5);
    grid on;
    xlabel('Real Part');
    ylabel('Imaginary Part');
    title(['QPSK Scatter Plot in AWGN Channel (SNR = ', num2str(snr), ' dB)']);
    axis([-2 2 -2 2]); % Set axis limits
    xticks([-1 0 1]);
    yticks([-1 0 1]);

    hold on;
    theta = linspace(0, 2*pi, 100); % Angle from 0 to 2π
    x_circle = cos(theta); % x-coordinates
    y_circle = sin(theta); % y-coordinates
    plot(x_circle, y_circle, 'r--', 'LineWidth', 1.5);
    hold off;
    
end