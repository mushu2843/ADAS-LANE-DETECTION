clc;
clear;
close all;

%% Vehicle Information

vehicleType = "CAR";
vehicleSpeed = 40;

currentLane = "EGO LANE";
recommendedLane = "LEFT";

%% Lane Change Decision

if recommendedLane == "UNKNOWN"

    warning = "NO GUIDANCE AVAILABLE";

elseif currentLane == recommendedLane

    warning = "LANE OK";

else

    warning = "LANE CHANGE ADVISED";

end

%% Display Result

disp("======================================");
disp("       ADAS LANE CHANGE WARNING");
disp("======================================");

fprintf("Vehicle Type      : %s\n",vehicleType);
fprintf("Vehicle Speed     : %.1f km/h\n",vehicleSpeed);
fprintf("Current Lane      : %s\n",currentLane);
fprintf("Recommended Lane  : %s\n",recommendedLane);

disp("--------------------------------------");

fprintf("ADAS Warning      : %s\n",warning);

disp("======================================");