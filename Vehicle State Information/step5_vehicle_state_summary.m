clc;
clear;
close all;

%% Vehicle State Information

vehicleID = 20;
vehicleType = "CAR";

vehicleSpeed = 40;       % km/h
currentLane = "EGO LANE";

distanceAhead = 11.13;   % meters
lateralPosition = 3.14;  % meters

%% Display Vehicle State

disp("======================================");
disp("       VEHICLE STATE SUMMARY");
disp("======================================");

fprintf("Vehicle ID        : %d\n",vehicleID);
fprintf("Vehicle Type      : %s\n",vehicleType);
fprintf("Vehicle Speed     : %.1f km/h\n",vehicleSpeed);
fprintf("Current Lane      : %s\n",currentLane);
fprintf("Distance Ahead    : %.2f m\n",distanceAhead);
fprintf("Lateral Position  : %.2f m\n",lateralPosition);

disp("======================================");

%% Simple Safety Assessment

if distanceAhead < 10
    safetyStatus = "WARNING - VEHICLE TOO CLOSE";
elseif distanceAhead < 20
    safetyStatus = "CAUTION";
else
    safetyStatus = "SAFE DISTANCE";
end

fprintf("Safety Status     : %s\n",safetyStatus);

disp("======================================");