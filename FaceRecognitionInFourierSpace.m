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





