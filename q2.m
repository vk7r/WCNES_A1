% Modulation orders
M_values = [8, 16, 16]; % Array to store modulation orders (8-PSK, 16-PSK, 16-QAM)
k_values = log2(M_values); % Bits per symbol for each modulation scheme

EbNoVec = (5:15)'; % Eb/No values (dB)
numSymPerFrame = 100; % Number of symbols per frame
berEst = zeros(length(EbNoVec), length(M_values)); % BER storage for each modulation scheme

% Define the 16-QAM constellation
constellation = [-3 - 3i, -1 - 3i, 1 - 3i, 3 - 3i, -3 - 1i, -1 - 1i, 1 - 1i, 3 - 1i, -3 + 1i, -1 + 1i, 1 + 1i, 3 + 1i, -3 + 3i, -1 + 3i, 1 + 3i, 3 + 3i] / 3;

for n = 1:length(EbNoVec)
    for m = 1:length(M_values)
        M = M_values(m); % Modulation order
        k = k_values(m); % Bits per symbol
        snrdB = EbNoVec(n) + 10*log10(k);
        numErrs = 0;
        numBits = 0;

        while numErrs < 200 && numBits < 1e7
            dataIn = randi([0 1], numSymPerFrame, k);
            dataSym = bi2de(dataIn);

            if M == 16 && m == 3
                modSig = constellation(dataSym + 1);
            else
                modSig = pskmod(dataSym, M);
            end

            rxSig = awgn(modSig, snrdB);

            if M == 16 && m == 3
                rxSym = qam_demod(rxSig, constellation);
            else
                rxSym = pskdemod(rxSig, M);
            end

            dataOut = de2bi(rxSym, k);
            nErrors = biterr(dataIn, dataOut);

            numErrs = numErrs + nErrors;
            numBits = numBits + numSymPerFrame * k;
        end

        berEst(n, m) = numErrs / numBits;
        fprintf("M = %d, snrdB: %.6f berEst: %.6f \n \t numErrs: %d numBits: %d\n\n", M, snrdB, berEst(n, m), numErrs, numBits);
    end
end

% Plot BER curves
figure;
semilogy(EbNoVec, berEst(:,1), 'o-', 'DisplayName', '8-PSK');
hold on;
semilogy(EbNoVec, berEst(:,2), 's-', 'DisplayName', '16-PSK');
semilogy(EbNoVec, berEst(:,3), 'd-', 'DisplayName', '16-QAM');
hold off;

xlabel('Eb/No (dB)');
ylabel('BER');
title('BER vs. Eb/No for 8-PSK, 16-PSK & 16-QAM');
legend('show');
grid on;

function rxSym = qam_demod(rxSig, constellation)
    numSymbols = length(rxSig);
    rxSym = zeros(numSymbols, 1);
    for i = 1:numSymbols
        [~, rxSym(i)] = min(abs(rxSig(i) - constellation));
        rxSym(i) = rxSym(i) - 1;
    end
end
