% Modulation order M
M = 2;

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
        dataIn = randi([0 1],numSymPerFrame,k);
        dataSym = bi2de(dataIn);

        %----------------------------------------------------------------    
        % Your modulator here:
        modSig = pskmod(dataSym, M); % PSK Modulation Example
       


        % Pass through AWGN channel:
        rxSig = awgn(modSig, snrdB); % Additive White Gaussian Noise with 
                                     % increasing snrdB
        
                                     
        % Your demodulator here:
        rxSym = pskdemod(rxSig, M); % PSK Demodulation Example
        
        %----------------------------------------------------------------

        % Convert received symbols to bits
        dataOut = de2bi(rxSym,k);
        
        % Calculate the number of bit errors
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



