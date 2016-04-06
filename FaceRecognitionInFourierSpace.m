%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Facial Recognition in Fourier Space

%% Create feature vectors for images.
norm_const = 1000000;
K_VAL = -15;
FeatureVectorMap = [];
FeatureVectorMap(40).vec = [];
for i = 1:40
    location = strcat('att_faces/s', int2str(i), '/');
    Y = zeros(128, 128);
   for j = 1:8
       current = strcat(location, int2str(j), '.pgm');
       img = imread(current);
       
       % Pad image to a power of 2
       [n m] = size(img);
       imgpad = padarray(img, [0, floor(128-m)/2], 'replicate', 'both');
       imgpad = padarray(imgpad', [0 floor(128-n)/2], 'replicate', 'both')';
       
       Y = (Y + fftshift(fft2(imgpad)));
   end
   % avg
   Y = Y/8;
   
   [n, m] = size(Y);
   Y = Y((n/2):n, (m/2):m, 1);
   
   % remove higher frequencies. 
   T = rot90(Y);
   T = tril(T, K_VAL);
   T = rot90(T');
   
   YR = real(T);
   YI = imag(T);
   Y_mg = sqrt(YR.^2 + YI.^2)/2;
   FeatureVectorMap(i).vec = Y_mg;
end


%% Test the image
sel = -1;
while (sel > 40 || sel < 1)
    sel = input('Choose an image set between 1-40: ')
end

% Gen random image form test set. 
imgIndex = randi(2) + 8;
location = strcat('att_faces/s', int2str(sel), '/', int2str(imgIndex), '.pgm');

testImage = imread(location);
[n, m] = size(testImage);
imgpad = padarray(testImage, [0, floor(128-m)/2], 'replicate', 'both');
imgpad = padarray(imgpad', [0 floor(128-n)/2], 'replicate', 'both')';

[n, m] = size(imgpad);
testY = fftshift(fft2(imgpad));
testY = testY((n/2):n, (m/2):m, 1);

% remove higher frequencies. 
T = rot90(testY);
T = tril(T, K_VAL);
T = rot90(T');

YR = real(T);
YI = imag(T);
Y_mg = sqrt(YR.^2 + YI.^2)/2;

min = inf;
index = -1;
 for i = 1:40
    euclideanDistance = norm(real(Y_mg) - real(FeatureVectorMap(i).vec));
    if (min > euclideanDistance)
        min = euclideanDistance;
        index = i;
    end
end

disp(['Answer is image set: ', int2str(index)])


%% TEST

for i = 1:40
    % Gen random image form test set. 
    imgIndex = randi(2) + 8;
    location = strcat('att_faces/s', int2str(i), '/', int2str(imgIndex), '.pgm');

    testImage = imread(location);
    [n, m] = size(testImage);
    imgpad = padarray(testImage, [0, floor(128-m)/2], 'replicate', 'both');
    imgpad = padarray(imgpad', [0 floor(128-n)/2], 'replicate', 'both')';

    [n, m] = size(imgpad);
    testY = fftshift(fft2(imgpad));
    testY = testY((n/2):n, (m/2):m, 1);

    % remove higher frequencies. 
    T = rot90(testY);
    T = tril(T, K_VAL);
    T = rot90(T');

    YR = real(T);
    YI = imag(T);
    Y_mg = sqrt(YR.^2 + YI.^2)/2;

    min = inf;
    index = -1;
     for j = 1:40
        euclideanDistance = norm(real(Y_mg) - real(FeatureVectorMap(j).vec));
        if (min > euclideanDistance)
            min = euclideanDistance;
            index = j;
        end
    end

    disp(['Image test: ', int2str(i),'  Image set: ', int2str(index)])
end


