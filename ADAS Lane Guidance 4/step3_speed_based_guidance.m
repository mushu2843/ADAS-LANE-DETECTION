clc;
clear;
close all;

%% Vehicle Information

vehicleType = "CAR";
vehicleSpeed = 40;       % km/h
currentLane = "EGO LANE";

%% Speed-Based Guidance

if vehicleSpeed < 30
    speedStatus = "LOW SPEED";
    recommendedAction = "NORMAL DRIVING";

elseif vehicleSpeed <= 60
    speedStatus = "MODERATE SPEED";
    recommendedAction = "MAINTAIN LANE";

elseif vehicleSpeed <= 80
    speedStatus = "HIGH SPEED";
    recommendedAction = "MAINTAIN SAFE LANE";

else
    speedStatus = "VERY HIGH SPEED";
    recommendedAction = "REDUCE SPEED";
end

%% Display Result

disp("======================================");
disp("       ADAS SPEED GUIDANCE");
disp("======================================");

fprintf("Vehicle Type       : %s\n",vehicleType);
fprintf("Vehicle Speed      : %.1f km/h\n",vehicleSpeed);
fprintf("Current Lane       : %s\n",currentLane);
fprintf("Speed Status       : %s\n",speedStatus);
fprintf("Recommended Action : %s\n",recommendedAction);

disp("======================================");