% Modulation order M for 8-PSK and 16-PSK
M_values = [8, 16]; % Array to store both modulation orders

EbNoVec = (5:15)'; % Eb/No values (dB)
numSymPerFrame = 100; % Number of symbols per frame
berEst8PSK = zeros(size(EbNoVec)); % BER for 8-PSK
berEst16PSK = zeros(size(EbNoVec)); % BER for 16-PSK

for m = 1:length(M_values)
    M = M_values(m); % Modulation order (8-PSK or 16-PSK)
    k = log2(M); % Bits per symbol

    % Loop over the different Eb/No values
    for n = 1:length(EbNoVec)
        % Convert Eb/No to SNR
        snrdB = EbNoVec(n) + 10*log10(k);
        % Reset the error and bit counters
        numErrs = 0;
        numBits = 0;

        while numErrs < 200 && numBits < 1e7
            % Generate binary data and convert to symbols
            dataIn = randi([0 1], numSymPerFrame, k);
            dataSym = bi2de(dataIn);

            % Modulation (PSK)
            modSig = pskmod(dataSym, M); % PSK Modulation

            % Pass through AWGN channel
            rxSig = awgn(modSig, snrdB); % Additive White Gaussian Noise

            % Demodulation (PSK)
            rxSym = pskdemod(rxSig, M); % PSK Demodulation

            % Convert received symbols back to bits
            dataOut = de2bi(rxSym, k);

            % Calculate the number of bit errors
            nErrors = biterr(dataIn, dataOut);

            % Increment the error and bit counters
            numErrs = numErrs + nErrors;
            numBits = numBits + numSymPerFrame * k;
        end
        % Estimate the BER for this Eb/No
        if M == 8
            berEst8PSK(n) = numErrs / numBits; % Store BER for 8-PSK
        else
            berEst16PSK(n) = numErrs / numBits; % Store BER for 16-PSK
        end
        
        fprintf("M = %d, snrdB: %.6f berEst: %.6f \n \t numErrs: %d numBits: %d\n\n", ...
                M, snrdB, berEst8PSK(n), numErrs, numBits);
    end
end

% Plot the BER curves for 8-PSK and 16-PSK using semilogy
figure;
semilogy(EbNoVec, berEst8PSK, 'o-', 'DisplayName', '8-PSK'); % Plot for 8-PSK
hold on;
semilogy(EbNoVec, berEst16PSK, 's-', 'DisplayName', '16-PSK'); % Plot for 16-PSK
hold off;

% Customize the plot
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER vs. Eb/No for 8-PSK and 16-PSK');
legend('show');
grid on;



% Custom 16-QAM demodulation function to find closest constellation point
function rxSym = qam_demod(rxSig, constellation)
    % Ensure that the output vector matches the size of the received signal
    numSymbols = length(rxSig);  
    rxSym = zeros(numSymbols, 1);  % Pre-allocate the output for symbol indices

    % Loop through each received symbol
    for i = 1:numSymbols
        % Calculate the distance from each received symbol to the constellation points
        % disp(abs(rxSig(i) - constellation));
        distances = abs(rxSig(i) - constellation);  % This gives a vector of distances
        % disp(distances);
        % disp(min(distances));

        % Find the index of the closest constellation point
        [~, rxSym(i)] = min(distances);  % rxSym(i) stores the index of the closest point (dec number 1 to 16)
        rxSym(i) = rxSym(i) - 1;
    end
    % disp(rxSym);
end