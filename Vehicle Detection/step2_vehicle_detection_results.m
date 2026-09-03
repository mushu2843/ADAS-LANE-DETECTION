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

%% 5. Count Vehicles

numberOfVehicles = size(bboxes,1);

%% 6. Display Information

disp("======================================");
disp("       VEHICLE DETECTION RESULTS");
disp("======================================");

fprintf("Number of vehicles detected: %d\n\n", numberOfVehicles);

for i = 1:numberOfVehicles

    fprintf("Vehicle %d\n",i);
    fprintf("Bounding Box: [%.0f %.0f %.0f %.0f]\n", ...
        bboxes(i,1), ...
        bboxes(i,2), ...
        bboxes(i,3), ...
        bboxes(i,4));

    fprintf("Detection Score: %.2f\n\n",scores(i));

end

disp("======================================");

%% 7. Display Bounding Boxes

labels = strings(numberOfVehicles,1);

for i = 1:numberOfVehicles
    labels(i) = sprintf("Vehicle %.0f",i);
end

detectedImage = insertObjectAnnotation( ...
    frame, ...
    "rectangle", ...
    bboxes, ...
    labels, ...
    "LineWidth",3);

figure;
imshow(detectedImage);
title("ADAS - Vehicle Detection Results");