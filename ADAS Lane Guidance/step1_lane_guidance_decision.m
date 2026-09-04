clc;
clear;
close all;

%% Vehicle Information

vehicleType = "CAR";
vehicleSpeed = 40;
currentLane = "EGO LANE";

%% Lane Recommendation

if vehicleType == "CAR"

    if vehicleSpeed <= 40
        recommendedLane = "LEFT";
    elseif vehicleSpeed <= 80
        recommendedLane = "CENTER";
    else
        recommendedLane = "RIGHT";
    end

elseif vehicleType == "BUS"

    if vehicleSpeed <= 50
        recommendedLane = "LEFT";
    else
        recommendedLane = "CENTER";
    end

elseif vehicleType == "TRUCK"

    if vehicleSpeed <= 50
        recommendedLane = "LEFT";
    else
        recommendedLane = "CENTER";
    end

else
    recommendedLane = "UNKNOWN";
end

%% Display Result

disp("======================================");
disp("       ADAS LANE GUIDANCE");
disp("======================================");

fprintf("Vehicle Type      : %s\n",vehicleType);
fprintf("Vehicle Speed     : %.1f km/h\n",vehicleSpeed);
fprintf("Current Lane      : %s\n",currentLane);
fprintf("Recommended Lane  : %s\n",recommendedLane);

disp("======================================");

%% Guidance Decision

if currentLane == recommendedLane
    guidance = "LANE OK";
else
    guidance = "LANE CHANGE RECOMMENDED";
end

fprintf("ADAS Guidance     : %s\n",guidance);

disp("======================================");