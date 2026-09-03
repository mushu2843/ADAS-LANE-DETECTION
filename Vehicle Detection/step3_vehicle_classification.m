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

[bboxes, scores, labels] = detect(detector, frame, Threshold=0.4);

%% 5. Select Vehicles Only

vehicleClasses = ["car","bus","truck","motorcycle"];

isVehicle = ismember(string(labels), vehicleClasses);

vehicleBoxes = bboxes(isVehicle,:);
vehicleScores = scores(isVehicle);
vehicleLabels = labels(isVehicle);

%% 6. Display Vehicle Information

disp("======================================");
disp("       VEHICLE CLASSIFICATION");
disp("======================================");

numberOfVehicles = size(vehicleBoxes,1);

fprintf("Vehicles detected: %d\n\n",numberOfVehicles);

for i = 1:numberOfVehicles

    fprintf("Vehicle %d\n",i);
    fprintf("Type: %s\n",string(vehicleLabels(i)));
    fprintf("Confidence: %.2f\n\n",vehicleScores(i));

end

disp("======================================");

%% 7. Display Results on Image

detectedImage = insertObjectAnnotation( ...
    frame, ...
    "rectangle", ...
    vehicleBoxes, ...
    vehicleLabels);

figure;
imshow(detectedImage);
title("ADAS - Vehicle Type Classification");