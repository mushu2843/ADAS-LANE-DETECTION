clc;
clear;
close all;

%% Vehicle Information

vehicleType = "CAR";
vehicleSpeed = 40;

%% Vehicle-Type Based Guidance

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
disp("      VEHICLE TYPE GUIDANCE");
disp("======================================");

fprintf("Vehicle Type      : %s\n",vehicleType);
fprintf("Vehicle Speed     : %.1f km/h\n",vehicleSpeed);
fprintf("Recommended Lane  : %s\n",recommendedLane);

disp("======================================");