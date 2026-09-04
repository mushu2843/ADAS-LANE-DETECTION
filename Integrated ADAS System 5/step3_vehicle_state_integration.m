clc;
clear;
close all;

%% =====================================
% 1. LOAD VIDEO
% ======================================

videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";

video = VideoReader(videoFile);

frame = readFrame(video);


%% =====================================
% 2. VEHICLE DETECTOR
% ======================================

detector = yolov4ObjectDetector("csp-darknet53-coco");

vehicleClasses = ["car","bus","truck","motorcycle"];


%% =====================================
% 3. DETECT VEHICLES
% ======================================

[bboxes,scores,labels] = detect( ...
    detector, ...
    frame, ...
    Threshold=0.4);


%% =====================================
% 4. KEEP VEHICLES ONLY
% ======================================

isVehicle = ismember( ...
    string(labels), ...
    vehicleClasses);

vehicleBoxes = bboxes(isVehicle,:);
vehicleScores = scores(isVehicle);
vehicleLabels = labels(isVehicle);


%% =====================================
% 5. CHECK DETECTION
% ======================================

if isempty(vehicleBoxes)

    disp("No vehicles detected.");

    return;

end


%% =====================================
% 6. CAMERA PARAMETERS
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
% 7. SELECT FIRST VEHICLE
% ======================================

vehicleBox = vehicleBoxes(1,:);

x = vehicleBox(1);
y = vehicleBox(2);
w = vehicleBox(3);
h = vehicleBox(4);


%% =====================================
% 8. BOTTOM-CENTER OF VEHICLE
% ======================================

bottomCenterX = x + w/2;
bottomCenterY = y + h;

imagePoint = [bottomCenterX bottomCenterY];


%% =====================================
% 9. IMAGE TO VEHICLE COORDINATES
% ======================================

vehiclePoint = imageToVehicle( ...
    sensor, ...
    imagePoint);


distanceAhead = vehiclePoint(1);
lateralPosition = vehiclePoint(2);


%% =====================================
% 10. VEHICLE POSITION
% ======================================

imageCenter = imageSize(2)/2;

if bottomCenterX < imageCenter-80

    position = "LEFT";

elseif bottomCenterX > imageCenter+80

    position = "RIGHT";

else

    position = "CENTER";

end


%% =====================================
% 11. EGO VEHICLE INFORMATION
% ======================================

egoVehicleType = "CAR";
egoVehicleSpeed = 40;


%% =====================================
% 12. DISPLAY RESULTS
% ======================================

disp("==============================================");
disp("       INTEGRATED VEHICLE STATE");
disp("==============================================");

fprintf("Ego Vehicle Type    : %s\n",egoVehicleType);
fprintf("Ego Vehicle Speed   : %.1f km/h\n",egoVehicleSpeed);

disp("----------------------------------------------");

fprintf("Detected Vehicle    : %s\n",string(vehicleLabels(1)));
fprintf("Confidence          : %.2f\n",vehicleScores(1));

fprintf("Image Position      : %s\n",position);

fprintf("Distance Ahead      : %.2f m\n",distanceAhead);
fprintf("Lateral Position    : %.2f m\n",lateralPosition);

disp("==============================================");


%% =====================================
% 13. DISPLAY VEHICLE
% ======================================

labelText = sprintf( ...
    "%s | %.2f m", ...
    string(vehicleLabels(1)), ...
    distanceAhead);

outputFrame = insertObjectAnnotation( ...
    frame, ...
    "rectangle", ...
    vehicleBox, ...
    labelText, ...
    "LineWidth",3);

outputFrame = insertText( ...
    outputFrame, ...
    [20 20], ...
    sprintf("Speed: %.1f km/h",egoVehicleSpeed), ...
    "FontSize",22, ...
    "TextColor","yellow", ...
    "BoxOpacity",0.6);

figure;

imshow(outputFrame);

title("Integrated ADAS - Vehicle State");