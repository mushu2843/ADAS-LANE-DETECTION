clc;
clear;
close all;

%% Read video
video = VideoReader( ...
    "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/road_video.mp4");

%% Read ONE frame
frame = readFrame(video);

%% Grayscale
grayFrame = rgb2gray(frame);

%% Canny
edges = edge(grayFrame, "Canny");

%% Image size
[height, width, ~] = size(frame);

%% ROI
roiPoints = [
    0.10*width, height;
    0.45*width, 0.55*height;
    0.55*width, 0.55*height;
    0.90*width, height
];

roiMask = poly2mask( ...
    roiPoints(:,1), ...
    roiPoints(:,2), ...
    height, ...
    width);

roiEdges = edges & roiMask;

%% Hough Transform
[H, theta, rho] = hough(roiEdges);

peaks = houghpeaks(H, 30);

lines = houghlines( ...
    roiEdges, theta, rho, peaks);

%% Variables
leftLine = [];
rightLine = [];

leftLength = 0;
rightLength = 0;

%% Find left and right lane candidates
for k = 1:length(lines)

    p1 = lines(k).point1;
    p2 = lines(k).point2;

    dx = p2(1) - p1(1);
    dy = p2(2) - p1(2);

    if abs(dx) < 1 || abs(dy) < 1
        continue;
    end

    slope = dy / dx;

    lineLength = sqrt(dx^2 + dy^2);

    %% x position at bottom of image
    xBottom = p1(1) + ...
        (height - p1(2)) * dx / dy;

    %% Ignore short lines
    if lineLength < 50
        continue;
    end

    %% Ignore almost horizontal lines
    if abs(slope) < 0.4
        continue;
    end

    %% Left lane
    if slope < 0 && xBottom < width/2

        if lineLength > leftLength
            leftLine = lines(k);
            leftLength = lineLength;
        end

    end

    %% Right lane
    if slope > 0 && xBottom > width/2

        if lineLength > rightLength
            rightLine = lines(k);
            rightLength = lineLength;
        end

    end

end

%% Calculate lane boundaries at bottom
if ~isempty(leftLine) && ~isempty(rightLine)

    %% LEFT boundary x position
    leftX = leftLine.point1(1) + ...
        (height - leftLine.point1(2)) * ...
        (leftLine.point2(1) - leftLine.point1(1)) / ...
        (leftLine.point2(2) - leftLine.point1(2));

    %% RIGHT boundary x position
    rightX = rightLine.point1(1) + ...
        (height - rightLine.point1(2)) * ...
        (rightLine.point2(1) - rightLine.point1(1)) / ...
        (rightLine.point2(2) - rightLine.point1(2));

    %% Calculate lane center
    laneCenter = (leftX + rightX) / 2;

else

    laneCenter = NaN;

end

%% Display
figure(1);
imshow(frame);

title("Step 7 - Lane Center Detection");

hold on;

%% Draw left lane
if ~isempty(leftLine)

    plot( ...
        [leftLine.point1(1), leftLine.point2(1)], ...
        [leftLine.point1(2), leftLine.point2(2)], ...
        "LineWidth", 4);

end

%% Draw right lane
if ~isempty(rightLine)

    plot( ...
        [rightLine.point1(1), rightLine.point2(1)], ...
        [rightLine.point1(2), rightLine.point2(2)], ...
        "LineWidth", 4);

end

%% Draw lane center
if ~isnan(laneCenter)

    plot( ...
        [laneCenter laneCenter], ...
        [height*0.55 height], ...
        "LineWidth", 4);

    %% Display numerical value
    disp("Lane Center X-coordinate:");
    disp(laneCenter);

end

hold off;