%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Function to extract image features using FFT
function [Y] = extractFeatures(image, K_VAL)

% Pad image to a power of 2
[n m] = size(image);
imgpad = padarray(image, [0, floor(128-m)/2], 'replicate', 'both');
imgpad = padarray(imgpad', [0 floor(128-n)/2], 'replicate', 'both')';

% Get frequency Information
Y = fftshift(fft2(imgpad));
[n, m] = size(Y);

YR = real(Y);
YI = imag(Y);
Y = sqrt(YR.^2 + YI.^2)/2;

% Crop FFT image to lower quadrant
T = Y;
Y = T((n/2 - 1):n, (m/2 + 1):m, 1);

% remove higher frequencies. 
T = rot90(Y);
T = tril(T, K_VAL);
Y = rot90(T');