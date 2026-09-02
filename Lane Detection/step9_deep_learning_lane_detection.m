clc;
clear;
close all;

%% 1. Video
videoFile = "C:/Users/musha/OneDrive/Desktop/ADAS_MTech_Project/resources/caltech_cordova1.avi";
video = VideoReader(videoFile);

%% 2. Load pretrained LaneNet
laneNetFile = matlab.internal.examples.downloadSupportFile( ...
    'gpucoder/cnn_models/lane_detection', ...
    'trainedLaneNet.mat');

load(laneNetFile);

%% 3. Read one frame
frame = readFrame(video);

%% 4. Resize image
inputImage = imresize(frame,[227 227]);

%% 5. Neural network prediction
prediction = predict(laneNet,inputImage);

%% 6. Display original image
figure;
imshow(inputImage);
hold on;

%% 7. Display prediction values
disp("Lane prediction:");
disp(prediction);

%% 8. Plot predicted lane points
for k = 1:size(prediction,1)

    x = prediction(k,:);

    % Use image height as Y coordinates
    y = linspace(227,1,6);

    plot(x,y,'LineWidth',3);

end

title("Deep Learning Lane Detection");
hold off;