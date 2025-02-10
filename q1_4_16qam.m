% Define the custom 16-QAM constellation points, ensuring the outer values are at maximum x or i (1)
constellation = [-3 - 3i, -1 - 3i, 1 - 3i, 3 - 3i, 
                 -3 - 1i, -1 - 1i, 1 - 1i, 3 - 1i, 
                 -3 + 1i, -1 + 1i, 1 + 1i, 3 + 1i, 
                 -3 + 3i, -1 + 3i, 1 + 3i, 3 + 3i];

% Scale the points to make the outermost points have maximum x or i = 1
scale_factor = 3;  % Divide by 3 to ensure outermost points (3, 3i) become (1, 1i)

% Hardcode the scaled constellation points
constellation = constellation / scale_factor;

% Number of symbols
numSymbols = 1000;

% Generate random data (symbol indices)
data = randi([0 1], 1000, 1);
symbol_seq = reshape(data, [], 4);  % Reshape into groups of 4 bits
% disp(size(symbol_seq))
seq_dec = bi2de(symbol_seq);
% Map the data to the custom constellation points
modSymbols = constellation(seq_dec + 1); % Add 1 to align data with constellation indices
% disp(length(dataSym));

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
    title(['16-QAM Constellation (SNR = ' num2str(SNR) ' dB)']);
    xlabel('Real Part');
    ylabel('Imaginary Part');
    axis equal;
    grid on;

    % Plot the theoretical constellation (ideal points)
    hold on;
    scatter(real(constellation), imag(constellation), 'rx', 'LineWidth', 2);
    hold off;
end
