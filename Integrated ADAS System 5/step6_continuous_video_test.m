clc;
clear;
close all;

%% =====================================
% 1. LOAD VIDEO
% ======================================

videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";

video = VideoReader(videoFile);


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
% 4. LANE PARAMETERS
% ======================================

laneCoeffMeans = [-0.0002 0.0002 1.4740 ...
                  -0.0002 0.0045 -1.3787];

laneCoeffStds = [0.0030 0.0766 0.6313 ...
                 0.0026 0.0736 0.9846];


%% =====================================
% 5. YOLOv4 DETECTOR
% ======================================

detector = yolov4ObjectDetector("csp-darknet53-coco");

vehicleClasses = ["car","bus","truck","motorcycle"];


%% =====================================
% 6. EGO VEHICLE INFORMATION
% ======================================

egoVehicleType = "CAR";
egoVehicleSpeed = 40;
currentLane = "EGO LANE";


%% =====================================
% 7. VIDEO LOOP
% ======================================

figure;

frameNumber = 0;

% Detect vehicles every 5 frames
detectionInterval = 5;

vehicleBoxes = [];
vehicleScores = [];
vehicleLabels = [];

while hasFrame(video)

    %% Read Frame

    frame = readFrame(video);
    frameNumber = frameNumber + 1;


    %% =================================
    % LANE DETECTION
    % ==================================

    inputImage = imresize(frame,[227 227]);

    outputs = predict(laneNet,inputImage);

    params = outputs .* laneCoeffStds + laneCoeffMeans;

    leftBoundary = parabolicLaneBoundary(params(1:3));
    rightBoundary = parabolicLaneBoundary(params(4:6));


    %% =================================
    % DRAW LANES
    % ==================================

    outputFrame = insertLaneBoundary( ...
        frame, ...
        [leftBoundary rightBoundary], ...
        sensor, ...
        3:30, ...
        'Color','green', ...
        'LineWidth',4);


    %% =================================
    % VEHICLE DETECTION
    % ==================================

    if mod(frameNumber-1,detectionInterval) == 0

        [bboxes,scores,labels] = detect( ...
            detector, ...
            frame, ...
            Threshold=0.4);

        isVehicle = ismember( ...
            string(labels), ...
            vehicleClasses);

        vehicleBoxes = bboxes(isVehicle,:);
        vehicleScores = scores(isVehicle);
        vehicleLabels = labels(isVehicle);

    end


    %% =================================
    % DISTANCE ESTIMATION
    % ==================================

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


    %% =================================
    % ADAS DECISION
    % ==================================

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


    %% =================================
    % VEHICLE ANNOTATION
    % ==================================

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


    %% =================================
    % HUD
    % ==================================

    imageHeight = size(outputFrame,1);
    imageWidth = size(outputFrame,2);

    outputFrame = insertShape( ...
        outputFrame, ...
        "FilledRectangle", ...
        [0 0 imageWidth 70], ...
        "Color","black", ...
        "Opacity",0.65);

    outputFrame = insertText( ...
        outputFrame, ...
        [20 15], ...
        "ADAS ACTIVE", ...
        "FontSize",24, ...
        "TextColor","green", ...
        "BoxOpacity",0);

    outputFrame = insertText( ...
        outputFrame, ...
        [imageWidth-180 15], ...
        sprintf("%.0f km/h",egoVehicleSpeed), ...
        "FontSize",24, ...
        "TextColor","white", ...
        "BoxOpacity",0);


    %% =================================
    % BOTTOM INFORMATION
    % ==================================

    outputFrame = insertText( ...
        outputFrame, ...
        [20 imageHeight-100], ...
        sprintf("VEHICLE: %s",egoVehicleType), ...
        "FontSize",18, ...
        "TextColor","white", ...
        "TextBoxColor","black", ...
        "BoxOpacity",0.65);

    outputFrame = insertText( ...
        outputFrame, ...
        [20 imageHeight-60], ...
        sprintf("DISTANCE: %.1f m",distanceAhead), ...
        "FontSize",18, ...
        "TextColor","white", ...
        "TextBoxColor","black", ...
        "BoxOpacity",0.65);


    %% =================================
    % SAFETY STATUS
    % ==================================

    outputFrame = insertText( ...
        outputFrame, ...
        [imageWidth-250 imageHeight-100], ...
        sprintf("STATUS: %s",safetyStatus), ...
        "FontSize",17, ...
        "TextColor","yellow", ...
        "TextBoxColor","black", ...
        "BoxOpacity",0.65);


    %% =================================
    % FINAL ACTION
    % ==================================

    outputFrame = insertText( ...
        outputFrame, ...
        [imageWidth-390 imageHeight-60], ...
        finalAction, ...
        "FontSize",15, ...
        "TextColor","yellow", ...
        "TextBoxColor","black", ...
        "BoxOpacity",0.65);


    %% =================================
    % DISPLAY
    % ==================================

    imshow(outputFrame);

    title(sprintf( ...
        "Integrated ADAS - Frame %d", ...
        frameNumber));

    drawnow;

end