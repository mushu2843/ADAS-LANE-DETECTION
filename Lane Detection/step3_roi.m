clc;
clear;
close all;

%% Read the road video
video = VideoReader("road_video.mp4");

%% Read ONLY ONE FRAME
frame = readFrame(video);

%% Convert RGB image to grayscale
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

%% Keep only edges inside ROI
roiEdges = edges & roiMask;

%% FIGURE 1 - Original Frame
figure(1);
imshow(frame);
title("Original Road Frame");

%% FIGURE 2 - Canny Edges
figure(2);
imshow(edges);
title("Canny Edge Detection");

%% FIGURE 3 - ROI Edges
figure(3);
imshow(roiEdges);
title("Region of Interest - ROI");