clc;
clear;
close all;

%% Vehicle Information

vehicleSpeed = 40;       % km/h
distanceAhead = 11.13;   % meters

%% Safe Distance Decision

if distanceAhead < 10
    safetyStatus = "DANGER";
    warning = "BRAKE / SLOW DOWN";

elseif distanceAhead < 20
    safetyStatus = "CAUTION";
    warning = "MAINTAIN SAFE DISTANCE";

else
    safetyStatus = "SAFE";
    warning = "DISTANCE OK";
end

%% Display Result

disp("======================================");
disp("       ADAS SAFE DISTANCE");
disp("======================================");

fprintf("Vehicle Speed    : %.1f km/h\n",vehicleSpeed);
fprintf("Distance Ahead   : %.2f m\n",distanceAhead);
fprintf("Safety Status    : %s\n",safetyStatus);
fprintf("ADAS Warning     : %s\n",warning);

disp("======================================");