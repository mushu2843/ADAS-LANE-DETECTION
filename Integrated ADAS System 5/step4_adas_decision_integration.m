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
% 2. YOLOv4 VEHICLE DETECTION
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
% 3. CHECK VEHICLE DETECTION
% ======================================

if isempty(vehicleBoxes)

    disp("No vehicles detected.");
    return;

end


%% =====================================
% 4. CAMERA PARAMETERS
% ======================================

focalLength = [309.4362 344.2161];
principalPoint = [318.9034 257.5352];
imageSize = [480 640];

camIntrinsics = cameraIntrinsics( ...
    focalLength,principalPoint,imageSize);

sensor = monoCamera( ...
    camIntrinsics,2.1798,'Pitch',14);


%% =====================================
% 5. SELECT FIRST VEHICLE
% ======================================

vehicleBox = vehicleBoxes(1,:);

x = vehicleBox(1);
y = vehicleBox(2);
w = vehicleBox(3);
h = vehicleBox(4);

bottomCenterX = x + w/2;
bottomCenterY = y + h;

imagePoint = [bottomCenterX bottomCenterY];


%% =====================================
% 6. ESTIMATE DISTANCE
% ======================================

vehiclePoint = imageToVehicle(sensor,imagePoint);

distanceAhead = vehiclePoint(1);


%% =====================================
% 7. EGO VEHICLE INFORMATION
% ======================================

vehicleType = "CAR";
vehicleSpeed = 40;
currentLane = "EGO LANE";


%% =====================================
% 8. ADAS SAFETY DECISION
% ======================================

if distanceAhead < 10

    safetyStatus = "DANGER";
    finalAction = "BRAKE IMMEDIATELY";

elseif distanceAhead < 20

    safetyStatus = "CAUTION";
    finalAction = "SLOW DOWN / MAINTAIN DISTANCE";

elseif vehicleSpeed > 80

    safetyStatus = "WARNING";
    finalAction = "REDUCE SPEED";

else

    safetyStatus = "SAFE";
    finalAction = "NORMAL DRIVING";

end


%% =====================================
% 9. DISPLAY DECISION
% ======================================

disp("==============================================");
disp("       INTEGRATED ADAS DECISION");
disp("==============================================");

fprintf("Ego Vehicle Type    : %s\n",vehicleType);
fprintf("Ego Vehicle Speed   : %.1f km/h\n",vehicleSpeed);

disp("----------------------------------------------");

fprintf("Detected Vehicle    : %s\n", ...
    string(vehicleLabels(1)));

fprintf("Detection Confidence: %.2f\n", ...
    vehicleScores(1));

fprintf("Distance Ahead      : %.2f m\n", ...
    distanceAhead);

fprintf("Current Lane        : %s\n", ...
    currentLane);

disp("----------------------------------------------");

fprintf("Safety Status       : %s\n", ...
    safetyStatus);

fprintf("FINAL ADAS ACTION   : %s\n", ...
    finalAction);

disp("==============================================");


%% =====================================
% 10. DISPLAY RESULT ON IMAGE
% ======================================

labelText = sprintf( ...
    "%s | %.1f m", ...
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
    sprintf("ADAS: %s",finalAction), ...
    "FontSize",20, ...
    "TextColor","yellow", ...
    "BoxOpacity",0.6);

figure;

imshow(outputFrame);

title("Integrated ADAS Decision");