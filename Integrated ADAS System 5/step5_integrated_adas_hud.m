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
% 2. LOAD LANE NETWORK
% ======================================

laneNetFile = matlab.internal.examples.downloadSupportFile( ...
    'gpucoder/cnn_models/lane_detection', ...
    'trainedLaneNet.mat');

load(laneNetFile);


%% =====================================
% 3. CAMERA PARAMETERS
% ======================================

focalLength = [309.4362 344.2161];
principalPoint = [318.9034 257.5352];
imageSize = [480 640];

camIntrinsics = cameraIntrinsics( ...
    focalLength,principalPoint,imageSize);

sensor = monoCamera( ...
    camIntrinsics,2.1798,'Pitch',14);


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
% 6. YOLOv4 VEHICLE DETECTION
% ======================================

detector = yolov4ObjectDetector("csp-darknet53-coco");

vehicleClasses = ["car","bus","truck","motorcycle"];

[bboxes,scores,labels] = detect( ...
    detector,frame,Threshold=0.4);

isVehicle = ismember(string(labels),vehicleClasses);

vehicleBoxes = bboxes(isVehicle,:);
vehicleScores = scores(isVehicle);
vehicleLabels = labels(isVehicle);


%% =====================================
% 7. VEHICLE STATE
% ======================================

egoVehicleType = "CAR";
egoVehicleSpeed = 40;
currentLane = "EGO LANE";


%% =====================================
% 8. DISTANCE ESTIMATION
% ======================================

if ~isempty(vehicleBoxes)

    vehicleBox = vehicleBoxes(1,:);

    x = vehicleBox(1);
    y = vehicleBox(2);
    w = vehicleBox(3);
    h = vehicleBox(4);

    bottomCenterX = x + w/2;
    bottomCenterY = y + h;

    imagePoint = [bottomCenterX bottomCenterY];

    vehiclePoint = imageToVehicle( ...
        sensor,imagePoint);

    distanceAhead = vehiclePoint(1);

else

    distanceAhead = inf;

end


%% =====================================
% 9. ADAS DECISION
% ======================================

if distanceAhead < 10

    safetyStatus = "DANGER";
    finalAction = "BRAKE IMMEDIATELY";

elseif distanceAhead < 20

    safetyStatus = "CAUTION";
    finalAction = "SLOW DOWN / MAINTAIN DISTANCE";

elseif egoVehicleSpeed > 80

    safetyStatus = "WARNING";
    finalAction = "REDUCE SPEED";

else

    safetyStatus = "SAFE";
    finalAction = "NORMAL DRIVING";

end


%% =====================================
% 10. VEHICLE ANNOTATION
% ======================================

if ~isempty(vehicleBoxes)

    vehicleText = strings(size(vehicleBoxes,1),1);

    for i = 1:size(vehicleBoxes,1)

        vehicleText(i) = sprintf( ...
            "%s %.2f", ...
            string(vehicleLabels(i)), ...
            vehicleScores(i));

    end

    outputFrame = insertObjectAnnotation( ...
        outputFrame, ...
        "rectangle", ...
        vehicleBoxes, ...
        vehicleText, ...
        "LineWidth",3);

end


%% =====================================
% 11. HUD BACKGROUND
% ======================================

imageHeight = size(outputFrame,1);
imageWidth = size(outputFrame,2);

outputFrame = insertShape( ...
    outputFrame, ...
    "FilledRectangle", ...
    [0 0 imageWidth 75], ...
    "Color","black", ...
    "Opacity",0.65);


%% =====================================
% 12. TOP HUD
% ======================================

outputFrame = insertText( ...
    outputFrame, ...
    [20 18], ...
    "ADAS ACTIVE", ...
    "FontSize",26, ...
    "TextColor","green", ...
    "BoxOpacity",0);

speedText = sprintf( ...
    "%.0f km/h",egoVehicleSpeed);

outputFrame = insertText( ...
    outputFrame, ...
    [imageWidth-180 18], ...
    speedText, ...
    "FontSize",26, ...
    "TextColor","white", ...
    "BoxOpacity",0);


%% =====================================
% 13. BOTTOM INFORMATION
% ======================================

outputFrame = insertText( ...
    outputFrame, ...
    [20 imageHeight-125], ...
    sprintf("VEHICLE: %s",egoVehicleType), ...
    "FontSize",20, ...
    "TextColor","white", ...
    "TextBoxColor","black", ...
    "BoxOpacity",0.65);


outputFrame = insertText( ...
    outputFrame, ...
    [20 imageHeight-85], ...
    sprintf("CURRENT: %s",currentLane), ...
    "FontSize",20, ...
    "TextColor","white", ...
    "TextBoxColor","black", ...
    "BoxOpacity",0.65);


%% =====================================
% 14. SAFETY STATUS
% ======================================

outputFrame = insertText( ...
    outputFrame, ...
    [imageWidth-250 imageHeight-125], ...
    sprintf("STATUS: %s",safetyStatus), ...
    "FontSize",18, ...
    "TextColor","yellow", ...
    "TextBoxColor","black", ...
    "BoxOpacity",0.65);


%% =====================================
% 15. FINAL ADAS ACTION
% ======================================

outputFrame = insertShape( ...
    outputFrame, ...
    "FilledRectangle", ...
    [imageWidth-390 imageHeight-70 365 50], ...
    "Color","yellow", ...
    "Opacity",0.85);

outputFrame = insertText( ...
    outputFrame, ...
    [imageWidth-375 imageHeight-63], ...
    finalAction, ...
    "FontSize",17, ...
    "TextColor","black", ...
    "BoxOpacity",0);


%% =====================================
% 16. DISPLAY
% ======================================

figure;

imshow(outputFrame);

title("INTEGRATED ADAS SYSTEM");