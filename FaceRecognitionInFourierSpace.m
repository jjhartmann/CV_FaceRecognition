%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Facial Recognition in Fourier Space

%% Create feature vectors for images.
norm_const = 1000000;
K_VAL = -52;
TR_DATA = 8;
FeatureVectorMap = [];
FeatureVectorMap(40).vec = [];
for i = 1:40
    location = strcat('att_faces/s', int2str(i), '/');
    Y(5).val = zeros(128, 128);
   for j = 1:TR_DATA
       current = strcat(location, int2str(j), '.pgm');
       img = imread(current);
 
        % Extract FFT Features
       Y(j).val = extractFeatures(img, K_VAL);
   end

   FeatureVectorMap(i).vec = Y;
end


%% Test the image
sel = -1;
while (sel > 40 || sel < 1)
    sel = input('Choose an image set between 1-40: ')
end

% Gen random image form test set. 
imgIndex = randi(TR_DATA) + abs(10 - TR_DATA);
location = strcat('att_faces/s', int2str(sel), '/', int2str(imgIndex), '.pgm');

testImage = imread(location);
Y_mg = extractFeatures(testImage, K_VAL);

min = inf;
index = -1;
 for i = 1:40
    for j = 1:TR_DATA
        euclideanDistance = norm(real(Y_mg) - real(FeatureVectorMap(i).vec(j).val));
        if (min > euclideanDistance)
            min = euclideanDistance;
            index = i;
        end
    end
end

disp(['Answer is image set: ', int2str(index)])


%% TEST ALL
errorcount = 0;
successcount = 0;
for k = 1:40
    % Gen random image form test set. 
    imgIndex = randi(TR_DATA) + abs(10 - TR_DATA);
    location = strcat('att_faces/s', int2str(k), '/', int2str(imgIndex), '.pgm');
   
    testImage = imread(location);
    Y_mg = extractFeatures(testImage, K_VAL);

    min = inf;
    index = -1;
     for i = 1:40
        for j = 1:TR_DATA
            euclideanDistance = norm(real(Y_mg) - real(FeatureVectorMap(i).vec(j).val));
            if (min > euclideanDistance)
                min = euclideanDistance;
                index = i;
            end
        end
    end

    disp(['Image test: ', int2str(k),'  Image set: ', int2str(index)])
    
    if k == index
        successcount = successcount + 1;
    else
        errorcount = errorcount + 1;
    end
end

disp([' '])
disp([' '])
disp(['STATS FOR TEST ALL'])
disp([' '])
disp(['ERROR:   ' int2str(errorcount)])
disp(['SUCCESS: ' int2str(successcount)])



