% Audio Compression Using FFT Magnitude Thresholding

% Read the input audio file
[inputAudio, fs] = audioread('sp.mp3');

% Perform FFT on the audio signal
audio_fft = fft(inputAudio);

% Compute magnitude spectrum
audio_mag = abs(audio_fft);

% Set compression parameters
compressionFactor = 0.001;  % Adjust compression factor (higher means more compression)
threshold = compressionFactor * max(audio_mag);

% Apply magnitude thresholding for compression
compressed_mag = audio_mag .* (audio_mag > threshold);

% Reconstruct the compressed signal using inverse FFT
compressed_audio_fft = audio_fft .* (compressed_mag ./ (audio_mag + eps));  
% To avoid division by zero we add eps
compressed_audio = ifft(compressed_audio_fft);

% Normalize the compressed audio signal
compressed_audio = compressed_audio / max(abs(compressed_audio));

% Write the compressed audio to a new file
audiowrite('output_compressed_audio.mp3', compressed_audio, fs);

% Calculate compressed file size
audioFileSize = dir('sp.mp3').bytes/(1024*1024);
compressedFileSize = dir('output_compressed_audio.mp3').bytes/(1024*1024);

% Calculate compression ratio and percentage
compressionRatio = audioFileSize / compressedFileSize;
compressionPercentage = (1 - 1/compressionRatio) * 100;

% Plot original and compressed audio waveforms
t = (0:length(inputAudio)-1) / fs;
figure;
subplot(2,1,1);
plot(t, inputAudio);
title('Original Audio');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, compressed_audio);
title('Compressed Audio');
xlabel('Time (s)');
ylabel('Amplitude');

% Plotting frequency spectrum
figure;
subplot(2,1,1);
plot(audio_mag);
title('Spectrum of original signal');
xlabel('f');
ylabel('magnitude');

subplot(2,1,2);
plot(abs(compressed_audio_fft));
title('Spectrum of compressed signal');
xlabel('f');
ylabel('magnitude');

disp(['Original file size: ',num2str(audioFileSize),' MB']);
disp(['Compressed file size: ',num2str(compressedFileSize),' MB']);
disp(['Compression percentage: ',num2str(compressionPercentage),'%']);