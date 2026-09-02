clc;
clear;
close all;

%% Video
videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";

%% Load pretrained lane network
laneNetFile = matlab.internal.examples.downloadSupportFile( ...
    'gpucoder/cnn_models/lane_detection', ...
    'trainedLaneNet.mat');

load(laneNetFile);

%% Read video
video = VideoReader(videoFile);

%% Read ONE frame
frame = readFrame(video);

%% Resize for network
inputFrame = imresize(frame,[227 227]);

%% Display
figure;
imshow(inputFrame);
title("Caltech Video - Input Frame");