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
    Y = zeros(112, 92);
   for j = 1:5
       current = strcat(location, int2str(j), '.pgm');
       img = imread(current);
       Y = (Y + fftshift(fft2(img)))/2;
   end
   [n, m] = size(Y);
   FeatureVectorMap(i).vec = Y((n/2 - 1):n, (m/2 - 1):m, 1)/norm_const;
end





