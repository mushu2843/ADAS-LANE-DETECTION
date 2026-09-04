clc;
clear;
close all;

%% 1. Camera Parameters

focalLength = [309.4362 344.2161];
principalPoint = [318.9034 257.5352];
imageSize = [480 640];

camIntrinsics = cameraIntrinsics( ...
    focalLength, ...
    principalPoint, ...
    imageSize);

sensor = monoCamera( ...
    camIntrinsics, ...
    2.1798, ...
    'Pitch',14);

%% 2. Example Vehicle Bounding Box

% Format:
% [X Y Width Height]

vehicleBox = [213 180 40 60];

%% 3. Find Bottom-Center of Vehicle

x = vehicleBox(1);
y = vehicleBox(2);
w = vehicleBox(3);
h = vehicleBox(4);

bottomCenterX = x + w/2;
bottomCenterY = y + h;

imagePoint = [bottomCenterX bottomCenterY];

%% 4. Convert Image Point to Vehicle Coordinates

vehiclePoint = imageToVehicle(sensor,imagePoint);

%% 5. Extract Distance

distanceAhead = vehiclePoint(1);
lateralPosition = vehiclePoint(2);

%% 6. Display Results

disp("======================================");
disp("       RELATIVE DISTANCE ESTIMATION");
disp("======================================");

fprintf("Vehicle Image X       : %.1f pixels\n",bottomCenterX);
fprintf("Vehicle Image Y       : %.1f pixels\n",bottomCenterY);

fprintf("Distance Ahead        : %.2f meters\n",distanceAhead);
fprintf("Lateral Position      : %.2f meters\n",lateralPosition);

disp("======================================");

%% 7. Display Vehicle Point

figure;

imshow(zeros(480,640,3));

hold on;

plot(bottomCenterX,bottomCenterY, ...
    "o", ...
    "MarkerSize",12, ...
    "LineWidth",3);

xline(320,"LineWidth",2);

text(bottomCenterX+10,bottomCenterY, ...
    sprintf("Vehicle: %.2f m",distanceAhead), ...
    "FontSize",14);

title("Relative Vehicle Distance");

hold off;