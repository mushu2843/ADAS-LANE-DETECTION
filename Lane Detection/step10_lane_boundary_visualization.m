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

%% 3. Caltech camera parameters
focalLength = [309.4362, 344.2161];

principalPoint = [318.9034, 257.5352];

imageSize = [480, 640];

height = 2.1798;

pitch = 14;

%% 4. Create camera model
camIntrinsics = cameraIntrinsics( ...
    focalLength, ...
    principalPoint, ...
    imageSize);

sensor = monoCamera( ...
    camIntrinsics, ...
    height, ...
    'Pitch', pitch);

%% 5. Lane coefficient statistics
laneCoeffMeans = ...
    [-0.0002 0.0002 1.4740 ...
     -0.0002 0.0045 -1.3787];

laneCoeffStds = ...
    [0.0030 0.0766 0.6313 ...
     0.0026 0.0736 0.9846];

%% 6. Read one frame
frame = readFrame(video);

%% 7. Resize for neural network
inputImage = imresize(frame,[227 227]);

%% 8. Neural network prediction
outputs = predict(laneNet,inputImage);

%% 9. Convert prediction to lane coefficients
params = outputs .* laneCoeffStds + laneCoeffMeans;

%% 10. Check detected lanes
isRightLaneFound = abs(params(6)) > 0.5;

isLeftLaneFound = abs(params(3)) > 0.5;

%% 11. Create lane boundaries

if isRightLaneFound
    rightBoundary = parabolicLaneBoundary(params(4:6));
else
    rightBoundary = parabolicLaneBoundary.empty(1,0);
end

if isLeftLaneFound
    leftBoundary = parabolicLaneBoundary(params(1:3));
else
    leftBoundary = parabolicLaneBoundary.empty(1,0);
end

%% 12. Combine boundaries
laneBoundaries = [leftBoundary rightBoundary];

%% 13. Project lanes onto ORIGINAL image
vehicleXPoints = 3:30;

laneImage = insertLaneBoundary( ...
    frame, ...
    laneBoundaries, ...
    sensor, ...
    vehicleXPoints, ...
    'Color','green');

%% 14. Display
figure;

imshow(laneImage);

title("ADAS - Deep Learning Lane Detection");

%% 15. Display status
disp("====================================");
disp("ADAS LANE DETECTION");
disp("====================================");

disp("Left lane detected:");
disp(isLeftLaneFound);

disp("Right lane detected:");
disp(isRightLaneFound);

disp("Lane coefficients:");
disp(params);