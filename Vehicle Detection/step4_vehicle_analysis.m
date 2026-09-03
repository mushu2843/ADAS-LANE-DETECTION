clc;
clear;
close all;

%% 1. Load Road Video

videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";
video = VideoReader(videoFile);

%% 2. Create YOLO v4 Detector

detector = yolov4ObjectDetector("csp-darknet53-coco");

%% 3. Read One Frame

frame = readFrame(video);

%% 4. Detect Objects

[bboxes, scores, labels] = detect( ...
    detector, frame, Threshold=0.4);

%% 5. Select Vehicles

vehicleClasses = ["car","bus","truck","motorcycle"];

isVehicle = ismember(string(labels), vehicleClasses);

vehicleBoxes = bboxes(isVehicle,:);
vehicleScores = scores(isVehicle);
vehicleLabels = labels(isVehicle);

numberOfVehicles = size(vehicleBoxes,1);

%% 6. Image Center

imageWidth = size(frame,2);
imageCenter = imageWidth / 2;

%% 7. Display Vehicle Analysis

disp("======================================");
disp("          VEHICLE ANALYSIS");
disp("======================================");

fprintf("Total vehicles detected: %d\n\n",numberOfVehicles);

for i = 1:numberOfVehicles

    % Bounding box
    x = vehicleBoxes(i,1);
    y = vehicleBoxes(i,2);
    w = vehicleBoxes(i,3);
    h = vehicleBoxes(i,4);

    % Vehicle center
    centerX = x + w/2;
    centerY = y + h/2;

    % Determine image position
    if centerX < imageCenter - 80
        position = "LEFT";
    elseif centerX > imageCenter + 80
        position = "RIGHT";
    else
        position = "CENTER";
    end

    fprintf("Vehicle %d\n",i);
    fprintf("Type       : %s\n",string(vehicleLabels(i)));
    fprintf("Confidence : %.2f\n",vehicleScores(i));
    fprintf("Center X   : %.1f pixels\n",centerX);
    fprintf("Center Y   : %.1f pixels\n",centerY);
    fprintf("Position   : %s\n",position);
    fprintf("--------------------------------------\n");

end

%% 8. Display Results

detectedImage = insertObjectAnnotation( ...
    frame, ...
    "rectangle", ...
    vehicleBoxes, ...
    vehicleLabels, ...
    "LineWidth",3);

figure;
imshow(detectedImage);
title("ADAS - Vehicle Analysis");