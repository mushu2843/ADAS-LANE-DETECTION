clc;
clear;
close all;

%% EGO VEHICLE STATE

vehicleType = "CAR";
vehicleSpeed = 40;       % km/h
currentLane = "EGO LANE";

%% Display Ego Vehicle State

disp("======================================");
disp("          EGO VEHICLE STATE");
disp("======================================");

fprintf("Vehicle Type : %s\n",vehicleType);
fprintf("Speed        : %.1f km/h\n",vehicleSpeed);
fprintf("Current Lane : %s\n",currentLane);

disp("======================================");