clc;
clear;
close all;

%% =====================================
% ADAS VALIDATION TEST
% ======================================

% Test scenarios
vehicleType = ["CAR"; "CAR"; "BUS"; "TRUCK"; "CAR"];
vehicleSpeed = [40; 90; 45; 60; 25];
distanceAhead = [25; 8; 15; 30; 50];

numberOfTests = length(vehicleType);

%% Results

results = strings(numberOfTests,1);

disp("==============================================");
disp("          ADAS VALIDATION TEST");
disp("==============================================");

for i = 1:numberOfTests

    %% Safety Decision

    if distanceAhead(i) < 10
        safetyStatus = "DANGER";
        finalAction = "BRAKE IMMEDIATELY";

    elseif distanceAhead(i) < 20
        safetyStatus = "CAUTION";
        finalAction = "SLOW DOWN";

    elseif vehicleSpeed(i) > 80
        safetyStatus = "WARNING";
        finalAction = "REDUCE SPEED";

    else
        safetyStatus = "SAFE";
        finalAction = "NORMAL DRIVING";
    end

    results(i) = finalAction;

    %% Display Test

    fprintf("\nTest %d\n",i);
    fprintf("Vehicle Type   : %s\n",vehicleType(i));
    fprintf("Speed          : %.1f km/h\n",vehicleSpeed(i));
    fprintf("Distance       : %.1f m\n",distanceAhead(i));
    fprintf("Safety Status  : %s\n",safetyStatus);
    fprintf("ADAS Action    : %s\n",finalAction);

end

disp("==============================================");
disp("       VALIDATION TEST COMPLETED");
disp("==============================================");