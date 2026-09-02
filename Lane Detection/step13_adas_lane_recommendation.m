clc;
clear;

%% VEHICLE INPUT

vehicleType = "CAR";
vehicleSpeed = 40;       % km/h

%% CURRENT LANE

currentLane = "EGO LANE";

%% ROAD POLICY

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

end

%% ADAS DECISION

if currentLane == recommendedLane
    alert = "LANE OK";
else
    alert = "LANE CHANGE RECOMMENDED";
end

%% DISPLAY

disp("======================================");
disp("          ADAS LANE GUIDANCE");
disp("======================================");

disp("Vehicle Type:");
disp(vehicleType);

fprintf("Vehicle Speed: %.1f km/h\n",vehicleSpeed);

disp("Current Lane:");
disp(currentLane);

disp("Recommended Lane:");
disp(recommendedLane);

disp("ADAS Status:");
disp(alert);

disp("======================================");