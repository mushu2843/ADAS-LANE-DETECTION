clc;
clear;
close all;

%% 1. Load Road Video

videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";
video = VideoReader(videoFile);

%% 2. Create Vehicle Detector

detector = vehicleDetectorYOLOv2();

%% 3. Read One Frame

frame = readFrame(video);

%% 4. Detect Vehicles

[bboxes, scores] = detect(detector, frame);

%% 5. Display Results

detectedImage = insertObjectAnnotation( ...
    frame, ...
    "rectangle", ...
    bboxes, ...
    "vehicle", ...
    "LineWidth",3);

figure;
imshow(detectedImage);
title("ADAS - Vehicle Detection");