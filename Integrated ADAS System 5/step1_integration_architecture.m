clc;
clear;
close all;

%% =====================================
% INTEGRATED ADAS SYSTEM ARCHITECTURE
% ======================================

disp("==============================================");
disp("        INTEGRATED ADAS SYSTEM");
disp("==============================================");

%% Lane Detection Output

laneDetectionStatus = "LANE DETECTED";

%% Vehicle Detection Output

numberOfVehicles = 3;

%% Ego Vehicle State

vehicleType = "CAR";
vehicleSpeed = 40;
currentLane = "EGO LANE";

%% Relative Vehicle State

nearestVehicleDistance = 11.13;
nearestVehiclePosition = "LEFT";

%% ADAS Decision

safetyStatus = "CAUTION";
recommendedLane = "LEFT";
finalADASAction = "SLOW DOWN / MAINTAIN DISTANCE";

%% Display Integrated Information

disp("----------------------------------------------");

fprintf("Lane Detection       : %s\n",laneDetectionStatus);
fprintf("Vehicles Detected    : %d\n",numberOfVehicles);

disp("----------------------------------------------");

fprintf("Vehicle Type         : %s\n",vehicleType);
fprintf("Vehicle Speed        : %.1f km/h\n",vehicleSpeed);
fprintf("Current Lane         : %s\n",currentLane);

disp("----------------------------------------------");

fprintf("Nearest Vehicle      : %.2f m\n",nearestVehicleDistance);
fprintf("Vehicle Position     : %s\n",nearestVehiclePosition);

disp("----------------------------------------------");

fprintf("Safety Status        : %s\n",safetyStatus);
fprintf("Recommended Lane     : %s\n",recommendedLane);
fprintf("FINAL ADAS ACTION    : %s\n",finalADASAction);

disp("==============================================");