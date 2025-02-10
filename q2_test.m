




% Modulation order M
M = 16;

k = log2(M); % Bits per symbol
EbNoVec = (5:15)'; % Eb/No values (dB)
numSymPerFrame = 100; % Number of QAM symbols per frame
berEst = zeros(size(EbNoVec));

for n = 1:length(EbNoVec)
    % Convert Eb/No to SNR
    snrdB = EbNoVec(n) + 10*log10(k);
    % Reset the error and bit counters
    numErrs = 0;
    numBits = 0;
    
    while numErrs < 200 && numBits < 1e7
        % Generate binary data and convert to symbols
        % dataIn = randi([0 1],numSymPerFrame,k);
        % dataSym = bi2de(dataIn);

        %----------------------------------------------------------------    
        % Your modulator here:
       % My 16 QAM modulation implementation ------------------------------------
        % Define the custom 16-QAM constellation points, ensuring the outer values are at maximum x or i (1)
        constellation = [-3 - 3i, -1 - 3i, 1 - 3i, 3 - 3i, -3 - 1i, -1 - 1i, 1 - 1i, 3 - 1i, -3 + 1i, -1 + 1i, 1 + 1i, 3 + 1i, -3 + 3i, -1 + 3i, 1 + 3i, 3 + 3i];
        
        
        % Scale the points to make the outermost points have maximum x or i = 1
        scale_factor = 3;  % Divide by 3 to ensure outermost points (3, 3i) become (1, 1i)
        
        % Hardcode the scaled constellation points
        constellation = constellation / scale_factor;

        % disp(size(constellation)); % Should be 1x16 matrix

        
        % Number of symbols
        numSymbols = 1000;
        
        % Generate random data (symbol indices)
        % Generate the random sequence
        data = randi([0 1], 1000, 1);
        symbol_seq = reshape(sequence, [], 4);  % Reshape into groups of 4 bits
        
        % Map the data to the custom constellation points
        modSymbols = constellation(dataSym + 1); % Add 1 to align data with constellation indices
        
        %--------------------------------------------------------------------------------------


        % Pass through AWGN channel:
        rxSig = awgn(modSymbols, snrdB); % Additive White Gaussian Noise with increasing snrdB

                                   
        % Your demodulator here:
        rxSym = qam_demod(rxSig, constellation);
        
        %----------------------------------------------------------------

        % Convert received symbols to bits
        % disp(size(rxSym));
        % disp(k);
        % disp(rxSym);
        dataOut = de2bi(rxSym,k);
        % disp(dataIn);
        
        % Calculate the number of bit errors
        % fprintf("size in: %i,  size out: %i\n", size(dataIn), size(dataOut));
        % disp(dataOut);
        nErrors = biterr(dataIn,dataOut);
        
        % Increment the error and bit counters
        numErrs = numErrs + nErrors;
        numBits = numBits + numSymPerFrame*k;
    end
    % Estimate the BER
    berEst(n) = numErrs/numBits;
    
    fprintf("snrdB: %.6f berEst: %.6f " + ...
        " \n \t numErrs: %d numBits: %d\n\n", snrdB, berEst(n), numErrs, numBits);

end

% Plot the BER curve for 8-QPSK using semilogy
figure;
semilogy(EbNoVec, berEst, 'o-', 'DisplayName', '16 QAM'); % Plot 8-QPSK
xlabel('Eb/No (dB)');
ylabel('BER');
title('BER vs. Eb/No for 16 QAM');
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

