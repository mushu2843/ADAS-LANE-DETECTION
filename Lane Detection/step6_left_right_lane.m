clc;
clear;
close all;

%% STEP 1: Read video
video = VideoReader( ...
    "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/road_video.mp4");

%% STEP 2: Read ONE frame
frame = readFrame(video);

%% STEP 3: Convert to grayscale
grayFrame = rgb2gray(frame);

%% STEP 4: Canny edge detection
edges = edge(grayFrame, "Canny");

%% STEP 5: Get image size
[height, width, ~] = size(frame);

%% STEP 6: Define Region of Interest
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

%% STEP 10: Find Hough peaks
peaks = houghpeaks(H, 30);

%% STEP 11: Extract lines
lines = houghlines( ...
    roiEdges, ...
    theta, ...
    rho, ...
    peaks);

%% Variables for left and right lanes
leftLine = [];
rightLine = [];

leftLength = 0;
rightLength = 0;

%% STEP 12: Examine every detected line
for k = 1:length(lines)

    point1 = lines(k).point1;
    point2 = lines(k).point2;

    %% Calculate dx and dy
    dx = point2(1) - point1(1);
    dy = point2(2) - point1(2);

    %% Avoid vertical lines
    if abs(dx) < 1
        continue;
    end

    %% Calculate slope
    slope = dy / dx;

    %% Calculate line length
    lineLength = sqrt(dx^2 + dy^2);

    %% Calculate approximate x position at bottom of image
    xBottom = point1(1) + ...
        (height - point1(2)) * dx / dy;

    %% Ignore very short lines
    if lineLength < 50
        continue;
    end

    %% Ignore nearly horizontal lines
    if abs(slope) < 0.4
        continue;
    end

    %% LEFT lane candidate
    if slope < 0 && xBottom < width/2

        if lineLength > leftLength
            leftLine = lines(k);
            leftLength = lineLength;
        end

    end

    %% RIGHT lane candidate
    if slope > 0 && xBottom > width/2

        if lineLength > rightLength
            rightLine = lines(k);
            rightLength = lineLength;
        end

    end

end

%% STEP 13: Display original frame
figure(1);
imshow(frame);

title("Step 6 - Left and Right Lane Detection");

hold on;

%% Draw LEFT lane
if ~isempty(leftLine)

    plot( ...
        [leftLine.point1(1), leftLine.point2(1)], ...
        [leftLine.point1(2), leftLine.point2(2)], ...
        "LineWidth", 5);

end

%% Draw RIGHT lane
if ~isempty(rightLine)

    plot( ...
        [rightLine.point1(1), rightLine.point2(1)], ...
        [rightLine.point1(2), rightLine.point2(2)], ...
        "LineWidth", 5);

end

hold off;