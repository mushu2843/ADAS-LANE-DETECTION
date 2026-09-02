clc;
clear;
close all;

%% Read the road video
video = VideoReader("road_video.mp4");

%% Read ONLY ONE FRAME
frame = readFrame(video);

%% Convert RGB to grayscale
grayFrame = rgb2gray(frame);

%% Canny edge detection
edges = edge(grayFrame, "Canny");

%% Get image dimensions
[height, width, ~] = size(frame);

%% Define Region of Interest
roiPoints = [
    0.10*width, height;
    0.45*width, 0.55*height;
    0.55*width, 0.55*height;
    0.90*width, height
    ];

%% Create ROI mask
roiMask = poly2mask( ...
    roiPoints(:,1), ...
    roiPoints(:,2), ...
    height, ...
    width);

%% Apply ROI
roiEdges = edges & roiMask;

%% Hough Transform
[H, theta, rho] = hough(roiEdges);

%% Find strongest Hough peaks
peaks = houghpeaks(H, 10);

%% Find line segments
lines = houghlines( ...
    roiEdges, ...
    theta, ...
    rho, ...
    peaks);

%% Display original frame
figure(1);
imshow(frame);
title("Original Road Frame");

%% Display ROI edges
figure(2);
imshow(roiEdges);
title("ROI Edges");

%% Display Hough lines
figure(3);
imshow(frame);
title("Hough Transform - Detected Lines");

hold on;

%% Draw detected lines
for k = 1:length(lines)

    xy = [lines(k).point1; lines(k).point2];

    plot( ...
        xy(:,1), ...
        xy(:,2), ...
        "LineWidth", 2);

end

hold off;