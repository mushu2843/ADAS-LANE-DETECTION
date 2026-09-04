clc;
clear;
close all;

%% =====================================
%  INPUT VEHICLE STATE
% ======================================

vehicleType = "CAR";
vehicleSpeed = 40;          % km/h

currentLane = "EGO LANE";
recommendedLane = "LEFT";

distanceAhead = 11.13;      % meters


%% =====================================
%  1. DISTANCE SAFETY DECISION
% ======================================

if distanceAhead < 10

    safetyStatus = "DANGER";
    distanceAction = "BRAKE / SLOW DOWN";

elseif distanceAhead < 20

    safetyStatus = "CAUTION";
    distanceAction = "MAINTAIN SAFE DISTANCE";

else

    safetyStatus = "SAFE";
    distanceAction = "DISTANCE OK";

end


%% =====================================
%  2. SPEED DECISION
% ======================================

if vehicleSpeed < 30

    speedStatus = "LOW SPEED";

elseif vehicleSpeed <= 60

    speedStatus = "MODERATE SPEED";

elseif vehicleSpeed <= 80

    speedStatus = "HIGH SPEED";

else

    speedStatus = "VERY HIGH SPEED";

end


%% =====================================
%  3. LANE DECISION
% ======================================

if currentLane == recommendedLane

    laneStatus = "LANE OK";

else

    laneStatus = "LANE CHANGE ADVISED";

end


%% =====================================
%  4. FINAL ADAS DECISION FUSION
% ======================================

if safetyStatus == "DANGER"

    finalADASAction = "BRAKE IMMEDIATELY";

elseif speedStatus == "VERY HIGH SPEED"

    finalADASAction = "REDUCE SPEED";

elseif safetyStatus == "CAUTION"

    finalADASAction = "SLOW DOWN AND MAINTAIN DISTANCE";

elseif laneStatus == "LANE CHANGE ADVISED"

    finalADASAction = "LANE CHANGE ADVISED";

else

    finalADASAction = "NORMAL DRIVING";

end


%% =====================================
%  DISPLAY RESULTS
% ======================================

disp("==========================================");
disp("          ADAS DECISION FUSION");
disp("==========================================");

fprintf("Vehicle Type       : %s\n",vehicleType);
fprintf("Vehicle Speed      : %.1f km/h\n",vehicleSpeed);
fprintf("Current Lane       : %s\n",currentLane);
fprintf("Recommended Lane   : %s\n",recommendedLane);
fprintf("Distance Ahead     : %.2f m\n",distanceAhead);

disp("------------------------------------------");

fprintf("Speed Status       : %s\n",speedStatus);
fprintf("Safety Status      : %s\n",safetyStatus);
fprintf("Distance Action    : %s\n",distanceAction);
fprintf("Lane Status        : %s\n",laneStatus);

disp("------------------------------------------");

fprintf("FINAL ADAS ACTION  : %s\n",finalADASAction);

disp("==========================================");