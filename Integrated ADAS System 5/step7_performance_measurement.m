clc;
clear;
close all;

%% =====================================
% PERFORMANCE MEASUREMENT
% ======================================

videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";

video = VideoReader(videoFile);

%% Load Lane Network

laneNetFile = matlab.internal.examples.downloadSupportFile( ...
    'gpucoder/cnn_models/lane_detection', ...
    'trainedLaneNet.mat');

load(laneNetFile);

%% Camera Parameters

focalLength = [309.4362 344.2161];
principalPoint = [318.9034 257.5352];
imageSize = [480 640];

camIntrinsics = cameraIntrinsics( ...
    focalLength,principalPoint,imageSize);

sensor = monoCamera( ...
    camIntrinsics,2.1798,'Pitch',14);

%% YOLO Detector

detector = yolov4ObjectDetector("csp-darknet53-coco");

vehicleClasses = ["car","bus","truck","motorcycle"];

%% Parameters

laneCoeffMeans = [-0.0002 0.0002 1.4740 ...
                  -0.0002 0.0045 -1.3787];

laneCoeffStds = [0.0030 0.0766 0.6313 ...
                 0.0026 0.0736 0.9846];

detectionInterval = 5;

frameCount = 0;
detectionCount = 0;

totalTime = 0;

%% =====================================
% PROCESS VIDEO
% ======================================

while hasFrame(video)

    frame = readFrame(video);

    frameCount = frameCount + 1;

    tic;

    %% Lane Detection

    inputImage = imresize(frame,[227 227]);

    outputs = predict(laneNet,inputImage);

    params = outputs .* laneCoeffStds + laneCoeffMeans;

    leftBoundary = parabolicLaneBoundary(params(1:3));
    rightBoundary = parabolicLaneBoundary(params(4:6));

    %% Vehicle Detection

    if mod(frameCount-1,detectionInterval) == 0

        [bboxes,scores,labels] = detect( ...
            detector, ...
            frame, ...
            Threshold=0.4);

        isVehicle = ismember( ...
            string(labels),vehicleClasses);

        vehicleBoxes = bboxes(isVehicle,:);

        detectionCount = detectionCount + 1;

    end

    %% End Timing

    frameTime = toc;

    totalTime = totalTime + frameTime;

end

%% =====================================
% CALCULATE PERFORMANCE
% ======================================

averageFrameTime = totalTime / frameCount;

averageFPS = 1 / averageFrameTime;

averageDetectionTime = ...
    totalTime / detectionCount;

%% =====================================
% DISPLAY RESULTS
% ======================================

disp("==============================================");
disp("        ADAS PERFORMANCE MEASUREMENT");
disp("==============================================");

fprintf("Frames Processed       : %d\n",frameCount);

fprintf("Vehicle Detection Runs : %d\n",detectionCount);

fprintf("Detection Interval     : Every %d frames\n", ...
    detectionInterval);

fprintf("Average Frame Time     : %.4f seconds\n", ...
    averageFrameTime);

fprintf("Approximate FPS        : %.2f frames/sec\n", ...
    averageFPS);

fprintf("==============================================");