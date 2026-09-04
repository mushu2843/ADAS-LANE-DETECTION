clc;
clear;
close all;

%% Vehicle Information

vehicleType = "CAR";
vehicleSpeed = 40;

currentLane = "EGO LANE";
recommendedLane = "LEFT";

distanceAhead = 11.13;

%% ADAS Decision

if distanceAhead < 10

    safetyStatus = "DANGER";
    finalAction = "BRAKE IMMEDIATELY";

elseif distanceAhead < 20

    safetyStatus = "CAUTION";
    finalAction = "SLOW DOWN / MAINTAIN DISTANCE";

elseif vehicleSpeed > 80

    safetyStatus = "WARNING";
    finalAction = "REDUCE SPEED";

elseif currentLane ~= recommendedLane

    safetyStatus = "ADVISORY";
    finalAction = "LANE CHANGE ADVISED";

else

    safetyStatus = "SAFE";
    finalAction = "NORMAL DRIVING";

end

%% Create Dashboard

figure("Color","black");

axis off;

text(0.05,0.90,"ADAS DRIVER ASSISTANCE SYSTEM", ...
    "Color","white","FontSize",20,"FontWeight","bold");

text(0.05,0.78,sprintf("VEHICLE TYPE     : %s",vehicleType), ...
    "Color","white","FontSize",15);

text(0.05,0.68,sprintf("VEHICLE SPEED    : %.1f km/h",vehicleSpeed), ...
    "Color","white","FontSize",15);

text(0.05,0.58,sprintf("CURRENT LANE     : %s",currentLane), ...
    "Color","white","FontSize",15);

text(0.05,0.48,sprintf("RECOMMENDED LANE : %s",recommendedLane), ...
    "Color","yellow","FontSize",15);

text(0.05,0.38,sprintf("DISTANCE AHEAD   : %.2f m",distanceAhead), ...
    "Color","white","FontSize",15);

text(0.05,0.28,sprintf("SAFETY STATUS    : %s",safetyStatus), ...
    "Color","yellow","FontSize",16,"FontWeight","bold");

text(0.05,0.15,sprintf("ADAS ACTION      : %s",finalAction), ...
    "Color","yellow","FontSize",18,"FontWeight","bold");

title("ADAS Guidance Dashboard");
