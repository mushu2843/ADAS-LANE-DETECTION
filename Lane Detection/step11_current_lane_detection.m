clc;
clear;
close all;

%% 1. Video
videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";

video = VideoReader(videoFile);

%% 2. Load pretrained LaneNet
laneNetFile = matlab.internal.examples.downloadSupportFile( ...
    'gpucoder/cnn_models/lane_detection', ...
    'trainedLaneNet.mat');

load(laneNetFile);

%% 3. Camera parameters
focalLength = [309.4362 344.2161];
principalPoint = [318.9034 257.5352];
imageSize = [480 640];

camIntrinsics = cameraIntrinsics( ...
    focalLength, ...
    principalPoint, ...
    imageSize);

sensor = monoCamera( ...
    camIntrinsics, ...
    2.1798, ...
    'Pitch',14);

%% 4. Lane coefficient statistics
laneCoeffMeans = ...
    [-0.0002 0.0002 1.4740 ...
     -0.0002 0.0045 -1.3787];

laneCoeffStds = ...
    [0.0030 0.0766 0.6313 ...
     0.0026 0.0736 0.9846];

%% 5. Read one frame
frame = readFrame(video);

%% 6. Resize for neural network
inputImage = imresize(frame,[227 227]);

%% 7. Neural network prediction
outputs = predict(laneNet,inputImage);

%% 8. Convert output to lane coefficients
params = outputs .* laneCoeffStds + laneCoeffMeans;

%% 9. Create lane boundaries
leftBoundary = parabolicLaneBoundary(params(1:3));
rightBoundary = parabolicLaneBoundary(params(4:6));

%% 10. Calculate lateral lane positions
% X = distance in front of vehicle (meters)
xVehicle = 20;

leftY = computeBoundaryModel(leftBoundary,xVehicle);
rightY = computeBoundaryModel(rightBoundary,xVehicle);

%% 11. Calculate lane center in vehicle coordinates
laneCenterY = (leftY + rightY) / 2;

%% 12. Vehicle lateral position
% Vehicle center is Y = 0
vehicleY = 0;

%% 13. Determine current lane status

if vehicleY >= min(leftY,rightY) && ...
        vehicleY <= max(leftY,rightY)

    currentLane = "EGO LANE";

else

    currentLane = "OUTSIDE DETECTED LANE";

end

%% 14. Lane center offset
laneOffset = vehicleY - laneCenterY;

%% 15. Display detected lanes
laneImage = insertLaneBoundary( ...
    frame, ...
    [leftBoundary rightBoundary], ...
    sensor, ...
    3:30, ...
    'Color','green');

%% 16. Display image
figure;
imshow(laneImage);
title("ADAS - Current Lane Detection");

%% 17. Display results
disp("======================================");
disp("       ADAS CURRENT LANE STATUS");
disp("======================================");

disp("Left boundary Y at 20 m:");
disp(leftY);

disp("Right boundary Y at 20 m:");
disp(rightY);

disp("Lane center Y:");
disp(laneCenterY);

disp("Vehicle lateral position:");
disp(vehicleY);

disp("Lane offset:");
disp(laneOffset);

disp("Current Lane:");
disp(currentLane);

disp("======================================");