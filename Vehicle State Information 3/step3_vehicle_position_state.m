clc;
clear;
close all;

%% VEHICLE POSITION STATE

% Example detected vehicle information
vehicleID = 20;
vehicleType = "CAR";

centerX = 195.5;
centerY = 195.5;

%% Camera/Image Information

imageWidth = 640;
imageCenter = imageWidth / 2;

%% Determine Vehicle Position

if centerX < imageCenter - 80
    position = "LEFT";
elseif centerX > imageCenter + 80
    position = "RIGHT";
else
    position = "CENTER";
end

%% Display Vehicle Position State

disp("======================================");
disp("        VEHICLE POSITION STATE");
disp("======================================");

fprintf("Vehicle ID     : %d\n",vehicleID);
fprintf("Vehicle Type   : %s\n",vehicleType);
fprintf("Center X       : %.1f pixels\n",centerX);
fprintf("Center Y       : %.1f pixels\n",centerY);
fprintf("Image Position : %s\n",position);

disp("======================================");

%% Visualize Position

figure;

imshow(zeros(480,640,3));

hold on;

xline(imageCenter,"LineWidth",2);

plot(centerX,centerY,"o","MarkerSize",12,"LineWidth",3);

text(centerX+15,centerY, ...
    "Detected Vehicle", ...
    "FontSize",14);

title("Vehicle Position State");

hold off;