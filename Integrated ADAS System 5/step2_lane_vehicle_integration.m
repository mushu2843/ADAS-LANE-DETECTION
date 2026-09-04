clc;
clear;
close all;

%% =====================================
% 1. LOAD ROAD VIDEO
% ======================================

videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";

video = VideoReader(videoFile);

frame = readFrame(video);


%% =====================================
% 2. LOAD LANE DETECTION NETWORK
% ======================================

laneNetFile = matlab.internal.examples.downloadSupportFile( ...
    'gpucoder/cnn_models/lane_detection', ...
    'trainedLaneNet.mat');

load(laneNetFile);


%% =====================================
% 3. LANE CAMERA PARAMETERS
% ======================================

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


%% =====================================
% 4. LANE DETECTION
% ======================================

laneCoeffMeans = [-0.0002 0.0002 1.4740 ...
                  -0.0002 0.0045 -1.3787];

laneCoeffStds = [0.0030 0.0766 0.6313 ...
                 0.0026 0.0736 0.9846];

inputImage = imresize(frame,[227 227]);

outputs = predict(laneNet,inputImage);

params = outputs .* laneCoeffStds + laneCoeffMeans;

leftBoundary = parabolicLaneBoundary(params(1:3));
rightBoundary = parabolicLaneBoundary(params(4:6));


%% =====================================
% 5. DRAW LANE BOUNDARIES
% ======================================

outputFrame = insertLaneBoundary( ...
    frame, ...
    [leftBoundary rightBoundary], ...
    sensor, ...
    3:30, ...
    'Color','green', ...
    'LineWidth',4);


%% =====================================
% 6. LOAD YOLOv4 VEHICLE DETECTOR
% ======================================

detector = yolov4ObjectDetector("csp-darknet53-coco");

vehicleClasses = ["car","bus","truck","motorcycle"];


%% =====================================
% 7. VEHICLE DETECTION
% ======================================

[bboxes,scores,labels] = detect( ...
    detector, ...
    frame, ...
    Threshold=0.4);


%% =====================================
% 8. KEEP ONLY VEHICLES
% ======================================

isVehicle = ismember( ...
    string(labels), ...
    vehicleClasses);

vehicleBoxes = bboxes(isVehicle,:);
vehicleScores = scores(isVehicle);
vehicleLabels = labels(isVehicle);


%% =====================================
% 9. CREATE VEHICLE LABELS
% ======================================

vehicleText = strings(size(vehicleBoxes,1),1);

for i = 1:size(vehicleBoxes,1)

    vehicleText(i) = sprintf( ...
        "%s %.2f", ...
        string(vehicleLabels(i)), ...
        vehicleScores(i));

end


%% =====================================
% 10. DRAW VEHICLES
% ======================================

outputFrame = insertObjectAnnotation( ...
    outputFrame, ...
    "rectangle", ...
    vehicleBoxes, ...
    vehicleText, ...
    "LineWidth",3);


%% =====================================
% 11. DISPLAY SYSTEM INFORMATION
% ======================================

outputFrame = insertText( ...
    outputFrame, ...
    [20 20], ...
    "LANE + VEHICLE DETECTION", ...
    "FontSize",24, ...
    "TextColor","yellow", ...
    "BoxOpacity",0.6);


outputFrame = insertText( ...
    outputFrame, ...
    [20 55], ...
    sprintf("Vehicles Detected: %d",size(vehicleBoxes,1)), ...
    "FontSize",20, ...
    "TextColor","white", ...
    "BoxOpacity",0.6);


%% =====================================
% 12. DISPLAY RESULT
% ======================================

figure;

imshow(outputFrame);

title("Integrated ADAS - Lane + Vehicle Detection");