% Modulation order M
M = 8;

k = log2(M); % Bits per symbol
EbNoVec = (5:15)'; % Eb/No values (dB)
numSymPerFrame = 333; % Number of QAM symbols per frame
berEst = zeros(size(EbNoVec));

%-----------------------------

display("starting loop...")
for n = 1:length(EbNoVec)
    % Convert Eb/No to SNR
    snrdB = EbNoVec(n) + 10*log10(k);
    % Reset the error and bit counters
    numErrs = 0;
    numBits = 0;
    
    while numErrs < 200 && numBits < 1e7
        % Generate binary data and convert to symbols
        %dataIn = randi([0 1],numSymPerFrame,k);
        %dataSym = bi2de(dataIn);

           
        % Your modulator here:
        %---------- MY 8PSK MODULATOR ------------------
        % Generate the random sequence
        sequence = randi([0 1], 999, 1);
        
        % Create the 8-PSK symbols (3 bits per symbol for 8PSK)
        symbol_seq = reshape(sequence, [], 3);  % Reshape into groups of 3 bits
        dataIn = symbol_seq;


        % Convert to decimal indices for 8PSK mapping
        symbol_seq_dec = bi2de(symbol_seq, 'left-msb');  % Convert binary to decimal
        
        % 8PSK symbol mapping (phase shifts: 0 to 7, equidistant on the unit circle)
        symbol_mapping = exp(1j * (2*pi*(0:7)/8));  % 8PSK symbols (unit circle)
        
        % Map binary sequence to 8PSK symbols
        psk8_symbols = symbol_mapping(symbol_seq_dec + 1);  % +1 due to 1-indexing

        
        %---------------------------------------------------------------- 

        % Pass through AWGN channel:
        rxSig = awgn(psk8_symbols, snrdB); % Additive White Gaussian Noise with increasing snrdB

        % Your demodulator here:
        rxSym = pskdemod(rxSig, M); % PSK Demodulation Example
        %----------------------------------------------------------------

        % Convert received symbols to bits
        dataOut = de2bi(rxSym,k);
        
        %fprintf("Input Len: %i,  Output Len: %i\n",length(dataIn), length(dataOut))
        % Calculate the number of bit errors
        nErrors = biterr(dataIn,dataOut);


        % Increment the error and bit counters
        numErrs = numErrs + nErrors;
        numBits = numBits + numSymPerFrame*k;


    end
    % Estimate the BERnn
    berEst(n) = numErrs/numBits;
end
fprintf("Num Bits: %i\n", numBits);
fprintf("Num Errs: %i\n", numErrs);

% Plot the BER vs Eb/No
% figure;
% semilogy(EbNoVec, berEst, 'o-', 'LineWidth', 2, 'MarkerSize', 6);
% grid on;
% xlabel('Eb/No (dB)');
% ylabel('Bit Error Rate (BER)');
% title('BER vs. Eb/No for PSK Modulation');
% legend('Estimated BER');
