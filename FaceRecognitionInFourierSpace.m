%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Facial Recognition in Fourier Space

image = imread('att_faces/s1/1.pgm');
image2 = imread('att_faces/s1/2.pgm');
image3 = imread('att_faces/s1/3.pgm');
image4 = imread('att_faces/s1/4.pgm');
image5 = imread('att_faces/s1/5.pgm');
image6 = imread('att_faces/s1/6.pgm');
image7 = imread('att_faces/s2/6.pgm');

Y = fftshift(fft2(image)); 
Y = (Y + fftshift(fft2(image2)))/2;
Y = (Y + fftshift(fft2(image3)))/2;
Y = (Y + fftshift(fft2(image4)))/2;
Y = (Y + fftshift(fft2(image5)))/2;

Y = Y/1000000;

Y6 = fftshift(fft2(image6))/1000000;
Y7 = fftshift(fft2(image7))/1000000;



%% Create feature vectors for images.
norm_const = 1000000;
FeatureVectorMap = [];
FeatureVectorMap(40).vec = [];
for i = 1:40
    location = strcat('att_faces/s', int2str(i), '/');
    Y = zeros(128, 128);
   for j = 1:5
       current = strcat(location, int2str(j), '.pgm');
       img = imread(current);
       
       % Pad image to a power of 2
       [n m] = size(img);
       imgpad = padarray(img, [0, floor(128-m)/2], 'replicate', 'both');
       imgpad = padarray(imgpad', [0 floor(128-n)/2], 'replicate', 'both')';
       
       Y = (Y + fftshift(fft2(imgpad)));
   end
   % avg
   Y = Y/5;
   
   [n, m] = size(Y);
   Y = Y((n/2):n, (m/2):m, 1);
   YR = real(Y);
   YI = imag(Y);
   Y_mg = sqrt(YR.^2 + YI.^2)/2;
   FeatureVectorMap(i).vec = Y_mg;
end


%% Test the image
sel = -1;
while (sel > 40 || sel < 1)
    sel = input('Choose an image set between 1-40: ')
end

% Gen random image form test set. 
imgIndex = randi(5) + 5;
location = strcat('att_faces/s', int2str(sel), '/', int2str(imgIndex), '.pgm');

testImage = imread(location);
[n, m] = size(testImage);
imgpad = padarray(testImage, [0, floor(128-m)/2], 'replicate', 'both');
imgpad = padarray(imgpad', [0 floor(128-n)/2], 'replicate', 'both')';

[n, m] = size(imgpad);
testY = fftshift(fft2(imgpad));
testY = testY((n/2):n, (m/2):m, 1);
YR = real(testY);
YI = imag(testY);
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





