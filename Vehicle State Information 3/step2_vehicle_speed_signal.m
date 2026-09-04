clc;
clear;
close all;

%% VEHICLE SPEED SIGNAL

time = 0:1:10;

vehicleSpeed = [30 32 35 38 40 42 45 43 40 38 35];

%% Display Speed Information

disp("======================================");
disp("        VEHICLE SPEED SIGNAL");
disp("======================================");

for i = 1:length(time)

    fprintf("Time: %2d sec   Speed: %.1f km/h\n", ...
        time(i), vehicleSpeed(i));

end

disp("======================================");

%% Plot Speed

figure;

plot(time,vehicleSpeed,"LineWidth",2);

grid on;

xlabel("Time (seconds)");
ylabel("Vehicle Speed (km/h)");

title("Ego Vehicle Speed Signal");