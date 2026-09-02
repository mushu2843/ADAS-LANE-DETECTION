clc;
clear;
close all;

%% STEP 1: Read video
video = VideoReader("C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/road_video.mp4");

%% STEP 2: Read ONE frame only
frame = readFrame(video);

%% STEP 3: Convert to grayscale
grayFrame = rgb2gray(frame);

%% STEP 4: Detect edges
edges = edge(grayFrame, "Canny");

%% STEP 5: Get image size
[height, width, ~] = size(frame);

%% STEP 6: Define road ROI
roiPoints = [
    0.10*width, height;
    0.45*width, 0.55*height;
    0.55*width, 0.55*height;
    0.90*width, height
    ];

%% STEP 7: Create ROI mask
roiMask = poly2mask( ...
    roiPoints(:,1), ...
    roiPoints(:,2), ...
    height, ...
    width);

%% STEP 8: Apply ROI
roiEdges = edges & roiMask;

%% STEP 9: Hough Transform
[H, theta, rho] = hough(roiEdges);

%% STEP 10: Find strong lines
peaks = houghpeaks(H, 20);

%% STEP 11: Extract line segments
lines = houghlines(roiEdges, theta, rho, peaks);

%% STEP 12: Display result
figure(1);
imshow(frame);
title("Step 5 - Filtered Lane Line Candidates");

hold on;

%% Filtering settings
minLineLength = 30;
minSlope = 0.3;
maxSlope = 5.0;

%% STEP 13: Filter detected lines
for k = 1:length(lines)

    point1 = lines(k).point1;
    point2 = lines(k).point2;

    dx = point2(1) - point1(1);
    dy = point2(2) - point1(2);

    if abs(dx) < 1
        continue;
    end

    slope = dy / dx;

    lineLength = sqrt(dx^2 + dy^2);

    if abs(slope) >= minSlope && ...
            abs(slope) <= maxSlope && ...
            lineLength >= minLineLength

        plot( ...
            [point1(1), point2(1)], ...
            [point1(2), point2(2)], ...
            "LineWidth", 3);

    end
end

hold off;