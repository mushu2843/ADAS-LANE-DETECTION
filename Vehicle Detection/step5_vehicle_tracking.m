clc;
clear;
close all;

%% 1. Load Road Video

videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";
video = VideoReader(videoFile);

%% 2. Create YOLO v4 Detector

detector = yolov4ObjectDetector("csp-darknet53-coco");

%% 3. Vehicle Classes

vehicleClasses = ["car","bus","truck","motorcycle"];

%% 4. Tracking Parameters

nextID = 1;

trackedCenters = zeros(0,2);
trackedIDs = zeros(0,1);

maxDistance = 60;

%% 5. Create Figure

figure;

%% 6. Process Video Frames

frameNumber = 0;

while hasFrame(video)

    frame = readFrame(video);
    frameNumber = frameNumber + 1;

    %% Detect Vehicles

    [bboxes, scores, labels] = detect( ...
        detector, frame, Threshold=0.4);

    %% Select Vehicles Only

    isVehicle = ismember(string(labels), vehicleClasses);

    bboxes = bboxes(isVehicle,:);
    scores = scores(isVehicle);
    labels = labels(isVehicle);

    %% Calculate Vehicle Centers

    centers = zeros(size(bboxes,1),2);

    for i = 1:size(bboxes,1)

        centers(i,1) = bboxes(i,1) + bboxes(i,3)/2;
        centers(i,2) = bboxes(i,2) + bboxes(i,4)/2;

    end

    %% Match New Detections With Existing Tracks

    newCenters = zeros(0,2);
    newIDs = zeros(0,1);

    usedTracks = false(size(trackedIDs));

    for i = 1:size(centers,1)

        if isempty(trackedCenters)

            matchedID = 0;

        else

            distances = sqrt( ...
                (trackedCenters(:,1)-centers(i,1)).^2 + ...
                (trackedCenters(:,2)-centers(i,2)).^2);

            distances(usedTracks) = inf;

            [minimumDistance,index] = min(distances);

            if minimumDistance < maxDistance
                matchedID = trackedIDs(index);
                usedTracks(index) = true;
            else
                matchedID = 0;
            end

        end

        %% Create New ID

        if matchedID == 0

            matchedID = nextID;
            nextID = nextID + 1;

        end

        newCenters(end+1,:) = centers(i,:);
        newIDs(end+1,1) = matchedID;

    end

    %% Update Tracks

    trackedCenters = newCenters;
    trackedIDs = newIDs;

    %% Create Labels

    trackingLabels = strings(size(bboxes,1),1);

    for i = 1:size(bboxes,1)

        trackingLabels(i) = sprintf( ...
            "ID %d - %s", ...
            trackedIDs(i), ...
            string(labels(i)));

    end

    %% Draw Bounding Boxes

    outputFrame = insertObjectAnnotation( ...
        frame, ...
        "rectangle", ...
        bboxes, ...
        trackingLabels, ...
        "LineWidth",3);

    %% Display Frame Number

    outputFrame = insertText( ...
        outputFrame, ...
        [20 20], ...
        sprintf("Frame: %d",frameNumber), ...
        "FontSize",20, ...
        "BoxOpacity",0.6);

    %% Show Frame

    imshow(outputFrame);
    title("ADAS - Multi-Vehicle Tracking");

    drawnow;

end